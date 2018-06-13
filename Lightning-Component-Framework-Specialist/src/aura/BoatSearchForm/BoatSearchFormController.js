({
	doInit : function(component, event, helper) {
		helper.getBoatTypes(component);
		helper.checkNewButtonEnabled(component);
	},
	createNewBoatRecord: function(component, event, helper) {
		var recordEvent = $A.get('event.force:createRecord');
		var typeId = component.find('boattype').get('v.value');

		recordEvent.setParams({
			'entityApiName': 'Boat__c',
			'defaultFieldValues': {
				'BoatType__c': typeId
			}
		});
		recordEvent.fire();
	},
	onFormSubmit: function(component, event, helper) {
		var boatId = component.find('boattype').get('v.value');
		var formsubmitEvt = component.getEvent('formData');
		formsubmitEvt.setParams({'formData': {'boatTypeId': boatId}});
		formsubmitEvt.fire();
	}
})