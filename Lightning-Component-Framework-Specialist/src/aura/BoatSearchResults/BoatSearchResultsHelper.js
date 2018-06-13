({
	onSearch : function(component, event) {
		var boatId = event.getParam('arguments');
		var action = component.get('c.getBoats');
		if(boatId) {
			action.setParam({
				"boatTypeId" : boatId.boatTypeId
			});
		}
		action.setCallback(this, function(returnValue){
			if(returnValue.getReturnValue() === null) {
				component.set("v.isError", true);
			}
			else {
				component.set("v.boats", returnValue.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	}
})