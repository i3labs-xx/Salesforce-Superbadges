public class MaintenanceRequestHelper {
    public static void createNewMaintenanceRequest(List<Case> updatedMaintenanceRequest, Map<Id, Case> mapUpdatedMaintenanceRequest) {
        List<Case> newMaintenanceRequest = new List<Case>();
        List<Case> closedMR = [Select Id, Status, Vehicle__c, Equipment__c, Equipment__r.Maintenance_Cycle__c,Type From Case 
                                Where Id IN :mapUpdatedMaintenanceRequest.keySet() 
                                AND Status = 'Closed' AND (Type = 'Repair' OR Type = 'Routine Maintenance')
                              ]; 

        if(!closedMR.isEmpty()) {
            for(Case c : closedMR) {
                Date d = date.today() + c.Equipment__r.Maintenance_Cycle__c.intValue();
                newMaintenanceRequest.add( new Case(Type='Routine Maintenance', 
                                                        Status='New', 
                                                        Origin='web', 
                                                        Vehicle__c=c.Vehicle__c,
                                                        Equipment__c=c.Equipment__c,
                                                        Subject='Future Routine Checkup Maintenance Request',
                                                        Date_Reported__c= date.today(),
                                                        Date_Due__c=d)
                                         );
            }

            if(!newMaintenanceRequest.isEmpty()) {
                insert newMaintenanceRequest;
            }
        }
    }
}