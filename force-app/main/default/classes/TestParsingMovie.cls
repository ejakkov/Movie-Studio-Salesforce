@isTest
global class TestParsingMovie {
    @isTest
    static void NoMovieNoScriptInDB() {
        // Given: Provide the JSON string for testing
        String jsonString = '[{"Id":"1","Name":"TestMovie","Tmdb_id":"123","genre":"Action;Adventure","rating":8.5,"budget":100000000,"revenue":250000000,"script":{"id":"10","name":"TestScript","description":"A test script."}}]';
        Test.setMock(HttpCalloutMock.class, new MyHttpCalloutMock());

        // When: Call the method under test
        ParsingMovieInJson.ParseMovie(jsonString);
        
        // Then: Verify the results
        List<Movie__c> movies = [SELECT Id, Title__c, tmdbId__c, genre__c, rating__c, budget__c, Revenue__c, Script__c FROM Movie__c];
        List<Script__c> scripts = [SELECT Id, Title__c, LegacyId__c, Description__c FROM Script__c];
        System.debug(movies);
        System.assertEquals(1, movies.size());
        System.assertEquals('TestMovie', movies[0].Title__c);
        System.assertEquals(123, movies[0].tmdbId__c.intValue());
        System.assertEquals('Action;Adventure', movies[0].genre__c);
        System.assertEquals(8.5, movies[0].rating__c);
        System.assertEquals(100000000, movies[0].budget__c);
        System.assertEquals(250000000, movies[0].Revenue__c);
        System.assertEquals('TestScript', scripts[0].Title__c);
        System.assertEquals('10', scripts[0].LegacyId__c);
        System.assertEquals('A test script.', scripts[0].Description__c);
    }
    @isTest
    static void NoMoviesYesScriptsInDB(){
        String jsonString = '[{"Id":"1","Name":"TestMovie","Tmdb_id":"123","genre":"Action;Adventure","rating":8.5,"budget":100000000,"revenue":250000000,"script":{"id":"10","name":"TestScript","description":"A test script."}}]';
        Test.setMock(HttpCalloutMock.class, new MyHttpCalloutMock());
        Script__c testScript = new Script__c(
            LegacyId__c = '10',
            Title__c = 'TestScript',
            Description__c = 'A test script.'
        );
        insert testScript;
        List <Script__c> listOfTestScripts = [SELECT ID FROM Script__c];
        List<Movie__c> moviesBeforeTest = [SELECT Id FROM Movie__c];

        ParsingMovieInJson.ParseMovie(jsonString);        
        List<Movie__c> movies = [SELECT Id, Title__c, tmdbId__c, genre__c, rating__c, budget__c, Revenue__c, Script__c FROM Movie__c];

        List <Script__c> listOfTestScriptsAfterTest = [SELECT ID, Title__c, LegacyId__c, Description__c FROM Script__c];
        System.assertEquals(listOfTestScripts.size(), listOfTestScriptsAfterTest.size());        
        System.assertEquals(moviesBeforeTest.size()+1, movies.size());

        System.assertEquals('TestMovie', movies[0].Title__c);
        System.assertEquals(123, movies[0].tmdbId__c.intValue());
        System.assertEquals('Action;Adventure', movies[0].genre__c);
        System.assertEquals(8.5, movies[0].rating__c);
        System.assertEquals(100000000, movies[0].budget__c);
        System.assertEquals(250000000, movies[0].Revenue__c);
        System.assertEquals('TestScript', listOfTestScriptsAfterTest[0].Title__c);
        System.assertEquals('10', listOfTestScriptsAfterTest[0].LegacyId__c);
        System.assertEquals('A test script.', listOfTestScriptsAfterTest[0].Description__c);

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