var r = require('rethinkdbdash')();

console.info("Creating database...");

r.dbCreate("ut").run()
 .then(function(s) {
  if (!s.dbs_created) {
    console.info("Error:", s);
    throw s;
  }
  var db = r.db("ut");

  console.info("Creating tables...");

  return Promise.all([
    db.tableCreate("users").run(),
    db.tableCreate("fb_tokens").run(),
    db.tableCreate("geo").run(),
    db.tableCreate("friends").run(),
    db.tableCreate("games", {primaryKey: "game-id"}).run()
  ]);
 }).then(function(res) {
  if (res.some(function(s) {return !s.tables_created;})) {
    console.info("Error:",res);
    throw s;
  }

  console.info("Creating indices...");
  
  var db = r.db("ut");
  return Promise.all([
    db.table("users").indexCreate("facebook_id").run(),
    db.table("users").indexCreate("city").run(),
    db.table("users").indexCreate("school").run(),
    db.table("geo").indexCreate("loc", {geo:true}).run(),
    db.table("games").indexCreate("loc", {geo:true}).run()
  ]);
 }).then(function(res) {
  if (res.some(function(s) {return !s.created;})) {
    console.info("Error:",s);
    throw s;
  }

  console.info("Done.");
  // exit
  r.getPoolMaster().drain();
});
