const functions = require("firebase-functions");

// Firebase Admin SDK
const admin = require("firebase-admin");

// auth
const { getAuth } = require("firebase-admin/auth");

// firebase function logging
require("firebase-functions/logger/compat");
// const {aaa}  = require('./wallet-management');
// import { aaa } from './wallet-management.js';

//function to add all cashback condition when new card is added
exports.addCashback = functions.firestore.document('users/{userId}/myCards/{cardsId}').onCreate(async (snap, context) => {
  const newValue = snap.data();
  const newDocumentRef = snap.ref;
  const newCollectionRef = newDocumentRef.collection('cashbacks');
  //get uid of newly added card
  const uid = newValue.uid;

  const originalRef = admin.firestore().collection('cards/' + uid + '/cashbacks');
  const originalDoc = await originalRef.get();

  if (!originalDoc.empty) {
    //if cashback exists
    const fromOrigin = await originalRef.get();
    fromOrigin.forEach(doc => {
      //add to user's collection
      newCollectionRef.doc(doc.id).set(doc.data());
    });


    // here is to create a initial myCashback so user can see the cashbacks in homescreen
    const myCardsUid = context.params.cardsId;
    const userId = context.params.userId;

    addToMyCashback(myCardsUid, userId, newValue);

  }



});

//add cashback categories to myCashback
const addToMyCashback = async (myCardsUid, userId, newValue) => {
  //check if exist already (uid and valid date )
  const myCashbackRef = admin.firestore().collection('users').doc(userId).collection('myCashbacks');
  const day = newValue.billingCycleDay;
  const currentDate = new Date();
  const month = currentDate.getMonth() + 1;
  const year = currentDate.getFullYear();

  const date = new Date(`${year}-${month + 1}-${day}`);
  const newDocRef = myCashbackRef.doc();
  await newDocRef.set({
    'name': newValue.name,
    'bank': newValue.bank,
    'cardType': newValue.cardType,
    'lastNumber': newValue.lastNumber,
    'customName': newValue.customName,
    'totalSpending': 0,
    'validUntil': date,
    'myCardUid': myCardsUid,
  });

  // newDoc
  console.log('in there ', newDocRef.id);
  // the cashbacks will be added through cloud function triggers
  //see file cashback-management

  const myCardsCashbackRef = admin.firestore().collection('users').doc(userId).collection('myCards').doc(myCardsUid).collection('cashbacks');

  const myCardsCashbackSnapshot = await myCardsCashbackRef.get();
  //create batch write
  const batch = admin.firestore().batch();
  myCardsCashbackSnapshot.forEach(doc => {
    //add to user's collection
    const myCashbackCategoryRef = myCashbackRef.doc(newDocRef.id).collection('categories').doc(doc.id);
    batch.set(myCashbackCategoryRef, doc.data());
    batch.set(myCashbackCategoryRef, { 'totalSpend': 0, 'totalSave': 0 }, { merge: true });
  });
  //batch write to firestore
  await batch.commit();
};


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




//todo updatecustomcardname   -- similar to wallet (update the custom name)
exports.updateCustomCardName = functions.firestore.document('users/{userId}/myCards/{myCardId}').onUpdate(async (change, context) => {
  const before = change.before.data();
  const after = change.after.data();
  const myCardId = context.params.myCardId;
  const newCardCustomName = after.customName;
  // console.log(before, 'fffffff ', after);

  const myTransactionsCollection = admin.firestore().collection('users').doc(context.params.userId).collection('myTransactions');

  if (before.customName != after.customName) {
    const myTransactionsSnapshot = await myTransactionsCollection.get();

    myTransactionsSnapshot.forEach(async doc => {
      // console.log(doc.id, '=>', doc.data());
      const monthlyTransactionsCollection = await myTransactionsCollection.doc(doc.id).collection('monthlyTransactions').where('isWallet', '==', 'card').where('fundSourceCustomId', '==', myCardId).get();
      //create batch write
      const batch = admin.firestore().batch();

      monthlyTransactionsCollection.forEach((doc) => {
        const docRef = doc.ref;
        //use batch write to update
        batch.update(docRef, { 'fundSourceCustom': newCardCustomName });
      });
      //batch write to firestore
      await batch.commit();
    });
  }

});


//todo update to mycashback 






//todo deleteAtMyCashback --> u(mycards) -> u(myCashbacks)   <-- not sure if needed 