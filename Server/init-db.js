var r = require('rethinkdbdash')();

console.info("Creating database...");

r.dbCreate("ut").run()
 .then(function(s) {
  if (!s.created) {
    console.info("Error:", s);
    throw s;
  }
  var test = r.db("ut");

  console.info("Creating tables...");

  return test.tableCreate("users")
     .tableCreate("fb-tokens")
     .tableCreate("geo")
     .tableCreate("friends")
     .tableCreate("games", {primaryKey: "game-id"});
 }).run()
 .then(function(s) {
  if (!s.tables_created) {
    conosle.info("Error:",s);
    throw s;
  }

  console.info("Creating indices for table users...");

  return r.table("users").indexCreate("facebook_id").indexCreate("city").indexCreate("school");
 }).run()
 .then(function(s) {
  if (!s.tables_created) {
    conosle.info("Error:",s);
    throw s;
  }

  console.info("Creating indices for table geo...");

  return r.table("geo").indexCreate("loc", {geo:true});
 }).run()
 .then(function(s) {
  if (!s.tables_created) {
    conosle.info("Error:",s);
    throw s;
  }

  console.info("Creating indices for table games...");

  return r.table("games").indexCreate("loc", {geo:true});
 }).run()
 .then(function(s) {
  if (!s.tables_created) {
    conosle.info("Error:",s);
    throw s;
  }

  console.info("Done.");
});
