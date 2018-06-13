({
	getBoatTypes : function(component) {
		var action = component.get('c.getBoatTypes');
		action.setCallback(this, function(returnValue){
			component.set('v.boatTypesOptions', returnValue.getReturnValue());
		});
		$A.enqueueAction(action);
	},
	checkNewButtonEnabled: function(component) {
		var isEnabled = $A.get("event.force:createRecord");
		if(isEnabled) {
			component.set('v.showNewButton', isEnabled);
		}
	}
})