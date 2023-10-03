@isTest
global class TestMovieSync {
    @isTest static void testBatchJob() {
        List<Movie__c> testMovieList = new List<Movie__c>();
        Test.setMock(HttpCalloutMock.class, new MyHttpCalloutMock());

        // Create test data
        
        // 1.case 
        Movie__c movie1 = new Movie__c();
        movie1.tmdbId__c = 191;
        movie1.TMDBSyncDate__c = System.today().addMonths(-2);
        testMovieList.add(movie1);
        // 2.case
        Movie__c movie2 = new Movie__c();
        movie2.tmdbId__c = 192;
        movie2.TMDBSyncDate__c = System.today().addDays(-10);
        testMovieList.add(movie2);
        // 3.case
        Movie__c movie3 = new Movie__c();
        movie3.tmdbId__c = 193;
        testMovieList.add(movie3);
        insert testMovieList;
        Test.startTest();
        UpdateMovieBatch umb = new UpdateMovieBatch();
        DataBase.executeBatch(umb);
        Test.stopTest();
        List<Movie__c> listOfMovies = [SELECT TMDBSyncDate__c FROM Movie__c WHERE tmdbId__c= 191 OR tmdbId__c=192 OR tmdbId__c=193];
        System.debug(listOfMovies);
        for(Movie__c currentMovie : listOfMovies){
            if(currentMovie.TMDBSyncDate__c < System.today().addMonths(-1) || currentMovie.TMDBSyncDate__c == null){
                System.assertEquals(currentMovie.TMDBSyncDate__c, system.today(), 'Date mismatch');
            } else{
                System.assertNotEquals(movie2.TMDBSyncDate__c, system.today(), 'Date mismatch');
            }
            
            
        }
        
        
        
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

    @isTest
    static void testScheduler(){
        Test.startTest();

        Integer hours = Datetime.now().hour()+1;
        Integer minutes = Datetime.now().minute();
        Integer seconds = Datetime.now().second();

        String nextExecutionTime = String.valueOf(seconds)+' '+String.valueOf(minutes)+' '+String.valueOf(hours)+' * * ?';
        BatchScheduler scheduler = new BatchScheduler();
        Id jobId = System.schedule('test schedule', nextExecutionTime, scheduler);

        Test.stopTest();

        CronTrigger cron = [SELECT TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(hours, cron.NextFireTime.hour(), 'hours (current+1) do not match');
        System.assertEquals(minutes, cron.NextFireTime.minute(), 'minutes do not match');

    }
}