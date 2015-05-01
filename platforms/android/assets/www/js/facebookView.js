(function() {

	var facebookView = new Vue({
		data: {
			isShow: false
		},
		methods: {
			authenticate: function(cb) {
				this.showView();
				var self = this;
				facebookConnectPlugin.login([], function(res) {
					self.hideView();
		    	// do something with authResponse
		    	// send U.mapView.getCurrentPos();
		    	U.createGameView.setupGame();
		    },function() {
		    	alert('fail');
		    	self.hideView();
		    });
			},
			shareLink: function() {
				this.showView();
				var self = this;
				facebookConnectPlugin.showDialog( 
				{
					method: 'share',
					href: 'https://developers.facebook.com/docs/',
				},
				function() {
					self.hideView();
				},
				function() {
					alert("fail whale");
					self.hideView();
				}
				);
			},
			inviteToApp: function() {
				this.showView();
				var self = this;
				facebookConnectPlugin.showDialog( 
				{
					method: 'apprequests',
					message: "Check out our app!"
				},
				function(res) {
					alert(JSON.stringify(res));
					self.hideView();
				},
				function(res) {
										alert(JSON.stringify(res));

					alert("fail whale");
					self.hideView();
				}
				);
			},
			showView: function() {
				this.isShow = true;
			},
			hideView: function() {
				this.isShow = false;
			}
		},
		ready: function() {
			console.info('facebook view ready');
		}
	});

U.facebookView = facebookView;

})();