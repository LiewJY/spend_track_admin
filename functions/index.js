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


const listAllUsers = (nextPageToken, accumulatorUsers = []) => {
  return getAuth()
    .listUsers(1000, nextPageToken)
    .then((listUsersResult) => {
      const users = [...accumulatorUsers, ...listUsersResult.users];
      if (listUsersResult.pageToken) {
        return listAllUsers(listUsersResult.pageToken, users)
      } else {
        return users;
      }
    })
    .catch((error) => {
      console.log('Error listing users:', error);
    });
};


const listAdminUsers = (list) => {
  console.log('in ', list);

  return getAuth()
    .getUsers(list)
    .then((getUsersResult) => {
      return getUsersResult.users;
    })
    .catch((error) => {
      console.log('Error fetching user data:', error);
    });
}

exports.adminUsers = functions.https.onCall(async (data, context) => {
  console.log('ss ', data.filter);

  return listAdminUsers(data.filter).then((users) => {
    return users;
  });
});



exports.user = functions.https.onCall(async (data, context) => {
  //fixme testing filter
  var adminUsers = [];
  listAllUsers().then((users) => {
    //return users;
    console.log('in ', users);
    return users;

  });

  //fixme working
  return listAllUsers().then((users) => {
    return users;
  });

});
