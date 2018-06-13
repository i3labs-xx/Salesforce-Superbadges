({
	onBoatClick : function(component, event, helper) {
		var boat = component.get("v.boat");
		var boatSelectEvt = component.getEvent('BoatSelect');
		boatSelectEvt.setParams({'boatId': boat.id});
		var boatSelectedEvt = $A.get('e.c:BoatSelected');
		boatSelectedEvt.setParams({'boat': boat});
		boatSelectEvt.fire();
		boatSelectedEvt.fire();

		var lat = boat.Geolocation__Latitude__s;
		var long = boat.Geolocation__Longitude__s;
		var label = boat.Name;
		var sObjectId;
		var plotMapMarkerAppEvent = $A.get("e.c:PlotMapMarker");
		plotMapMarkerAppEvent.setParams({
			"lat" : lat,
			"long" : long,
			"label" : label,
			"SObjectId" : boatId
		});
		plotMapMarkerAppEvent.fire();
	}
})