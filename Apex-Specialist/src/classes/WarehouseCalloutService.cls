public with sharing class WarehouseCalloutService {
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    @future (callout=true)
    public static void runWarehouseEquipmentSync() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
            List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
            List<Product2> syncedEquipments = new List<Product2>();

            for(Object o : results) {
                Map<String, Object> equipObj = (Map<String, Object>)o;
                syncedEquipments.add(new Product2(name=(String)equipObj.get('name'),
                    cost__c = (Decimal)equipObj.get('cost'),
                    Current_Inventory__c = (Integer)equipObj.get('quantity'),
                    Lifespan_Months__c = (Integer)equipObj.get('lifespan'),
                    Maintenance_Cycle__c = (Integer)equipObj.get('maintenanceperiod'),
                    Replacement_Part__c = (Boolean)equipObj.get('replacement'),
                    Warehouse_SKU__c = (String)equipObj.get('sku'),
                    ProductCode = (String)equipObj.get('_id'))
                );
            }
            
            if(!syncedEquipments.isEmpty()) {
                upsert syncedEquipments;
            }
        }
    }
}