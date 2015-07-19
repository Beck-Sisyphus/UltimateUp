// session store - determines if a socket is authenticated

// We are not currently using any session database for this
// Everything here is Stub, very much a Stub

// In the future, we might add another db like Redis
// for handling session storage

var verified = new Set();

var isAuthenticated = function(soc) {
  return verified.has(soc.id);
};

var setAuthenticated = function(soc) {
  verified.add(soc.id);
};

exports.isAuthenticated = isAuthenticated;
exports.setAuthenticated = setAuthenticated;
