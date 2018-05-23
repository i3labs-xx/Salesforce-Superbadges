@isTest
private class MaintenanceRequestHelperTest {
	private static List<Case> newCases = new List<Case>();
	private static List<Vehicle__c> newVehicles = new List<Vehicle__c>();
	private static List<Product2> newEquipments = new List<Product2>();
	private static Set<Id> caseIds = new Set<Id>();

	private static void loadData() {
		for(Integer i=0;i<300;i++) {
			newVehicles.add( new Vehicle__c(Name='Vehicle ' + i));
			newEquipments.add( new Product2(name='Equipment ' + i, cost__c = 30.0 + i, 
				Current_Inventory__c = 10, Lifespan_Months__c = (math.random() * 10).intValue(),
				Maintenance_Cycle__c = (math.random() * 10).intValue(), Replacement_Part__c = true,
				Warehouse_SKU__c = '', ProductCode = '')
			);
		}
		insert newVehicles;
		insert newEquipments;

		for(Integer i=0;i<300;i++) {
			if(i<150) {
				newCases.add( new Case(Type='Routine Maintenance', Status='New', Origin='web', 
					Vehicle__c=newVehicles[i].id, Equipment__c=newEquipments[i].id, 
					Subject='Future Routine Checkup Maintenance Request', Date_Reported__c= date.today(), 
					Date_Due__c=date.today())
				);
			}
			else {
				newCases.add( new Case(Type='Repair', Status='New', Origin='web', 
					Vehicle__c=newVehicles[i].id, Equipment__c=newEquipments[i].id,
					Subject='Future Routine Checkup Maintenance Request', 
					Date_Reported__c= Date.today(), Date_Due__c=Date.today())
				);
			}
		}
		insert newCases;
	}

	private static void processRecords(String status) {
		loadData();
		for(Case c : newCases) {
			caseIds.add(c.Id);
		}

		for(Integer i=0;i<300;i++) {
			newCases[i].Status = status;
		}
		update newCases;
	}
	
	@isTest 
	private static void createNewMaintenanceRequestTest() {
		processRecords('Closed');

		for(Case c : [Select Status From Case Where Id IN: caseIds]) {
			System.assertEquals(c.Status, 'Closed', 'All the cases updated should be closed');
		}

		Integer newCaseCount = [Select count() From Case Where Status = 'New' AND Type = 'Routine Maintenance'];
		System.assertEquals(newCaseCount, 300, '300 cases of type Routine Maintenance with status new should be created');
	}

	@isTest 
	private static void createNewMaintenanceRequestTest_Negative() {
		processRecords('Working');

		for(Case c : [Select Status From Case Where Id IN: caseIds]) {
			System.assertEquals(c.Status, 'Working', 'All the cases updated should be closed');
		}

		Integer newCaseCount = [Select count() From Case Where Status = 'New' AND Type = 'Routine Maintenance'];
		System.assertEquals(newCaseCount, 0, 'Zero cases of type Routine Maintenance with status new should be created');
	}
}