const functions = require("firebase-functions");
const { initializeApp } = require('firebase-admin/app');

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

const app = initializeApp();


exports.aa = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("google");
});
