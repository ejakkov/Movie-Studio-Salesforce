trigger MovieTrigger on Movie__c (after insert) {
    List <Integer> listOfId = new List<Integer>();
    for(Movie__c newMovie : Trigger.new){
        listOfId.add(Integer.ValueOf(newMovie.tmdbId__c));
    }
    if (listOfId != null ){
        tmdbFutureClass.myFutureMethod(listOfId);
    }
}