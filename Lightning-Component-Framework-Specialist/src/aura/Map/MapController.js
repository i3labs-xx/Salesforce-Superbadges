({
    jsLoaded: function(component) {
        component.set("v.jsLoaded", true);
    },
    onPlotMapMarker: function(component) {
        var id = event.getParam('sObjectId');
        var latitude = event.getParam('lat');
        var longitude = event.getParam('long');
        var label = event.getParam('label');
        component.set('v.location', {
            'lat' : latitude,
            'long': longitude
        });
    }
})