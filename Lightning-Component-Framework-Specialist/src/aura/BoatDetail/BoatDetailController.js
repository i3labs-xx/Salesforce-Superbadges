({
	onBoatSelected : function(component, event, helper) {
		var boatSelected = event.getParam("boat");
		component.set('v.boat', boatSelected);
	},
	onFullDetails : function(component, event, helper) {
		var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({"recordId": component.get("v.boat.Id")});
        navEvt.fire();
	}
})