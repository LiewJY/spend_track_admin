const functions = require("firebase-functions");

// Firebase Admin SDK
const admin = require("firebase-admin");

// auth
const { getAuth } = require("firebase-admin/auth");

// firebase function logging
require("firebase-functions/logger/compat");

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

// list only admin users
exports.adminUsers = functions.https.onCall(async (data, context) => {
  return listAdminUsers(data.filter).then((users) => {
    return users;
  });
});

const listUsers = (list) => {
  return getAuth()
    .listUsers()
    .then((getUsersResult) => {
      const users = getUsersResult.users;
      const usersNotInList = users.filter(user => !list.includes(user.uid));
      return usersNotInList;
    })
    .catch((error) => {
      console.log('Error fetching user data:', error);
    });
}

// list users only
exports.users = functions.https.onCall(async (data, context) => {
  return listUsers(data.filter.map(obj => obj.uid)).then((users) => {
    return users;
  });
});

// add user (admin & user)
exports.addUser = functions.https.onCall(async (data, context) => {
  return getAuth()
    .createUser({
      email: data.email,
      password: data.password,
      displayName: data.name,
      disabled: false,
    })
    .then((userRecord) => {
      //when isAdmin is true
      if (data.isAdmin) {
        admin.firestore().collection('admins').doc(userRecord.uid).set({ 'admin': true });
      }
    })
    .catch((error) => {
      console.log('Error creating new user:', error);
      return error.code;
    });
});

// enable / disable user (admin & user)
exports.toggleEnableUser = functions.https.onCall(async (data, context) => {
  return getAuth()
    .updateUser(data.uid, {
      disabled: !data.isEnabled,
    })
    .catch((error) => {
      console.log('Error updating user:', error);
      return error;
    });

});

// delete admin user
exports.deleteAdminUser = functions.https.onCall(async (data, context) => {
  return getAuth()
    .deleteUser(data.uid)
    .then(() => {
      console.log('Successfully deleted user');
      if (data.isAdmin) {
        admin.firestore().collection('admins').doc(data.uid).delete();
      }
    })
    .catch((error) => {
      console.log('Error deleting user:', error);
      return error;
    });

});

//trigger to create new users collection at signup
exports.makeCollection = functions.auth.user().onCreate((user) => {
  admin.firestore().collection('users').doc(user.uid).set({ 'user': true });
});


// exports.resetPassword = functions.https.onCall(async (data, context) => {
//   getAuth()
//   .generatePasswordResetLink(data.userEmail, actionCodeSettings)
//   .then((link) => {
//     // Construct password reset email template, embed the link and send
//     // using custom SMTP server.
//     return sendCustomPasswordResetEmail(data.userEmail, displayName, link);
//   })
//   .catch((error) => {
//     // Some error occurred.
//   });

// });
