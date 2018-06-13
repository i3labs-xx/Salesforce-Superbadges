({
	doInit : function(component, event, helper) {
		helper.onInit(component, event);
	},
	onUserInfoClick : function(component, event, helper) {
		var userid = event.currentTarget.getAttribute("data-userid");
		var navEvt = $A.get("e.force:navigateToSObject");
		navEvt.setParams({
			"recordId" : userId
		});
		navEvt.fire();
	}
})