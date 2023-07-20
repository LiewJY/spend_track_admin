const functions = require("firebase-functions");

// Firebase Admin SDK
const admin = require("firebase-admin");

// auth
const { getAuth } = require("firebase-admin/auth");

// firebase function logging
require("firebase-functions/logger/compat");





// this code is a duplication from transaction-management
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

// dupliation //////// xxxssqwswqwewe
