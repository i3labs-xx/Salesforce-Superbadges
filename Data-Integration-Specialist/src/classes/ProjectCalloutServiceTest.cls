@isTest
private class ProjectCalloutServiceTest {
  private static Account acc;
  private static Opportunity opp;

  private static void prepareTestData() {
    acc = new Account(Name='Test Account');
    insert acc;
    opp = new Opportunity(Name='Opp1', CloseDate=date.today(), Amount=15000, Account=acc,StageName='Prospecting');
    insert opp;
    insert new ServiceTokens__c(Name='ProjectServiceToken',Token__c = '91cb354d-8c39-4bb7-9309-be014ea6e57b');
  }

  @isTest
  private static void testPostCallout() {
    prepareTestData();
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock(opp));
    ProjectCalloutService.PostOpportunityToPMS(new List<Id>{opp.id});
    Test.stopTest();
    Opportunity updatedOpp = [Select Id, StageName From Opportunity Where Id =: opp.id];
    System.assertEquals(updatedOpp.StageName, 'Submitted Project');
  }

  @isTest
  private static void testPostCallout_Fail() {
    prepareTestData();
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure(opp));
    ProjectCalloutService.PostOpportunityToPMS(new List<Id>{opp.id});
    Test.stopTest();
    Opportunity updatedOpp = [Select Id, StageName From Opportunity Where Id =: opp.id];
    System.assertEquals(updatedOpp.StageName, 'Resubmit Project');
  }
}