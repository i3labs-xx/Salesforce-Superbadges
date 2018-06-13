({
	onFormSubmit: function(component, event, helper) {
		var formData = event.getParam("formData");
		var boatTypeId = formData.boatTypeId;
		var cmpId = component.find("BtSrhRsltcmp");
		var methodResult = cmpId.search(boatTypeId);
	}
})