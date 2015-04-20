(function() {

var reviewView = new Vue({
	data: {
		isShow: false,
		peers: []
	},
	methods: {
		expand: function() {
			this.peers.push({
				name: "ftwtw",
				avatar: "",
				skill: 3,
				hasFrisbe: true,
				isMVP: false
			});
			this.showView();
		},
		showView: function() {
			this.jQObj.openModal();
			U.mapView.setClickable(false);
		},
		hideView: function() {
			this.jQObj.closeModal();
			U.mapView.setClickable(false);

		},
		showPeer: function(peer) {

		},
		toggleMVP: function(peer) {
			peer.isMVP = !peer.isMVP;
		}
	},
	ready: function() {
		this.jQObj = $(this.$el);
	},
});

U.reviewView = reviewView;

})();