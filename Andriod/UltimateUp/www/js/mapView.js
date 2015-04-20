(function() {

var mapView = new Vue({
	data: {
		map: null,
		currentPos: null,
		peers: [],
		watchId: null,
		gameStarted: false
	},
	methods: {
		addPeer: function(peer) {
			this.peers.push(new Peer(peer));
		},
		showInfo: function(peer) {
			this.map.setClickable(false);
			U.peerView.showInfo(peer);
		},
		setClickable: function(state) {
			this.map.setClickable(state);
		},
		geoUpdate: function(pos) {
			this.currentPos = pos;
			console.info(pos);
	    	// TODO: send pos to server;
	    	// promise.post("http://54.86.169.6/ios/find_nearby.php",
	     //   		{pos: pos}).then(toJSON).then(function(data) {
		    //         var peers = data.peers || [];
		    //         for (var i = 0; i < peers.length; i++) {
		    //         	this.addPeer(peers[i]);
		    //         }
		    //     });

	        var latLng = new plugin.google.maps.LatLng(
	            pos.coords.latitude,
	            pos.coords.longitude
	            );
	        this.map.animateCamera({
	          'target': latLng,
	          'zoom': 18,
	          'duration': 2000
	    	});
	    },
	    getCurrentPos: function() {
	    	return this.currentPos;
	    },
	    createGame: function() {
	    	U.facebookView.authenticate();
	    },
	    listPeer: function() {
	    	U.reviewView.expand();
	    },
	    showMenu: function() {
	    	U.navView.showView();
	    }
	},
	ready: function() {
		var self = this;
		// log geolocation
    	this.watchId = navigator.geolocation.watchPosition(function(pos) {self.geoUpdate(pos);});
		var map = this.map = plugin.google.maps.Map.getMap(this.$$.mapCanvas);
		map.setClickable(true);
	}
});

U.mapView = mapView;

})();