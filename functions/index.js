const functions = require("firebase-functions");

//Firebase Admin SDK
const admin = require("firebase-admin");
admin.initializeApp();
//auth
const { getAuth } = require("firebase-admin/auth");

//firebase function logging
require("firebase-functions/logger/compat");

//get functions from specific files
module.exports = {
  ...require("./lib/user-management.js"),
  // ...require("./lib/bar.js") // add as many as you like
};



// //list all admin users
// const listAllUsers = (nextPageToken, accumulatorUsers = []) => {
//   return getAuth()
//     .listUsers(1000, nextPageToken)
//     .then((listUsersResult) => {
//       const users = [...accumulatorUsers, ...listUsersResult.users];
//       if (listUsersResult.pageToken) {
//         return listAllUsers(listUsersResult.pageToken, users)
//       } else {
//         return users;
//       }
//     })
//     .catch((error) => {
//       console.log('Error listing users:', error);
//     });
// };

// const listAdminUsers = (list) => {
//   return getAuth()
//     .getUsers(list)
//     .then((getUsersResult) => {
//       return getUsersResult.users;
//     })
//     .catch((error) => {
//       console.log('Error fetching user data:', error);
//     });
// }

// exports.adminUsers = functions.https.onCall(async (data, context) => {
//   return listAdminUsers(data.filter).then((users) => {
//     return users;
//   });
// });

// //add admin user
// exports.addUser = functions.https.onCall(async (data, context) => {
//   return getAuth()
//     .createUser({
//       email: data.email,
//       password: data.password,
//       displayName: data.name,
//       disabled: false,
//     })
//     .then((userRecord) => {
//       if (data.isAdmin) {
//         admin.firestore().collection('admins').doc(userRecord.uid).set({ 'admin': true });
//       }
//     })
//     .catch((error) => {
//       console.log('Error creating new user:', error);
//       return error.code;
//     });
// });

// //enable / disable user (admin & user)
// exports.toggleEnableUser = functions.https.onCall(async (data, context) => {
//   return getAuth()
//     .updateUser(data.uid, {
//       disabled: !data.isEnabled,
//     })
//     .catch((error) => {
//       console.log('Error updating user:', error);
//       return error;
//     });

// });


// //todo reset user password (admin & user)
// //fixme at production
// exports.resetUserPassword = functions.https.onCall(async (data, context) => {
//   //todo
//   //fixme at production

//   const userEmail = 'liewjunyoung01@gmail.com';
//   getAuth()
//     .generatePasswordResetLink(userEmail, actionCodeSettings)
//     .then((link) => {
//       // Construct password reset email template, embed the link and send
//       // using custom SMTP server.
//       return sendCustomPasswordResetEmail(userEmail, displayName, link);
//     })
//     .catch((error) => {
//       // Some error occurred.
//     });
// });


// //delete admin user
// exports.deleteAdminUser = functions.https.onCall(async (data, context) => {
//   return getAuth()
//   .deleteUser(data.uid)
//   .then(() => {
//     console.log('Successfully deleted user');
//     admin.firestore().collection('admins').doc(data.uid).delete();
//   })
//   .catch((error) => {
//     console.log('Error deleting user:', error);
//     return error;
//   });

// });



// // exports.user = functions.https.onCall(async (data, context) => {
// //   //fixme testing filter
// //   var adminUsers = [];
// //   listAllUsers().then((users) => {
// //     //return users;
// //     console.log('in ', users);
// //     return users;

// //   });

// //   //fixme working
// //   return listAllUsers().then((users) => {
// //     return users;
// //   });

// // });
