/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup(){
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
        CollaborationGroup cg = new CollaborationGroup();
        cg.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
        cg.CanHaveGuests = false;
        cg.CollaborationType = 'Public';
        cg.IsArchived = false;
        cg.IsAutoArchiveDisabled = false;
        return cg;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> ConstructProducts(Integer cnt){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
        List<Schema.PickListEntry> familyValues = Product2.Family.getDescribe().getPickListValues();
        List<Product2> products = new List<Product2>();
        for(Integer i=0;i<cnt;i++) {
            products.add(new Product2(
                Name = 'Product ' + i,
                Family = familyValues[Math.mod(i, familyValues.size())].getValue(),
                Initial_Inventory__c = 10,
                IsActive = true
            ));
        }
        return products;
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PriceBookEntry> ConstructPricebookEntries(List<Product2> prods){
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
        List<PriceBookEntry> pricebookEntries = new List<PriceBookEntry>();

        for(Product2 p : prods) {
            pricebookEntries.add(new PriceBookEntry(
                IsActive = true,
                Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID,
                Product2Id = p.Id,
                UnitPrice = 1
            ));
        }
        return pricebookEntries;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.

        List<Account> newAccounts = new List<Account>();
        for(Integer i=0;i<cnt;i++) {
            newAccounts.add(new Account(Name = 'Account ' + i));
        }
        return newAccounts;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.

        List<Contact> newContacts = new List<Contact>();
        for (Integer i = 0; i < cnt; i++) {
            newContacts.add(new Contact(
                LastName = 'Contact ' + i,
                AccountId = accts[Math.mod(i, accts.size())].Id
            ));
        }
        return newContacts;
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Order> newOrders = new List<Order>();
        for (Integer i = 0; i < cnt; i++) {
            newOrders.add(new Order(
                Name = 'Order ' + i,
                AccountId = accts[Math.mod(i, accts.size())].Id,
                EffectiveDate = Date.today(),
                Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID,
                Status = 'Draft'
            ));
        }
        return newOrders;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge

        Integer pbeListSize = pbes.size();
        Integer orderListSize = ords.size();

        List<OrderItem> newOrderItems = new List<OrderItem>();

        for (Integer i = 0; i < cnt; i++) {
            newOrderItems.add(new OrderItem(
                OrderId = ords[Math.mod(i, orderListSize)].Id,
                PriceBookEntryId = pbes[Math.mod(i, pbeListSize)].Id,
                Quantity = Constants.DEFAULT_ROWS,
                UnitPrice = 1
            ));
        }
        return newOrderItems;
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.
        insert ConstructCollaborationGroup();
        List<Product2> products = ConstructProducts(cnt);
        insert products;
        List<PriceBookEntry> pbes = ConstructPricebookEntries(products);
        insert pbes;
        List<Account> accounts = ConstructAccounts(cnt);
        insert accounts;
        List<Contact> contacts = ConstructContacts(cnt, accounts);
        insert contacts;
        List<Order> orders = ConstructOrders(cnt, accounts);
        insert orders;
        List<OrderItem> orderItems = ConstructOrderItems(cnt, pbes, orders);
        insert orderItems;
    }

    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered){
        Integer sumQuantity = Integer.valueOf(originalProduct.Quantity_Ordered__c) + qtyOrdered;
        System.assertEquals(updatedProduct.Quantity_Ordered__c, sumQuantity);
    }
}