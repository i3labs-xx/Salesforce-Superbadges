@isTest
private class BillingCalloutServiceTest {
  private static Opportunity opp;
  private static Project__c proj;
  private static ServiceCredentials__c servCred;

  private static void prepareData(){
    opp = new Opportunity();
    opp.Name = 'TestOpp1';
    opp.CloseDate = Date.today();
    opp.StageName = 'Prospecting';
    insert opp;

    proj = new Project__c();
    proj.Name = 'Test Proj';
    proj.Billable_Amount__c = 15000;        
    proj.ProjectRef__c = 'Proj_Ref';
    proj.Status__c = 'Running';
    proj.Opportunity__c = opp.Id;
    insert proj;
        
    servCred = new ServiceCredentials__c();
    servCred.Name = 'BillingServiceCredential';
    servCred.Username__c = 'bsUsr1';
    servCred.Password__c = 'bsPass1';
    insert servCred;
  }

  @isTest
  private static void callBillingServiceTest_Success() {
    prepareData();
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());

    Test.startTest();
      Project__c pr = [SELECT Status__c, ProjectRef__c,Billable_Amount__c FROM Project__c WHERE Id =: proj.Id];
      proj.Status__c = 'Billable';
      update proj;
    Test.stopTest();

    String updatedStatus = [Select Status__c From Project__c Where Id =: proj.Id].Status__c;
    System.assertEquals(updatedStatus, 'Billed', 'Project status should be updated to billed as the mock response returned is OK');
  }

  @isTest
  private static void callBillingServiceTest_Failure() {
    prepareData();
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());

    Test.startTest();
      Project__c pr = [SELECT Status__c, ProjectRef__c,Billable_Amount__c FROM Project__c WHERE Id =: proj.Id];
      proj.Status__c = 'Billable';
      update proj;
    Test.stopTest();

    String updatedStatus = [Select Status__c From Project__c Where Id =: proj.Id].Status__c;
    System.assertEquals(updatedStatus, 'Billable', 'Project status should not be updated to billed as the mock response returned is FAILED');
  }
}