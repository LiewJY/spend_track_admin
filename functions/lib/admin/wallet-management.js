const functions = require("firebase-functions");

// Firebase Admin SDK
const admin = require("firebase-admin");

// auth
const { getAuth } = require("firebase-admin/auth");

// firebase function logging
require("firebase-functions/logger/compat");

exports.updateWallet = functions.firestore.document('wallets/{walletId}').onUpdate(async (change, context) => {
  const after = change.after.data();
  const walletId = context.params.walletId;

  const usersCollection = admin.firestore().collection('users');
  const usersCollectionSnapshot = await usersCollection.get();
  usersCollectionSnapshot.forEach(async doc => {
    //create batch write
    const batch = admin.firestore().batch();
    const walletRef = usersCollection.doc(doc.id).collection('myWallets').where('uid', '==', walletId);
    const walletSnapshot = await walletRef.get();
    walletSnapshot.forEach(doc => {
      batch.update(doc.ref, { 'description': after.description, 'name': after.name });
    });
    //batch write to firestore
    await batch.commit();
  });
});
