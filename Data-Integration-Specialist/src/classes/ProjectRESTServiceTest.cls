@isTest
private class ProjectRESTServiceTest {

  @isTest
  private static void postProjectDataTest() {
    Opportunity opp = new Opportunity(Name='Opp1', CloseDate=date.today(), Amount=15000, StageName='Prospecting', DeliveryInstallationStatus__c='Yet to begin');
    insert opp;
    
    String value = ProjectRestService.postProjectData('34521', 'Test Project', opp.Id, date.today(), date.today()+10, 15000, 'Billed');

    Opportunity updatedOpp = [Select DeliveryInstallationStatus__c From Opportunity Where Id =: opp.Id];
    Project__c proj = [Select ProjectRef__c, Name, Start_Date__c, End_Date__c, Billable_Amount__c, Status__c, Opportunity__c From Project__c Where Opportunity__c =: opp.Id];
    System.assertEquals('OK', value);
    System.assertEquals('In progress', updatedOpp.DeliveryInstallationStatus__c, 'Opportunity status should be updated to In progress');
    System.assertEquals('34521', proj.ProjectRef__c, 'Associated project should have 34521 as updated reference');
    System.assertEquals('Test Project', proj.Name, 'Associated project should have Test Project as updated Name');
    System.assertEquals(date.today(), proj.Start_Date__c, 'Associated project should have updated date');
    System.assertEquals(date.today()+10, proj.End_Date__c, 'Associated project should have updated date');
    System.assertEquals(15000, proj.Billable_Amount__c, 'Associated project should have 15000 as updated amount');
    System.assertEquals('Billed', proj.Status__c, 'Associated project should have Billed as updated status');
    System.assertEquals(opp.Id, proj.Opportunity__c, 'Associated project should associated with opportunity');
  }

  @isTest
  private static void postProjectDataTest_Failure() {
    Opportunity opp = new Opportunity(Name='Opp1', CloseDate=date.today(), Amount=15000, StageName='Prospecting', DeliveryInstallationStatus__c='Yet to begin');
    insert opp;
    String value = ProjectRestService.postProjectData('34521', 'Test Project', '123', date.today(), date.today()+10, 15000, null);
    System.assertEquals('List has no rows for assignment to SObject', value, 'Error message needs to be returned');
  }
}