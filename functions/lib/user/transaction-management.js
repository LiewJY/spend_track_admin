const functions = require("firebase-functions");

// Firebase Admin SDK
const admin = require("firebase-admin");

// auth
const { getAuth } = require("firebase-admin/auth");

// firebase function logging
require("firebase-functions/logger/compat");

const addSpendingCatSet = async (path, category, categoryId, amount) => {
  const monthYearIdPathRef = admin.firestore().collection(path[0] + '/' + path[1] + '/' + path[2]).doc(path[3]);

  var summary =
    (await monthYearIdPathRef.get()).data();

  if (summary.hasOwnProperty(categoryId)) {
    //update existing field
    const currentCatSpending = (await monthYearIdPathRef.get()).data()[categoryId].amount;
    monthYearIdPathRef.update(
      {
        [categoryId]: {
          'amount': currentCatSpending + amount,
          'categoryName': category,
        }
      }
    );

  } else {
    //create new field
    //todo
    monthYearIdPathRef.set({
      [categoryId]: {
        'amount': amount,
        'categoryName': category,
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
    addSpendingCatSet(path, newValue.category, newValue.categoryId, newValue.amount);
  } else {
    //initialize by setting it so can find later
    monthYearIdPathRef.set({ 'totalSpending': newValue.amount });

    //category spending summary
    addSpendingCatSet(path, newValue.category, newValue.categoryId, newValue.amount);

  }
});

