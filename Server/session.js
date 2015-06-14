// Stub, very much a Stub

var verified = new Set();

var isAuthenticated = function(soc) {
  return verified.has(soc.id);
};

var setAuthenticated = function(soc) {
  verified.add(soc.id);
};

exports.isAuthenticated = isAuthenticated;
exports.setAuthenticated = setAuthenticated;
