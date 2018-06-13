public without sharing class ChartHelper {
    @AuraEnabled
    public static List<chartData> GetInventory(){
        List<chartData> cht = new List<chartData>();
        
        AggregateResult[] results = [Select Family, SUM(Quantity_Remaining__c) From Product2 Where IsActive = true AND Quantity_Remaining__c >=0 GROUP BY Family];

        for(AggregateResult ar : results) {
            cht.add(new chartData(String.ValueOf(ar.get('Family')), Integer.ValueOf(ar.get('expr0'))));
        }
        return cht;
    }

    public class ChartData {
        public String name {get;set;}
        public Decimal val {get;set;}

        public ChartData(String name, Decimal val){
            this.name = name;
            this.val = val;
        }
    }
}