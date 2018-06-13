({
	onRecordUpdated : function(component, event, helper) {
        component.find("brcmpId").refresh();
	},
	
	onBoatSelected : function(component, event, helper) {
        var boatSelected = event.getParam("boat");
        component.set("v.id",boatSelected.Id);
        var service = component.find("service");
        service.reloadRecord() ;
    },

    onBoatReviewAdded : function(component, event, helper) {
        component.find("details").set("v.selectedTabId", "boatreviewtab");
        component.find("brcmpId").refresh();
    }
})