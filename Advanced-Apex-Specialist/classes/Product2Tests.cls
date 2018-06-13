@isTest
private class Product2Tests {
    /**
     * @name product2Extension_UnitTest
     * @description UnitTest for product2Extension
    **/
    @isTest
    public static void Product2Extension_UnitTest(){
        Test.startTest();
            PageReference pr = Page.Product2New;
        Test.setCurrentPage(pr);
            Product2 p = new Product2(name='Test Product',isActive=true);
            ApexPages.StandardController stdcontroller = new ApexPages.StandardController(p);
            Product2Extension ext = new Product2Extension(stdcontroller);
            System.assertEquals(Constants.DEFAULT_ROWS, ext.productsToInsert.size());
            ext.addRows();
            System.assertEquals(Constants.DEFAULT_ROWS * 2, ext.productsToInsert.size());

            for(Integer i=0;i<10;i++) {
                Product2Extension.ProductWrapper pw = ext.productsToInsert[i];
                Product2 newProduct = new Product2();
                newProduct.Name = 'Test Product ' + i;
                newProduct.IsActive = true;
                newProduct.Initial_Inventory__c = 20;
                newProduct.Family = Constants.PRODUCT_FAMILY[0].getValue();
                pw.productRecord = newProduct;

                PricebookEntry pbe = new PricebookEntry();
                pbe.IsActive = true;
                pbe.UnitPrice = 10;
                pw.pricebookEntryRecord = pbe;
            }
            ext.save();
            ext.GetInventory();
            ext.GetFamilyOptions();

            Integer productCount = [Select Count() From Product2];
            System.assertEquals(10, productCount);
        Test.stopTest();
    }

    @isTest
    public static void Product2Trigger_UnitTest(){
        Test.startTest();
            Product2 p = new Product2();
            p.Name = 'Test Product';
            p.Family = 'Side';
            p.IsActive = true;
            p.Quantity_Ordered__c = 50;
            p.Initial_Inventory__c = 100;
            insert p;

            CollaborationGroup c = new CollaborationGroup();
            c.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
            c.Description = 'Testing Collaboration Group';
            c.CollaborationType = 'Public';
            insert c;

            p.Quantity_Ordered__c = 96;
            update p;
        Test.stopTest();
    }
}
