public class ParsingMovieInJson{
    public class ScriptMovieWrapper {
        public Script__c script;
        public Movie__c movie;
    
        public ScriptMovieWrapper(Script__c script, Movie__c movie) {
            this.script = script;
            this.movie = movie;
        }
    }
    @AuraEnabled
    public static void ParseMovie(Id documentId){
        String JSONString ='';
        try {
            // Query ContentVersion to get the JSON file's content
            ContentVersion content = [SELECT VersionData FROM ContentVersion WHERE Id = :documentId];
            
            // Convert binary data to string
            JSONString = content.VersionData.toString();
            
            // Now you have the JSON content as a string
        } catch (Exception ex) {
            // Handle any exceptions
            System.debug('An error occurred: ' + ex.getMessage());
        }
        List<JSONParsingResult> result =  (List<JSONParsingResult>)JSON.deserialize(JSONString, List<JSONParsingResult>.class);
        List<Movie__c> listOfMovies = [SELECT tmdbId__c FROM Movie__c WHERE tmdbId__c != null];
        List<Integer> listOfTmdbIds = new List<Integer>();
        List<Movie__c> listOfMoviesToImport = new List<Movie__c>();
        List<Movie__c> listOfMoviesToCreateScript = new List<Movie__c>();
        Map<Script__c, Movie__c> MapOfScriptsAndMovies = new Map<Script__c, Movie__c>();
        List<ScriptMovieWrapper> scriptMovieWrappers = new List<ScriptMovieWrapper>();



        List<Script__c> listOfScripts = new List<Script__c>();

        for(Movie__c movie : listOfMovies){
            listOfTmdbIds.add(Integer.ValueOf(movie.tmdbId__c));
        }
        System.debug('Before the main loop');
        for(JSONParsingResult currentMovie : result){
            System.debug('In the main loop');

            if(!listOfTmdbIds.contains(Integer.ValueOf(currentMovie.Tmdb_id))){
                
                Movie__c movieToInsert = new Movie__c();
                movieToInsert.LegacyId__c = currentMovie.Id;
                movieToInsert.Title__c = currentMovie.Name;
                movieToInsert.tmdbId__c = decimal.Valueof(currentMovie.Tmdb_id);
                movieToInsert.genre__c = currentMovie.genre;
                movieToInsert.rating__c = currentMovie.rating;
                movieToInsert.budget__c = currentMovie.budget;
                movieToInsert.Revenue__c = currentMovie.revenue;
             
                if(currentMovie.script == null){
                    System.debug('There is no script for this movie');
                } else{
                    try{
                        Script__c scriptExample = [SELECT LegacyId__c, Id FROM Script__c WHERE LegacyId__c=: currentMovie.script.get('id') LIMIT 1];
                        movieToInsert.Script__c = scriptExample.Id;
                        listOfMoviesToImport.add(movieToInsert);
                        System.debug('found;');
                    } catch(Exception e){
                        Script__c newScript = new Script__c();
                        newScript.Title__c = currentMovie.script.get('name');
                        newScript.LegacyId__c = currentMovie.script.get('id');
                        newScript.Description__c = currentMovie.script.get('description');
                        
                        listOfScripts.add(newScript);
                        scriptMovieWrapper ScriptAndMovie = new scriptMovieWrapper(newScript, movieToInsert);
                        scriptMovieWrappers.add(ScriptAndMovie);
                    }                     
                }
            } else{
                System.debug('Movie with such tmdb id exists');
            }
        }
        

        
        if(!listOfScripts.isEmpty()){
            upsert listOfScripts;
            System.debug(MapOfScriptsAndMovies);
            for(scriptMovieWrapper currentObject : scriptMovieWrappers){
                currentObject.movie.Script__c = currentObject.script.Id;
                listOfMoviesToImport.add(currentObject.movie);
            }
        }
        insert listOfMoviesToImport;
        System.debug('ParsingMovieInJson finished');
    }
}