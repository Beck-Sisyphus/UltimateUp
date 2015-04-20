(function() {

var createGameView = new Vue({
	data: {
		isShow: false
	},
	methods: {
		setupGame: function(peer) {
			// todo: send request
			this.showView();
			U.mapView.$data.gameStarted = true;
		},
		showView: function() {
			this.jQObj.openModal();
			U.mapView.setClickable(false);
		},
		hideView: function() {
			this.jQObj.closeModal();
			U.mapView.setClickable(false);

		},
		inviteFriends: function() {
			U.facebookView.shareLink();
		},
		setupDone: function() {
			this.hideView();
		}
	},
	ready: function() {
		this.jQObj = $(this.$el);
		// this.jQObj.leanModal({
		// 	dismissible: false
		// });
	}
});

U.createGameView = createGameView;

})();