// The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require("firebase-admin");
admin.initializeApp();
//auth
const { getAuth } = require("firebase-admin/auth");

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

//var users = [];

const listAllUsers = (nextPageToken, accumulatorUsers = []) => {
  // List batch of users, 1000 at a time.
  return getAuth()
    .listUsers(5, nextPageToken)
    .then((listUsersResult) => {
      const users = [...accumulatorUsers, ...listUsersResult.users];

      // listUsersResult.users.forEach((userRecord) => {
      //   //console.log('user', userRecord.toJSON());
      //   users = [...accumulatorUsers, ...userRecord.users]

      // });
      if (listUsersResult.pageToken) {
        // List next batch of users.
        // console.log('__________ next batch ________');
       // console.log('user ---', users.length);

        return listAllUsers(listUsersResult.pageToken, users)

        //listAllUsers(listUsersResult.pageToken);

      } else {
       // console.log('user -=-', users.length);

        return users;
      }

    })
    .catch((error) => {
      console.log('Error listing users:', error);
    });



};
// Start listing users from the beginning, 1000 at a time.
//listAllUsers();




exports.user = functions.https.onCall(async (data, context) => {
  // var aa = listAllUsers();
  // console.log('user +++', aa);


  return listAllUsers().then((users) => {
    //return users;
    return users;
    console.log('in ', users);

  });



  // console.log('user +++', users.length);

  // users.forEach((user) => {

  //   console.log('user +____++');

  // })
  //console.log('error', listAllUsers.length);
  // try {
  //   return listAllUsers().then((users) => {
  //     return users;
  //   });
  // } catch (error) {
  //   console.log('error', error);
  // }

  // console.log('user', aa.length);
  // aa.forEach((user) => {
  //           console.log('user', user);

  // }
  // )

});
function testL(page) {
  let pageTokens = [];

  let nextPageToken = pageTokens[page];

  // getAuth()
  //   .listUsers(1, nextPageToken)
  //   .then((listUsersResult) => {

  //     listUsersResult.users.forEach((userRecord) => {
  //       console.log('_________');

  //       console.log('user', userRecord.toJSON());
  //       console.log('_________');

  //     });
  //     pageTokens[page] = listUsersResult.pageTokens;
  //     console.log('_________');
  //     console.log('_________ ', pageTokens.length);

  //     pageTokens.forEach((element) => {
  //       console.log('_________ ', element);
  //     });



  // pageTokens.forEach(element => {

  //   console.log('_________ ', element.);

  // });



  // });

  //return pageTokens;

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