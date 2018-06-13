public class BoatSearchResults {
    @AuraEnabled
    public static List<Boat__c> getBoats(String boatTypeId){
        if(!String.isEmpty(boatTypeId)) {
            return [Select Id, Picture__c, Contact__r.Name From Boat__c Where BoatType__c =: boatTypeId ];
        }
        return [Select Id From Boat__c];
    }
}