// The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require("firebase-admin");
admin.initializeApp();

//logging
require("firebase-functions/logger/compat");

// Take the text parameter passed to this HTTP endpoint and insert it into
// Firestore under the path /messages/:documentId/original
exports.addMessage = functions.https.onCall(async (data, context) => {
  // Grab the text parameter.
  const original = data.text;
  // console.log('log ', original);
  // Push the new message into Firestore using the Firebase Admin SDK.
  const writeResult = await admin
    .firestore()
    .collection("messages")
    .add({ original: original });
    return {
      result: writeResult.id,

    }
});



let pageTokens = [];

function testL(page) {

  let nextPageToken = pageTokens[page];

  getAuth()
    .listUsers(1, nextPageToken)
    .then((listUsersResult) => {

      listUsersResult.users.forEach((userRecord) => {
        console.log('user', userRecord.toJSON());
      });
      pageTokens[page + 1] = listUsersResult.pageTokens;

    });

return pageTokens;

    // pageTokens.forEach(element => {
    //   console.log('token' + element);
      
    // });

}

// Listens for new messages added to /messages/:documentId/original and creates an
// uppercase version of the message to /messages/:documentId/uppercase
// exports.makeUppercase = functions.firestore
//   .document("/messages/{documentId}")
//   .onCreate((snap, context) => {
//     // Grab the current value of what was written to Firestore.
//     const original = snap.data().original;

//     // Access the parameter `{documentId}` with `context.params`
//     functions.logger.log("Uppercasing", context.params.documentId, original);

//     const uppercase = original.toUpperCase();

//     // You must return a Promise when performing asynchronous tasks inside a Functions such as
//     // writing to Firestore.
//     // Setting an 'uppercase' field in Firestore document returns a Promise.
//     return snap.ref.set({ uppercase }, { merge: true });
//   });