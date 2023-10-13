const functions = require("firebase-functions");

// Firebase Admin SDK
const admin = require("firebase-admin");

// auth
const { getAuth } = require("firebase-admin/auth");

// firebase function logging
require("firebase-functions/logger/compat");



exports.notification = functions.https.onRequest(async (req, res) => {
  // ...
  const usersCollection = admin.firestore().collection('users');
  const usersCollectionSnapshot = await usersCollection.get();
  const today = new Date();
  const day = today.getDate();

  usersCollectionSnapshot.forEach(async userDoc => {
    const userData = userDoc.data();


    const cardRef = usersCollection.doc(userDoc.id).collection('myCards');
    const cardSnapshot = await cardRef.get();

    if ('token' in userData) {
      console.log('wewew ' + userData.token);
      cardSnapshot.forEach(async doc => {
        console.log('ttt ' );
        const billingCycleDay = parseInt(doc.data().billingCycleDay);
        console.log('billingCycleDay ' + billingCycleDay);

        const reminderDay = parseInt(doc.data().reminderDay);
        console.log('reminderDay ' + reminderDay);

        const dayUse = billingCycleDay - reminderDay;
        console.log('dayUse ' + billingCycleDay - reminderDay);
        console.log('day ' + day);

        if (dayUse == day+1) {
          // const payload = {
          //   notification: {
          //     title: 'Card Payment Reminder',
          //     body: 'Payment for card ending with' + doc.data().lastNumber,
          //   }
          // };
          console.log('innnnn ' );
          const message = 'Payment reminder for card ending with ' + doc.data().lastNumber;

          const payload = {
            token: userData.token,
              notification: {
                  title: 'Card Payment Reminder',
                  body: message
              },
              data: {
                  body: message,
              }
          };
           admin.messaging().send(payload).then((response) => {
            // Response is a message ID string.
            console.log('Successfully sent message:', response);
            return {success: true};
        }).catch((error) => {
            return {error: error.code};
        });

          // const response = await admin.messaging().sendToDevice(userData.token, payload);
          // await cleanupTokens(response, userData.token);
        }

        // // functions.logger.log('Notifications have been sent and tokens cleaned up.');




      });
    }



  });


});

// exports.tttt = functions.https.onRequest(async (req, res) => {


// const message = 'Payment reminder for card ending with';

// const payload = {
//   token: 'cTzdGsAlRYu5R1GgdcssTo:APA91bGQx8blSBr6UWe2WkUIeh_WfGUIWRXyBlAP9hRZcVuviWKImjDVQ_ag4Ess4QYctszi4O1E6l3LIL3q8Kk2UT6H2Q8c0TZ0vqQMwP8eMBf2AUujvU0V2QXRfKYsa8Suj5SFu5V1',
//     notification: {
//         title: 'cloud function demo',
//         body: message
//     },
//     data: {
//         body: message,
//     }
// };
// admin.messaging().send(payload).then((response) => {
//   // Response is a message ID string.
//   console.log('Successfully sent message:', response);
//   return {success: true};
// }).catch((error) => {
//   return {error: error.code};
// });


// });
