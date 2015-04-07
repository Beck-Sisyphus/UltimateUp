var U = {}; // global

U.isMatrix = document.URL.indexOf( 'http://' ) === -1 && document.URL.indexOf( 'https://' ) === -1;

if (U.isMatrix) {
    // Cordova application
    document.addEventListener("deviceready", onDeviceReady, false);
} else { // Web
    document.addEventListener("DOMContentLoaded", onDeviceReady, false);
}


function toJSON(error, text) {
    if (error) {
        return {"error": error};
    }
    else {
        return JSON.parse(text);
    }
}

function onDeviceReady() {
    console.info('here');
    // initialize map view

    U.peerView.$mount(document.getElementById('peer-view'));

    U.createGameView.$mount(document.getElementById('create-game-view'));

    U.facebookView.$mount(document.getElementById('facebook-view'));

    U.reviewView.$mount(document.getElementById("review-view"));

    U.navView.$mount(document.getElementById("nav-view"));


    U.mapView.$mount(document.getElementById("map-view"));

    // promise.get("http://54.86.169.6/ios/comm_test.php",
    //     {"name": "34234"}).then(function(error, text) {
    //         d2.innerHTML = text;
    // });
}