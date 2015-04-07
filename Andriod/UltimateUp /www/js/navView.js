(function() {

var navView = new Vue({
	data: {
		player: {
			skill: 3,
			name: "Player Person",
			avatar: ""
		}
	},
	methods: {
		displayInfo: function(peer) {
			// TODO I DON'T KNOW
		},
		showView: function() {
			U.mapView.setClickable(false);
			this.jQObj.sideNav("show");
		},
		hideView: function() {
			// FIXME: set clickable after return
			U.mapView.setClickable(true);
		}
	},
	ready: function() {
		this.jQObj = $("#side-menu-btn");
		this.jQObj.sideNav({
	        menuWidth: 400, // Default is 240
	        edge: 'left', // Choose the horizontal origin
	        closeOnClick: true, // Closes side-nav on <a> clicks, useful for Angular/Meteor
	    });
	}
});

U.navView = navView;

})();