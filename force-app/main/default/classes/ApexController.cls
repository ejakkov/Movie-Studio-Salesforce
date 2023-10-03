public with sharing class ApexController {
    @AuraEnabled(cacheable=true)
    public static Movie__c getMoviesPosterURL(Id movieId) {
        Movie__c movie = [SELECT Id, Title__c, Rating__c, Genre__c, PosterURL__c, tmdbId__c FROM Movie__c WHERE Id = :movieId];
        movie.PosterURL__c = 'https://image.tmdb.org/t/p/original' + movie.PosterURL__c;
        System.debug(movie);
        return movie;
    }
    @AuraEnabled(cacheable=true)
    public static List<Movie__c> displayedMovies(String genre) {
        System.debug(genre);
        List<Movie__c> movies = new List<Movie__c>();
        if(genre == ''){
            movies = [SELECT Id, Title__c, Rating__c, Genre__c, PosterURL__c FROM Movie__c LIMIT 10];
        } else{
            if(genre == 'Science Fiction') genre = 'Science_Fiction';
            movies = [SELECT Id, Title__c, Rating__c, Genre__c, PosterURL__c FROM Movie__c WHERE Genre__c INCLUDES (:genre) LIMIT 10]; 
        }
        
        for(Movie__c currentMovie : movies){
            currentMovie.PosterURL__c = 'https://image.tmdb.org/t/p/original' + currentmovie.PosterURL__c;
        }
        System.debug(movies);
        return movies;
    }
        
    @AuraEnabled(cacheable=true)
    public static List<String> processGenrePicklistValues() {
        Schema.DescribeSObjectResult describeResult = Schema.Movie__c.SObjectType.getDescribe();
        Schema.DescribeFieldResult genreField = describeResult.fields.getMap().get('Genre__c').getDescribe();
        List<String> genres = new List<String>();
        List<Schema.PicklistEntry> genrePicklistValues = genreField.getPicklistValues();
    
        for (Schema.PicklistEntry picklistValue : genrePicklistValues) {
            genres.add(picklistValue.getLabel());
        }
        return genres;
    }

    @AuraEnabled(cacheable=true)
    public static String getContentVersionId(String fileId) {
        // Query ContentVersion to retrieve the Id based on the fileId
        // Return the ContentVersion Id as a String
        return 'ContentVersionId'; // Replace with the actual Id
    }

    @AuraEnabled(cacheable=true)
    public static String getFileContents(String contentVersionId) {
        // Query ContentVersion to retrieve the ContentDocumentId
        // Query ContentDocument to retrieve the actual file content
        // Return the file content as a String
        return 'FileContents'; // Replace with the actual content
    }
}