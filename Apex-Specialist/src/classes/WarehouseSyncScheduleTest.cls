@isTest
private class WarehouseSyncScheduleTest {
	public static String CRON_EXP = '0 0 1 * * ?';

	@isTest 
	private static void test_method_one() {
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
		String jobId = System.schedule('Testing nightly schedule', CRON_EXP, new WarehouseSyncSchedule());
		Test.stopTest();

		Boolean run = false;
		if(jobId != null) {
			run = true;
		}
		System.assert(run);
	}
}