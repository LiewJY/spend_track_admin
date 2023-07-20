const functions = require("firebase-functions");

// Firebase Admin SDK
const admin = require("firebase-admin");

// auth
const { getAuth } = require("firebase-admin/auth");

// firebase function logging
require("firebase-functions/logger/compat");

exports.updateCategory = functions.firestore.document('categories/{categoryId}').onUpdate(async (change, context) => {
  const before = change.before.data();
  const after = change.after.data();
  const categoryId = context.params.categoryId;

  const usersCollection = admin.firestore().collection('users');

  if (before.color != after.color || before.name != after.name) {
    //only update if color name change
    const usersCollectionSnapshot = await usersCollection.get();

    usersCollectionSnapshot.forEach(async doc => {
      //create batch write
      const batch = admin.firestore().batch();

      // 1. update mybudget
      const budgetDocRef = usersCollection.doc(doc.id).collection('myBudgets').doc('budgetSummary').collection('budgets').doc(categoryId);

      const budgetDoc = await budgetDocRef.get();
      if (budgetDoc.exists) {
        batch.update(budgetDocRef, { 'color': after.color, 'name': after.name });
      }

      // 2. update mytransactions
      const transactionRef = usersCollection.doc(doc.id).collection('myTransactions');
      const transactionCollectionSnapshot = await transactionRef.get();
      transactionCollectionSnapshot.forEach(async doc => {
        // console.log(doc.id, ' => ', doc.data());
        const myTransactionData = doc.data();

        if (myTransactionData.hasOwnProperty(categoryId)) {
          const colorMap = categoryId + '.categoryColor';
          const nameMap = categoryId + '.categoryName';
          batch.update(doc.ref, { [colorMap]: after.color, [nameMap]: after.name });
        }

        // 3. update monthlytransactions
        const monthlyTransactionSnapshot = await doc.ref.collection('monthlyTransactions').where('categoryId', '==', categoryId).get();
        //create batch write 2
        const batch2 = admin.firestore().batch();
        monthlyTransactionSnapshot.forEach(async doc => {
          batch2.update(doc.ref, { 'category': after.name });
        });
        //batch write to firestore
        await batch2.commit();
      });

      //todo maybe for categories in mycashback
      
      //batch write to firestore
      await batch.commit();
    });


    //for admin (cards) collection 
    const cardRef = admin.firestore().collection('cards');
    const cardSnapshot = await cardRef.get();

    cardSnapshot.forEach(async (doc) => {
      console.log(doc.id, ' => ', doc.data());
      const cashbackRef = doc.ref.collection('cashbacks');
      const cashbackSnapshot = await cashbackRef.where('categoryId', '==', categoryId).get();
      //create batch write
      const batch3 = admin.firestore().batch();
      cashbackSnapshot.forEach(async (doc) => {
        batch3.update(doc.ref, { 'category': after.name });
      });
      //batch write to firestore
      await batch3.commit();
    });

  }
});
