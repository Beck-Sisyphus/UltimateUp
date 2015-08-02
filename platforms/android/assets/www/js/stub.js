if (!U.isMatrix) {
	console.info("using stub");
	window.facebookConnectPlugin = {
		login: function(permissions, success, fail) {
		success({
		    status: "connected",
		    authResponse: {
		        session_key: true,
		        accessToken: "<long string>",
		        expiresIn: 5183979,
		        sig: "...",
		        secret: "...",
		        userID: "634565435"
		    }});
		},
		showDialog: function(options, success, fail) {
			success();
		}
	};


	window.plugin = {};
	plugin.google = {};
	plugin.google.maps = {};
	plugin.google.maps.LatLng = function(lat, lng) {
		return {
			lat: lat,
			lng: lng
		}
	}

	var Map = {
		setClickable: function(state) {
			console.info("google map clickable");
		},
		getMap: function(canvas) {
			return Map;
		},
		animateCamera: function(ani) {
			console.info("camera moved");
		}
	};
	plugin.google.maps.Map = Map;
}
