@RestResource(urlMapping='/project/*')
global class ProjectRESTService {
    @HttpPost
    global static String postProjectData(String projRef, String projName, String oppId, Date startDate, Date endDate, Decimal Amount, String status) {
        String returnValue;
        SavePoint sp = Database.setSavepoint();

        try {
            if(oppId !=null && projRef !=null) {
                Opportunity opp = [Select DeliveryInstallationStatus__c From Opportunity Where Id =: oppId];
                opp.DeliveryInstallationStatus__c = 'In Progress';
                update opp;

                Project__c proj = new Project__c();
                proj.ProjectRef__c = projRef;
                proj.Name = projName;
                proj.Start_Date__c = startDate;
                proj.End_Date__c = endDate;
                proj.Billable_Amount__c = Amount;
                proj.Status__c = status;
                proj.Opportunity__c = opp.Id;
                upsert proj;

                returnValue = 'OK';
            }
        }
        catch (Exception ex) {
            returnValue = ex.getMessage();
            Database.rollback(sp);
        }
        return returnValue;
    }
}