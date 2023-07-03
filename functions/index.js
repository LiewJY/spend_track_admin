// const functions = require("firebase-functions");

// Firebase Admin SDK
const admin = require("firebase-admin");
admin.initializeApp();
// auth
// const { getAuth } = require("firebase-admin/auth");

// firebase function logging
require("firebase-functions/logger/compat");

// get functions from specific files
module.exports = {
  ...require("./lib/user-management.js"),
  ...require("./lib/card-management.js"),

  // ...require("./lib/bar.js") // add as many as you like
};


