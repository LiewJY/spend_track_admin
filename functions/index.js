const functions = require("firebase-functions");

//Firebase Admin SDK
const admin = require("firebase-admin");
admin.initializeApp();
//auth
const { getAuth } = require("firebase-admin/auth");

//firebase function logging
require("firebase-functions/logger/compat");

//todo remove
// // Take the text parameter passed to this HTTP endpoint and insert it into
// // Firestore under the path /messages/:documentId/original
// exports.addMessage = functions.https.onCall(async (data, context) => {
//   // Grab the text parameter.
//   const original = data.text;
//   // console.log('log ', original);
//   // Push the new message into Firestore using the Firebase Admin SDK.
//   const writeResult = await admin
//     .firestore()
//     .collection("messages")
//     .add({ original: original });
//   return {
//     result: writeResult.id,

//   }
// });

//list all admin users
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
  return listAdminUsers(data.filter).then((users) => {
    return users;
  });
});

//add admin user
exports.addAdminUser = functions.https.onCall(async (data, context) => {
  //todo
  getAuth()
  .createUser({
    email: 'user@example.com',
    password: 'secretPassword',
    displayName: 'John Doe',
    disabled: false,
  })
  .then((userRecord) => {
    // See the UserRecord reference doc for the contents of userRecord.
    //todo include add to firestore
    console.log('Successfully created new user:', userRecord.uid);
  })
  .catch((error) => {
    console.log('Error creating new user:', error);
  });
});


//todo edit admin user
exports.editAdminUser = functions.https.onCall(async (data, context) => {
  //todo

});


//todo delete admin user
exports.deleteAdminUser = functions.https.onCall(async (data, context) => {
  //todo

});

//todo enable admin user
exports.enableAdminUser = functions.https.onCall(async (data, context) => {
  //todo

});

//todo disable admin user
exports.disableAdminUser = functions.https.onCall(async (data, context) => {
  //todo

});


// exports.user = functions.https.onCall(async (data, context) => {
//   //fixme testing filter
//   var adminUsers = [];
//   listAllUsers().then((users) => {
//     //return users;
//     console.log('in ', users);
//     return users;

//   });

//   //fixme working
//   return listAllUsers().then((users) => {
//     return users;
//   });

// });
