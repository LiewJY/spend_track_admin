const functions = require("firebase-functions");

// Firebase Admin SDK
const admin = require("firebase-admin");

// auth
const { getAuth } = require("firebase-admin/auth");

// firebase function logging
require("firebase-functions/logger/compat");


// exports.deleteCashback = functions.https.onCall(async (data, context) => {

//   return admin.firestore().recursiveDelete(admin.firestore().collection('cards').doc(data.uid)).then(() => {
//     console.log('Successfully deleted card');
//   }
//   ).catch((error) => {
//     console.log('Error deleting card:', error);
//     return error;
//   });;

// });

