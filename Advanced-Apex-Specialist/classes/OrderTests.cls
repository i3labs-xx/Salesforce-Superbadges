@isTest
public class OrderTests {
    @testSetup 
    public static void SetupTestData(){
        TestDataFactory.InsertTestData(1);
    }

    @isTest 
    public static void OrderUpdate_UnitTest(){

        Test.startTest();
            Order o = [SELECT Id, Status FROM Order LIMIT 1];
            Product2 p = [SELECT Id, Family, Name, Quantity_Ordered__c, Quantity_Remaining__c FROM Product2 LIMIT 1];

            o.status = constants.ACTIVATED_ORDER_STATUS;
            Update o;
            Product2 updatedp = [SELECT Id, Family, Name, Quantity_Ordered__c, Quantity_Remaining__c FROM Product2 LIMIT 1];


            TestDataFactory.VerifyQuantityOrdered(p, updatedp, constants.DEFAULT_ROWS);
        Test.stopTest();
    }

    @isTest 
    public static void OrderExtension_UnitTest() {
        PageReference pr = Page.OrderEdit;
        Test.setCurrentPage(pr);
        Order ordr = [Select Id, Status From Order LIMIT 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(ordr);
        OrderExtension oExt = new OrderExtension(sc);
        System.assertEquals(1, oExt.orderItemList.size());
        oExt.OnFieldChange();
        oExt.SelectFamily();
        oExt.Save();
        oExt.First();
        oExt.Next();
        oExt.Previous();
        oExt.Last();
        oExt.GetHasPrevious();
        oExt.GetHasNext();
        oExt.GetTotalPages();
        oExt.GetPageNumber();
        List<SelectOption> options = oExt.GetFamilyOptions();
        System.assertEquals(5, options.size());
    }
}