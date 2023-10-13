const functions = require("firebase-functions");

// Firebase Admin SDK
const admin = require("firebase-admin");

// auth
const { getAuth } = require("firebase-admin/auth");

// firebase function logging
require("firebase-functions/logger/compat");



// update changed card info from user(myCards) to user(myCashbacks)
exports.updateCashback = functions.firestore.document('users/{userId}/myCards/{cardId}').onUpdate(async (change, context) => {
  const before = change.before.data();
  const after = change.after.data();
  const cardId = context.params.cardId;

  const myCashbackCollection = admin.firestore().collection('users').doc(context.params.userId).collection('myCashbacks');

  if (before.name != after.name || before.bank != after.bank || before.cardType != after.cardType || before.lastNumber != after.lastNumber || before.customName != after.customName || before.billingCycleDay != after.billingCycleDay) {
    const myCashbackSnapshot = await myCashbackCollection.where('myCardUid', '==', cardId).get();
    //create batch write
    const batch = admin.firestore().batch();
    myCashbackSnapshot.forEach(async doc => {
      // console.log(doc.id, '=>', doc.data());
      if (before.billingCycleDay != after.billingCycleDay) {
        const date = doc.data().validUntil.toDate();
        const day = after.billingCycleDay;
        const month = date.getMonth() + 1;
        const year = date.getFullYear();
        const newDate = new Date(`${year}-${month}-${day}`);
        //update with date
        batch.update(doc.ref, { 'name': after.name, 'bank': after.bank, 'cardType': after.cardType, 'lastNumber': after.lastNumber, 'customName': after.customName, 'validUntil': newDate });
      } else {
        batch.update(doc.ref, { 'name': after.name, 'bank': after.bank, 'cardType': after.cardType, 'lastNumber': after.lastNumber, 'customName': after.customName });
      }
    });
    //batch write to firestore
    await batch.commit();
  }
});

