const functions = require("firebase-functions");

// Firebase Admin SDK
const admin = require("firebase-admin");

// auth
const { getAuth } = require("firebase-admin/auth");

// firebase function logging
require("firebase-functions/logger/compat");

//function to add all cashback condition when new card is added
exports.addCashback = functions.firestore.document('users/{userId}/myCards/{cardsId}').onCreate(async (snap, context) => {
  const newValue = snap.data();
  const newDocumentRef = snap.ref;
  const newCollectionRef = newDocumentRef.collection('cashbacks');
  //get uid of newly added card
  const uid = newValue.uid;

  const originalRef = admin.firestore().collection('cards/' + uid + '/cashbacks');

  const fromOrigin = await originalRef.get();
  fromOrigin.forEach(doc => {
    //add to user's collection
    newCollectionRef.doc(doc.id).set(doc.data());
  });
});

//function to delete all cashback condition when card is removed
exports.deleteMyCardCashbackCollection = functions.firestore.document('users/{userId}/myCards/{cardsId}').onDelete((snap, context) => {
  const deleteDocumentRef = snap.ref;
  admin.firestore().recursiveDelete(deleteDocumentRef).then(() => {
    console.log('Successfully deleted card');
  }
  ).catch((error) => {
    console.log('Error deleting card:', error);
    return error;
  });;

});

//todo 





//todo updatecard
//todo deleteAtMyCashback --> u(mycards) -> u(myCashbacks)   <-- not sure if needed 