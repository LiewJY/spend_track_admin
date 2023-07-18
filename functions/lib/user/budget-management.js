const functions = require("firebase-functions");

// Firebase Admin SDK
const admin = require("firebase-admin");

// auth
const { getAuth } = require("firebase-admin/auth");

// firebase function logging
require("firebase-functions/logger/compat");

//?for budget create summary items when document is created
exports.addBudget = functions.firestore.document('users/{userId}/myBudgets/budgetSummary/budgets/{budgetId}').onCreate(async (snap, context) => {
  // note: budgetId == category id
  const newDocumentRef = snap.ref;
  const newValue = snap.data();
  const path = newDocumentRef.path.split("/");
  const summaryPathRef = admin.firestore().collection(path[0] + '/' + path[1] + '/' + path[2]).doc(path[3]);

  //get budget count to determine use set or update option
  var budgetDocCount =
    (await admin.firestore().collection(path[0] + '/' + path[1] + '/' + path[2] + '/' + path[3] + '/' + path[4]).count().get()).data().count;

  //for total budget
  if (budgetDocCount > 1) {
    //when budget more than 1
    //read current then add new value to it
    const currentTotalBudget = (await summaryPathRef.get()).data().totalBudget;
    summaryPathRef.update({ 'totalBudget': currentTotalBudget + newValue.amount });
  } else {
    //initialize by setting it so can find later
    summaryPathRef.set({ 'totalBudget': newValue.amount });
  }
});

exports.updateBudget = functions.firestore.document('users/{userId}/myBudgets/budgetSummary/budgets/{budgetId}').onUpdate(async (change, context) => {
  const before = change.before.data();
  const after = change.after.data();

  const budgetSummaryRef = (await admin.firestore().collection('users').doc(context.params.userId).collection('myBudgets').doc('budgetSummary'));
  const oldTotalBudget = (await budgetSummaryRef.get()).data().totalBudget;

  //update the amount
  budgetSummaryRef.update({ 'totalBudget': oldTotalBudget - before.amount +  after.amount});

});


exports.deleteBudget = functions.firestore.document('users/{userId}/myBudgets/budgetSummary/budgets/{budgetId}').onDelete(async (snap, context) => {
  const deletedValue = snap.data();
  const budgetSummaryRef = (await admin.firestore().collection('users').doc(context.params.userId).collection('myBudgets').doc('budgetSummary'));
  const oldTotalBudget = (await budgetSummaryRef.get()).data().totalBudget;

  //update the amount
  budgetSummaryRef.update({ 'totalBudget': oldTotalBudget - deletedValue.amount });

});




