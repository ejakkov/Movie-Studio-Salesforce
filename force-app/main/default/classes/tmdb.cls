public with sharing class tmdb {
    private static final String API_KEY = '5bfef77f0d03fea766a8ab7ddfe11ab1';
    private static final String API_KEY_PARAM_NAME = 'api_key';
    private static final String API_VERSION = '3';

    private String authQueryParameter {
        get {
            return API_KEY_PARAM_NAME + '=' + API_KEY;
        }
    }

    private static final String BASE_URL = 'https://api.themoviedb.org/';

    private string buildResourceUrl(String resourceName) {
        return BASE_URL + API_VERSION + resourceName;
    }

    private HttpRequest authenticateRequest(HttpRequest request) {
        String endpoint = request.getEndpoint();
        if (endpoint.contains('?')) {
            endpoint += '&' + authQueryParameter;
        } else {
            endpoint += '?' + authQueryParameter;
        }
        request.setEndpoint(endpoint);

        return request;
    }

    // public tmdbGenreListResponse genreList() {
    //     String resourceName = '/genre/movie/list';
    //     String endpoint = buildResourceUrl(resourceName);
    //     HttpRequest request = new HttpRequest();
    //     request.setMethod('GET');
    //     request.setEndpoint(endpoint);
    //     request = authenticateRequest(request);
    //     Http http = new Http();
    //     HttpResponse response = http.send(request);

    // //     tmdbGenreListResponse tmdbResponse = (tmdbGenreListResponse) JSON.deserialize(response.getBody(), tmdbGenreListResponse.class);
    //     return tmdbResponse;
    // }
    @AuraEnabled(cacheable=true)

    public static List<tmdbSearchMovieResult> getMovieByTitle(String title) {
        tmdb tmdbInstance = new tmdb(); // Create an instance of the class
        String resourceName = '/search/movie';
        String endpoint = tmdbInstance.buildResourceUrl(resourceName);
        endpoint += '?query=' + EncodingUtil.urlEncode(title, 'UTF-8');
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint);
        System.debug(title);
    
        request = tmdbInstance.authenticateRequest(request); // Call the instance method
        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug(response.getBody());
    
        tmdbSearchMovieResponse result = (tmdbSearchMovieResponse) JSON.deserialize(response.getBody(), tmdbSearchMovieResponse.class);

        System.debug(result.results);
        return result.results;
    }

    @AuraEnabled(Cacheable=false)
    public static void getModifyMovie(Integer tmdbid, Id currentMovieId){
        tmdb tclass = new tmdb();
        Movie__c currentMovie = [SELECT Description__c, Title__c, Revenue__c, Rating__c, PosterURL__c, Budget__c, tmdbId__c FROM Movie__c WHERE Id =: currentMovieId];
        tmdbMovieDetailsResponse response = tclass.getMovieDetails(tmdbid);
        System.debug( currentMovie.Title__c);
        System.debug( response.original_title);
        if(currentMovie.tmdbId__c == null){
            currentMovie.TMDBSyncDate__c = System.today();
            currentMovie.tmdbId__c = tmdbid;
            currentMovie.Description__c = response.overview;
            currentMovie.Title__c = response.original_title;
            currentMovie.Revenue__c = response.revenue;
            currentMovie.Rating__c = response.vote_average;
            currentMovie.PosterURL__c = response.poster_path;
            currentMovie.Budget__c = response.budget;   
            
            upsert currentMovie; 
        }
        
    }

    public tmdbMovieDetailsResponse getMovieDetails(integer movie_id){
        String resourceName = '/movie/' + String.ValueOf(movie_id);
        String endpoint = buildResourceUrl(resourceName);
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint);

        request = authenticateRequest(request);
        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug(response.getBody());
     

        tmdbMovieDetailsResponse result = (tmdbMovieDetailsResponse) JSON.deserialize(response.getBody(), tmdbMovieDetailsResponse.class);
        return result;
    }
}