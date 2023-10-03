public class BatchScheduler implements Schedulable {
    public void execute(SchedulableContext context) {
        UpdateMovieBatch batchJob = new UpdateMovieBatch();
        Database.executeBatch(batchJob);
        System.schedule('UpdateMovieBatch', '0 00 18 * * ?', new BatchScheduler());

    }
}