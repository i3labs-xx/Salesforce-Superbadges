({
	onInit : function(component, event) {
		var boat = cmp.get('v.boat');
		var action = component.get('c.getAll');
		action.setParams({  
			boatId : boat.Id
		});
		action.setCallback(this, function(response){
			if(response.getState() === 'SUCCESS' ) {
				component.set('v.boatReviews', response.getReturnValue());
			}
			else if(response.getState() === 'ERROR') {
				var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	}
})