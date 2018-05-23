@isTest
private class WarehouseCalloutServiceTest {
  @isTest
  private static void testGetCallout(){
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
    WarehouseCalloutService.runWarehouseEquipmentSync();
    Test.stopTest();
    System.assertEquals(1, [Select count() From Product2]);
  }
}