 const functions = require("firebase-functions");

// Firebase Admin SDK
const admin = require("firebase-admin");
admin.initializeApp();
// auth
 const { getAuth } = require("firebase-admin/auth");

// firebase function logging
require("firebase-functions/logger/compat");

// get functions from specific files
module.exports = {
  //admin
  ...require("./lib/admin/card-management.js"),
  ...require("./lib/admin/cashback-management.js"),
  ...require("./lib/admin/category-management.js"),
  ...require("./lib/admin/user-management.js"),
  ...require("./lib/admin/wallet-management.js"),

  //user
  ...require("./lib/user/budget-management.js"),
  ...require("./lib/user/card-management.js"),
  ...require("./lib/user/transaction-management.js"),   
  ...require("./lib/user/wallet-management.js"),
  ...require("./lib/user/cashback-management.js"),

  ...require("./lib/notification/notification-management.js"),

  // ...require("./lib/user/update-transaction.js"),
  // ...require("./lib/user/delete-transaction.js"),

  // ...require("./lib/bar.js") // add as many as you like
};

