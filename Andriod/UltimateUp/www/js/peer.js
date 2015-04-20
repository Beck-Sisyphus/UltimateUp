function Peer(peer) {
	this.coords = peer.coords;
	this.type = peer.type;
	var self = this;

	var peerLatLng = new plugin.google.maps.LatLng(
	    peer.coords.lat,
	    peer.coords.lon
	    );

    map.addMarker({
        'icon': TODO,
        'position': peerLatLng,
        'markerClick': function() {
        	mapView.showInfo(self);
        }
    });
}