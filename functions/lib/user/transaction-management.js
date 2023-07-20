const functions = require("firebase-functions");

// Firebase Admin SDK
const admin = require("firebase-admin");

// auth
const { getAuth } = require("firebase-admin/auth");

// firebase function logging
require("firebase-functions/logger/compat");

const addSpendingCatSet = async (monthYearIdPathRef, category, categoryId, amount) => {
  // const monthYearIdPathRef = admin.firestore().collection(path[0] + '/' + path[1] + '/' + path[2]).doc(path[3]);

  var summary =
    (await monthYearIdPathRef.get()).data();

  if (summary.hasOwnProperty(categoryId)) {
    //update existing field

    const current = summary[categoryId];
    const currentCatSpending = current.amount;
    const currentColor = current.categoryColor;
    monthYearIdPathRef.update(
      {
        [categoryId]: {
          'amount': currentCatSpending + amount,
          'categoryName': category,
          'categoryColor': currentColor
        }
      }
    );

  } else {
    //create new field
    const color = (await admin.firestore().collection('categories').doc(categoryId).get()).data();
    console.log(color);
    monthYearIdPathRef.set({
      [categoryId]: {
        'amount': amount,
        'categoryName': category,
        'categoryColor': color.color,
      }
    }, { merge: true });

  }
}

//?for transactions create summary items when document is created
exports.addTransaction = functions.firestore.document('users/{userId}/myTransactions/{monthYearId}/monthlyTransactions/{transactionId}').onCreate(async (snap, context) => {
  const newDocumentRef = snap.ref;
  const newValue = snap.data();
  const path = newDocumentRef.path.split("/");
  const monthYearIdPathRef = admin.firestore().collection(path[0] + '/' + path[1] + '/' + path[2]).doc(path[3]);

  //get transaction count to determine use set or update option
  var transactionDocCount =
    (await admin.firestore().collection(path[0] + '/' + path[1] + '/' + path[2] + '/' + path[3] + '/' + path[4]).count().get()).data().count;

  //for total spend
  if (transactionDocCount > 1) {
    //when transaction of the month is more than 1
    //read current then add new value to it
    const currentTotalSpending = (await monthYearIdPathRef.get()).data().totalSpending;
    monthYearIdPathRef.update({ 'totalSpending': currentTotalSpending + newValue.amount });
    console.log('aa', newValue.category);

    //category spending summary
    addSpendingCatSet(monthYearIdPathRef, newValue.category, newValue.categoryId, newValue.amount);
  } else {
    //initialize by setting it so can find later
    monthYearIdPathRef.set({ 'totalSpending': newValue.amount });

    //category spending summary
    addSpendingCatSet(monthYearIdPathRef, newValue.category, newValue.categoryId, newValue.amount);

  }
});

exports.deleteTransaction = functions.firestore.document('users/{userId}/myTransactions/{monthYearId}/monthlyTransactions/{transactionId}').onDelete(async (snap, context) => {
  const deletedValue = snap.data();
  const documentRef = snap.ref;
  const path = documentRef.path.split("/");
  const monthYearIdPathRef = admin.firestore().collection(path[0] + '/' + path[1] + '/' + path[2]).doc(path[3]);


  const monthYearDocumentData = (await monthYearIdPathRef.get()).data();

  // const currentTotalSpending = (await monthYearIdPathRef.get()).data().totalSpending;
  const currentTotalSpending = monthYearDocumentData.totalSpending;
  monthYearIdPathRef.update({ 'totalSpending': currentTotalSpending - deletedValue.amount });

  const current = monthYearDocumentData[deletedValue.categoryId];
  const currentCatSpending = current.amount;
  const currentColor = current.categoryColor;
  monthYearIdPathRef.update(
    {
      [deletedValue.categoryId]: {
        'amount': currentCatSpending - deletedValue.amount,
        'categoryName': deletedValue.category,
        'categoryColor': currentColor
      }
    }
  );
});


const updateSpendingCatSet = async (monthYearIdPathRef, before, after) => {
  // const monthYearIdPathRef = admin.firestore().collection(path[0] + '/' + path[1] + '/' + path[2]).doc(path[3]);

  //update the total speding
  const currentTotalSpending = (await monthYearIdPathRef.get()).data().totalSpending;
  console.log(currentTotalSpending);
  monthYearIdPathRef.update({ 'totalSpending': currentTotalSpending - before.amount + after.amount });

  //console.log(currentTotalSpending);

  var summary =
    (await monthYearIdPathRef.get()).data();
  //category did not change
  if (before.categoryId == after.categoryId) {

    const current = summary[before.categoryId];
    console.log(current);
    const currentCatSpending = current.amount;
    console.log(currentCatSpending);

    const currentColor = current.categoryColor;
    console.log(currentColor);
    console.log(summary[before.categoryId].categoryName);

    monthYearIdPathRef.update(
      {
        [before.categoryId]: {
          'amount': currentCatSpending - before.amount + after.amount,
          'categoryName': summary[before.categoryId].categoryName,
          'categoryColor': currentColor
        }
      }
    );
  }


  if (before.categoryId != after.categoryId) {

    const currentBefore = summary[before.categoryId];
    console.log(currentBefore);
    const currentBeforeCatSpending = currentBefore.amount;
    console.log(currentBeforeCatSpending);

    const currentBeforeColor = currentBefore.categoryColor;
    console.log(currentBeforeColor);
    // console.log(summary[before.categoryId].categoryName);

    //before category -- <-- here remove the amount form original
    monthYearIdPathRef.update(
      {
        [before.categoryId]: {
          'amount': currentBeforeCatSpending - before.amount,
          'categoryName': summary[before.categoryId].categoryName,
          'categoryColor': currentBeforeColor
        }
      }
    );

    addSpendingCatSet(monthYearIdPathRef, after.category, after.categoryId, after.amount);
  }
}
exports.updateTransaction = functions.firestore.document('users/{userId}/myTransactions/{monthYearId}/monthlyTransactions/{transactionId}').onUpdate(async (change, context) => {
  const documentPath = context.params.userId;
  const before = change.before.data();
  const after = change.after.data();

  const beforeYM = before.date.toDate().getFullYear() + '_' + (before.date.toDate().getMonth() + 1);
  const afterYM = after.date.toDate().getFullYear() + '_' + (after.date.toDate().getMonth() + 1);

  if (beforeYM != afterYM) {
    const destinationCollection = admin.firestore().collection('users').doc(context.params.userId).collection('myTransactions').doc(afterYM).collection('monthlyTransactions');
    //set the new data in the correct collection
    destinationCollection.doc().set(after);
    //delete the current one
    admin.firestore().collection('users').doc(context.params.userId).collection('myTransactions').doc(context.params.monthYearId).collection('monthlyTransactions').doc(context.params.transactionId).delete();
  } else {
    //same yyyy_mm
    console.log('same    ');
    const monthYearIdPathRef = admin.firestore().collection('users').doc(context.params.userId).collection('myTransactions').doc(afterYM);
    updateSpendingCatSet(monthYearIdPathRef, before, after);
  }
});
