const functions = require("firebase-functions");

// Firebase Admin SDK
const admin = require("firebase-admin");

// auth
const { getAuth } = require("firebase-admin/auth");

// firebase function logging
require("firebase-functions/logger/compat");

exports.updateCustomWalletName = functions.firestore.document('users/{userId}/myWallets/{myWalletId}').onUpdate(async (change, context) => {
  const before = change.before.data();
  const after = change.after.data();
  const walletUid = context.params.myWalletId;
  const newWalletCustomName = after.customName;
  // console.log(before, 'fffffff ', after);

  const myTransactionsCollection = admin.firestore().collection('users').doc(context.params.userId).collection('myTransactions');

  if (before.customName != after.customName) {
    const myTransactionsSnapshot = await myTransactionsCollection.get();

    myTransactionsSnapshot.forEach(async doc => {
      // console.log(doc.id, '=>', doc.data());
      const monthlyTransactionsCollection = await myTransactionsCollection.doc(doc.id).collection('monthlyTransactions').where('isWallet', '==', 'wallet').where('fundSourceCustomId', '==', walletUid).get();
      //create batch write
      const batch = admin.firestore().batch();

      monthlyTransactionsCollection.forEach((doc) => {
        const docRef = doc.ref;
        //use batch write to update
        batch.update(docRef, { 'fundSourceCustom': newWalletCustomName });
      });
      //batch write to firestore
      await batch.commit();
    });
  }

});
