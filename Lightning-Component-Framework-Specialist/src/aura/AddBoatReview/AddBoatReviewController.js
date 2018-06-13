({
	doInit : function(component, event, helper) {
		helper.onInit(component, event);
	},
	onSave: function(component, event, helper) {
		component.set("v.boatReview.Boat__c", component.get("v.boat.Id"));
		component.find("service").saveRecord(function(result){
			if(result.state === 'SUCCESS' || result.state === 'DRAFT') {
				var toast = $A.get('e.force:showToast');
				if(toast) {
					toast.setParams({
						"title": "Saved",
						"message": "Boat Review Created"
					});
					toast.fire();
				}
				else {
					alert('Boat Review Created');
				}
			} else if(result.state === 'ERROR') {
				var errMsg = '';
				for(var i=0;i<result.error.length;i++) {
					errMsg += saveResult.error[i].message + "\n";
				}
				component.set("v.recordError", errMsg);
			} else{
				console.log('Unknown problem, state: ' + saveResult.state + ', error: '
				+ JSON.stringify(saveResult.error));
			}
			component.getEvent("boatReviewAdded").fire();
		});
	},
	onRecordUpdated : function(component, event, helper) {
		
	}
})