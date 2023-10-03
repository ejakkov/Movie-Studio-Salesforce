@isTest
global class FirstTaskTest {
    @isTest
    static void testMovieTrigger() {
        // Create test data for MovieTrigger
        List<Movie__c> testMovies = new List<Movie__c>();
        Test.setMock(HttpCalloutMock.class, new MyHttpCalloutMock());
        Movie__c movie = new Movie__c();
        movie.Title__c = 'Test x';
        movie.tmdbId__c = 123;
        testMovies.add(movie);
        Test.startTest();
        upsert testMovies;
        Test.stopTest();
    }

    @isTest
    static void testGetMovieDetails(){
          // Set up test data
          Integer movieId = 123; 
        
          // Set up mock callout
          Test.setMock(HttpCalloutMock.class, new MyHttpCalloutMock());
          
          // Call the method to test
          tmdb tClass = new tmdb();
          tmdbMovieDetailsResponse result = tClass.getMovieDetails(movieId);
          
          // Perform assertions on the response
          System.assertEquals('The Lord of the Rings', result.original_title, 'Title mismatch');
          System.assertEquals('The Fellowship of the Ring embark on a journey to destroy the One Ring and end Sauron\'s reign over Middle-earth.', result.overview, 'Overview mismatch');
          System.assertEquals('3.047142E7', String.ValueOf(result.revenue), 'Revenue mismatch');
          System.assertEquals(6.55, result.vote_average, 'Rating mismatch');
          System.assertEquals('/liW0mjvTyLs7UCumaHhx3PpU4VT.jpg', result.poster_path, 'Poster URL mismatch');
          System.assertEquals(4000000.0, result.budget, 'Budget mismatch');
    }
    global class MyHttpCalloutMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {
            // Create a mock response here
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
            res.setBody('{"overview": "The Fellowship of the Ring embark on a journey to destroy the One Ring and end Sauron\'s reign over Middle-earth.", "original_title": "The Lord of the Rings", "revenue": 3.047142E7, "vote_average": 6.55, "poster_path": "/liW0mjvTyLs7UCumaHhx3PpU4VT.jpg", "budget": 4000000.0}');
            return res;
        }
}
}