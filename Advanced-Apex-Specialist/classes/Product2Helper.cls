public class Product2Helper {
    /**
     * @name COLLABORATION_GROUP
     * @description List of CollaborationGroup used in both business and test logic
    **/
    static List<CollaborationGroup> COLLABORATION_GROUP = [
        SELECT Id
        FROM CollaborationGroup
        WHERE Name = :Constants.INVENTORY_ANNOUNCEMENTS
        OR Name = :('TEST'+Constants.INVENTORY_ANNOUNCEMENTS)
        LIMIT 1
    ];

    /**
     * @name afterUpdate
     * @description called by product2 Trigger on After Update
     * @param List<Product2> newList
     * @param List<Product2> oldList
    **/
    public static void AfterUpdate(List<Product2> newList, List<Product2> oldList){
        List<Product2> needsAnnouncement = new List<Product2>();
        Map<String, Decimal> mInventory = new Map<String, Decimal>();

        for(Inventory_Setting__mdt inSet : [Select DeveloperName, Low_Quantity_Alert__c From Inventory_Setting__mdt]) {
            mInventory.put(inSet.DeveloperName, inSet.Low_Quantity_Alert__c);
        }

        for(Product2 p : newList) {
            if(p.Quantity_Remaining__c < mInventory.get(p.Family)) {
                needsAnnouncement.add(p);
            }
        }

        PostAlerts(needsAnnouncement);
    }

    /**
     * @name postAlerts
     * @description called by product2 Trigger on After Update
     * @param List<Product2> productList
    **/
    public static void PostAlerts(List<Product2> productList){
        List<ConnectApi.AnnouncementInput> toPost = new List<ConnectApi.AnnouncementInput>();
        
        for ( Product2 p : productList ){
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            textSegmentInput.text = p.Name + ' ' + Constants.INVENTORY_LEVEL_LOW;
            messageBodyInput.messageSegments = new List<ConnectApi.messageSegmentInput>();
            messageBodyInput.messageSegments.add(textSegmentInput);

            ConnectApi.AnnouncementInput announcement = new ConnectApi.AnnouncementInput();
            announcement.expirationDate = Date.today().addDays(1);
            announcement.sendEmails = false;
            announcement.parentId = COLLABORATION_GROUP[0].Id;
            announcement.body = messageBodyInput;
            toPost.add(announcement);
        }

        AnnouncementQueueable q = new AnnouncementQueueable();
        q.toPost = toPost;

        System.enqueueJob(q);
    }
}