public class tmdbFutureClass
{
    @future (callout=true)
    public static void myFutureMethod(List<integer> listOfId){
        List <tmdbMovieDetailsResponse> results = new List<tmdbMovieDetailsResponse>();
        tmdb tmdbClass = new tmdb();
        List <Movie__c> movieList = new List<Movie__c>();
       
        for(integer id : listOfId){
            tmdbMovieDetailsResponse response = new tmdbMovieDetailsResponse();
            response = tmdbClass.getMovieDetails(id);
            Movie__c currentMovie = new Movie__c();
            currentMovie = [SELECT Description__c, Title__c, Revenue__c, Rating__c, PosterURL__c, Budget__c FROM Movie__c WHERE tmdbId__c=:id];
            currentMovie.Description__c = response.overview;
            currentMovie.Title__c = response.original_title;
            currentMovie.Revenue__c = response.revenue;
            currentMovie.Rating__c = response.vote_average;
            currentMovie.PosterURL__c = response.poster_path;
            currentMovie.Budget__c = response.budget;
            movieList.add(currentMovie);
        }   
        system.debug(movieList);
        if(movieList != null) update movieList;
    }
}