public class UpdateMovieBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    public String query;
 
    public Database.QueryLocator start(Database.BatchableContext BC){
        List<Movie__c> listOfMovies = new List<Movie__c>();
        System.debug('BATCH STARTED');
        query = 'SELECT tmdbId__c,TMDBSyncDate__c FROM Movie__c WHERE tmdbId__c != null';
        System.debug(query);
       return Database.getQueryLocator(query);
    }
 
    public void execute(Database.BatchableContext BC, List<Movie__c> scope){
      System.debug('Start execution');
      List<Movie__c> scopeToUpdate = new List<Movie__c>();
       for(Movie__c currentMovie : scope){
         if (currentMovie.TMDBSyncDate__c < System.today().addMonths(-1) || currentMovie.TMDBSyncDate__c == null){
            scopeToUpdate.add(currentMovie);
         }
       }
       tmdb tmdbClass = new tmdb();
       tmdbMovieDetailsResponse response = new tmdbMovieDetailsResponse();
       for(Movie__c currentMovie : scopeToUpdate){
         response = tmdbClass.getMovieDetails(Integer.ValueOf(currentMovie.tmdbId__c));
         currentMovie.Revenue__c = response.revenue;
         currentMovie.Rating__c = response.vote_average;
         currentMovie.TMDBSyncDate__c = System.today();
       }
       
       DataBase.update(scopeToUpdate);
       System.debug('Batch execution finished');
    }
 
    public void finish(Database.BatchableContext BC){
      System.debug('BATCH FINISH');
    }
      
  }