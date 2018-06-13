public class Product2Extension {

    public List<ProductWrapper> productsToInsert {get;set;}

    public Product2Extension(ApexPages.StandardController controller) {
        productsToInsert = new List<ProductWrapper>();
        addRows();
    }

    public void AddRows(){
        for ( Integer i=0; i<Constants.DEFAULT_ROWS; i++ ){
            productsToInsert.add( new ProductWrapper() );
        }
    }

    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }

    public PageReference Save(){
        Savepoint sp = Database.setSavepoint();
        try {
            List<Product2> products = new List<Product2>();
            List<PriceBookEntry> pricebookEntries = new List<PriceBookEntry>();

            for(ProductWrapper pw : productsToInsert) {
                if(pw.productRecord != null && pw.pricebookEntryRecord != null) {
                    if(pw.productRecord.Name !=null && pw.productRecord.Family !=null && Constants.SELECT_ONE !=pw.productRecord.Family && 
                        pw.productRecord.Initial_Inventory__c !=null && pw.pricebookEntryRecord.UnitPrice !=null) {
                            products.add(pw.productRecord);
                            PriceBookEntry pbe = pw.pricebookEntryRecord;
                            pbe.IsActive = pw.productRecord.IsActive;
                            pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
                            pricebookEntries.add(pbe);
                    }
                }
            }

            if(!products.isEmpty()) {
                insert products;

                for(Integer i=0;i<pricebookEntries.size();i++) {
                    pricebookEntries[i].Product2Id = products[i].Id;
                }
                insert pricebookEntries;
            }

            //If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,productsToInsert.size()+' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e){
            Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
        }
        return null;
    }

    public List<SelectOption> GetFamilyOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for(Schema.PicklistEntry entry : Constants.PRODUCT_FAMILY) {
            options.add(new SelectOption(entry.getValue(), entry.getValue()));
        }
        return options;
    }

    public class ProductWrapper {
        public Product2 productRecord {get;set;}
        public PriceBookEntry pricebookEntryRecord {get;set;}

        public ProductWrapper(){
            productRecord = new product2(Initial_Inventory__c =0);
            pricebookEntryRecord = new pricebookEntry(Unitprice=0.0);
        }
    }
}