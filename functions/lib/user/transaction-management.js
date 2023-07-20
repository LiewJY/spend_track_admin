const functions = require("firebase-functions");

// Firebase Admin SDK
const admin = require("firebase-admin");

// auth
const { getAuth } = require("firebase-admin/auth");

// firebase function logging
require("firebase-functions/logger/compat");


//  add
//   ---------------------------------------------------------------- 
//   ---------------------------------------------------------------- 
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
    // console.log(color);
    monthYearIdPathRef.set({
      [categoryId]: {
        'amount': amount,
        'categoryName': category,
        'categoryColor': color.color,
      }
    }, { merge: true });

  }
}

// add for cashback calculation
const addSpendingToCashback = async (newValue, userId) => {
  console.log(' in addSpendingToCashback', newValue.fundSourceCustomId, ' ', newValue.category, ' ', newValue.categoryId, ' ', newValue.amount, ' ', newValue.date, ' ', userId);

  //date
  const day = newValue.date.toDate().getDate();
  const month = newValue.date.toDate().getMonth() + 1;
  const year = newValue.date.toDate().getFullYear();
  const transactionDate = new Date(`${year}-${month}-${day + 1}`);

  const myCashbackRef = admin.firestore().collection('users').doc(userId).collection('myCashbacks').where('myCardUid', '==', newValue.fundSourceCustomId).where('validUntil', '>=', transactionDate).orderBy('validUntil', 'desc');
  const myCashbackSnapshot = await myCashbackRef.get();

  var haveMatch = false;
  var sampleDate;
  var sampleData;
  myCashbackSnapshot.forEach(doc => {
    const data = doc.data();
    //  console.log(doc.id, '=>', doc.data());
    const validUntilDate = data.validUntil.toDate();
    //use as sample to add new one
    sampleDate = validUntilDate;
    sampleData = data;
    const day = validUntilDate.getDate();
    const month = validUntilDate.getMonth() + 1;
    const year = validUntilDate.getFullYear();
    const lowerBoundDate = new Date(`${year}-${month - 1}-${day}`);
    const upperBoundDate = new Date(`${year}-${month}-${day}`);
    // console.log(' lowerBoundDate =>', lowerBoundDate);
    // console.log(' upperBoundDate =>', upperBoundDate);
    // console.log(' transactionDate =>', transactionDate);

    // if()
    // if (targetTimestamp >= lowerBoundTimestamp && targetTimestamp <= upperBoundTimestamp) {

    if (transactionDate > lowerBoundDate && transactionDate <= upperBoundDate) {
      //add here because matches
      // console.log('he here ' , doc.id, '=>', doc.data());
      doc.ref.update({ 'totalSpending': data.totalSpending + newValue.amount });
      addToCashbackCategories(doc.id, userId, newValue, transactionDate);

      //there is match no need to create new one
      haveMatch = true;
      return;
    }
  });

  // console.log('he here have match ', '=>', haveMatch);
  if (haveMatch == false) {
    //create a new myCashback doc
    addToMyCashback(newValue.fundSourceCustomId, userId, newValue, sampleDate, sampleData, transactionDate);
  }
}

//add transaction to the categories
const addToCashbackCategories = async (docId, userId, newValue, transactionDate) => {
  const myCashbackCategoryRef = admin.firestore().collection('users').doc(userId).collection('myCashbacks').doc(docId).collection('categories');

  const myCashbackCategorySnapshot = await myCashbackCategoryRef.where('categoryId', '==', newValue.categoryId).get();
  if (!myCashbackCategorySnapshot.empty) {
    //add to the category if exist
    myCashbackCategorySnapshot.forEach(doc => {
      // console.log(doc.id, '=> ' , doc.data());
      //doc.data().spendingDay
      //1 - 7 sunday - saturday

      // console.log('day of spendingDay ', doc.data().spendingDay);
      // console.log('day of transactionDate ', transactionDate);

      //  const day = transactionDate.getDay();

      // console.log('day of transaction ', day);
      addTotalToCategory(doc.ref, transactionDate.getDay(), doc.data().spendingDay, doc.data().totalSpend, newValue.amount);

    });
  } else if (!(await myCashbackCategoryRef.where('category', '==', 'Any').get()).empty) {
    //add to any (will take all category other than mentioned to calculate the cashback)
    const myCashbackCategoryAnySnapshot = await myCashbackCategoryRef.where('category', '==', 'Any').get();
    myCashbackCategoryAnySnapshot.forEach(doc => {
      addTotalToCategory(doc.ref, transactionDate.getDay(), doc.data().spendingDay, doc.data().totalSpend, newValue.amount);
    });
  }
};


//add the total spend in category
const addTotalToCategory = async (docRef, day, spendingDay, totalSpend, amount) => {
  var dayCategory;
  if (day == 0 || day == 6) {
    dayCategory = 'Weekends';
  } if (day >= 1 && day <= 5) {
    dayCategory = 'Weekdays';
  }
  //  console.log('day of dayCategory ', dayCategory);
  if (spendingDay == 'Weekends' && dayCategory == 'Weekends') {
    // console.log('weekend');
    docRef.update({ 'totalSpend': totalSpend + amount });
  } else if (spendingDay == 'Weekdays' && dayCategory == 'Weekdays') {
    // console.log('Weekdays');
    docRef.update({ 'totalSpend': totalSpend + amount });
  } else if (spendingDay == 'Everyday') {
    // console.log('Everyday');
    docRef.update({ 'totalSpend': totalSpend + amount });
  }
};

// only call this when no valid cashback is avlilable
//similar to card-management
const addToMyCashback = async (myCardsUid, userId, newValue, sampleDate, sampleData, transactionDate) => {
  //check if exist already (uid and valid date )
  const myCashbackRef = admin.firestore().collection('users').doc(userId).collection('myCashbacks');
  const day = sampleDate.getDate();
  const month = transactionDate.getMonth() + 1;
  const year = transactionDate.getFullYear();

  var date;
  if (month > 11) {
    date = new Date(`${year + 1}-${0}-${day}`);
  } else {
    date = new Date(`${year}-${month}-${day}`);
  }

  const newDocRef = myCashbackRef.doc();
  await newDocRef.set({
    'name': sampleData.name,
    'bank': sampleData.bank,
    'cardType': sampleData.cardType,
    'lastNumber': sampleData.lastNumber,
    'customName': sampleData.customName,
    'totalSpending': newValue.amount,
    'validUntil': date,
    'myCardUid': myCardsUid,
  });

  // newDoc
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

  //add cashback to its category
  addToCashbackCategories(newDocRef.id, userId, newValue, transactionDate);

};

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

  //for cashback
  //todo
  if (newValue.isWallet == 'card' && newValue.isCashbackEligible == true) {
    addSpendingToCashback(newValue, context.params.userId);
  }

});

//  delete
//   ---------------------------------------------------------------- 
//   ---------------------------------------------------------------- 
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
  // console.log('falecvdfvsdfsd    dvdvsdfs     ', deletedValue.isWallet);

  //cashback part
  //date
  if (deletedValue.isWallet == 'card' && deletedValue.isCashbackEligible == true) {
    const day = deletedValue.date.toDate().getDate();
    const month = deletedValue.date.toDate().getMonth() + 1;
    const year = deletedValue.date.toDate().getFullYear();
    const transactionDate = new Date(`${year}-${month}-${day + 1}`);
    // console.log('transactionDate', transactionDate);

    //similar to addSpendingToCashback
    const myCashbackRef = admin.firestore().collection('users').doc(context.params.userId).collection('myCashbacks').where('myCardUid', '==', deletedValue.fundSourceCustomId).where('validUntil', '>=', transactionDate).orderBy('validUntil', 'desc');
    const myCashbackSnapshot = await myCashbackRef.get();


    myCashbackSnapshot.forEach(doc => {
      // console.log(doc.id, '=>', doc.data());
      const data = doc.data();
      //  console.log(doc.id, '=>', doc.data());
      const validUntilDate = data.validUntil.toDate();
      //use as sample to add new one
      const day = validUntilDate.getDate();
      const month = validUntilDate.getMonth() + 1;
      const year = validUntilDate.getFullYear();
      const lowerBoundDate = new Date(`${year}-${month - 1}-${day}`);
      const upperBoundDate = new Date(`${year}-${month}-${day}`);
      // console.log(' lowerBoundDate =>', lowerBoundDate);
      // console.log(' upperBoundDate =>', upperBoundDate);
      // console.log(' transactionDate =>', transactionDate);

      if (transactionDate > lowerBoundDate && transactionDate <= upperBoundDate) {
        //add here because matches
        // console.log('he here ' , doc.id, '=>', doc.data());
        doc.ref.update({ 'totalSpending': data.totalSpending - deletedValue.amount });

        minusTotalSpendInCategory(doc.id, context.params.userId, deletedValue, transactionDate);

        return;
      }
    });
  }
});

const minusTotalSpendInCategory = async (docId, userId, deletedValue, transactionDate) => {
  const myCashbackCategoryRef = admin.firestore().collection('users').doc(userId).collection('myCashbacks').doc(docId).collection('categories');
  // console.log('minusTotalSpendInCategory ');
  // console.log('deletedValue ', deletedValue);
  const myCashbackCategorySnapshot = await myCashbackCategoryRef.where('categoryId', '==', deletedValue.categoryId).get();

  if (!myCashbackCategorySnapshot.empty) {
    //delete from the category if exist
    myCashbackCategorySnapshot.forEach(doc => {
      console.log(doc.id, '=>', doc.data());
      minusTotalInCategory(doc.ref, transactionDate.getDay(), doc.data().spendingDay, doc.data().totalSpend, deletedValue.amount);

    });
  } else if (!(await myCashbackCategoryRef.where('category', '==', 'Any').get()).empty) {
    //delete at any (will take all category other than mentioned to calculate the cashback)
    const myCashbackCategoryAnySnapshot = await myCashbackCategoryRef.where('category', '==', 'Any').get();
    myCashbackCategoryAnySnapshot.forEach(doc => {
      minusTotalInCategory(doc.ref, transactionDate.getDay(), doc.data().spendingDay, doc.data().totalSpend, deletedValue.amount);
    });
  }

};

const minusTotalInCategory = async (docRef, day, spendingDay, totalSpend, amount) => {
  var dayCategory;
  if (day == 0 || day == 6) {
    dayCategory = 'Weekends';
  } if (day >= 1 && day <= 5) {
    dayCategory = 'Weekdays';
  }
  if (spendingDay == 'Weekends' && dayCategory == 'Weekends') {
    docRef.update({ 'totalSpend': totalSpend - amount });
  } else if (spendingDay == 'Weekdays' && dayCategory == 'Weekdays') {
    docRef.update({ 'totalSpend': totalSpend - amount });
  } else if (spendingDay == 'Everyday') {
    docRef.update({ 'totalSpend': totalSpend - amount });
  }
};


//  update
//   ---------------------------------------------------------------- 
//   ---------------------------------------------------------------- 

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
    // console.log(current);
    const currentCatSpending = current.amount;
    // console.log(currentCatSpending);

    const currentColor = current.categoryColor;
    // console.log(currentColor);
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
    // console.log(currentBefore);
    const currentBeforeCatSpending = currentBefore.amount;
    // console.log(currentBeforeCatSpending);

    const currentBeforeColor = currentBefore.categoryColor;
    // console.log(currentBeforeColor);
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

//todo for cashback
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
    // console.log('same    ');
    const monthYearIdPathRef = admin.firestore().collection('users').doc(context.params.userId).collection('myTransactions').doc(afterYM);
    updateSpendingCatSet(monthYearIdPathRef, before, after);
  }


  ///FOR CASHBACKS
  //delete old one then add 
  if (before.isWallet == 'card' && before.isCashbackEligible == true) {
    //if is card then trigger the cashback part
    await deleteCashback(context.params.userId, before, after);
  }







});
const addCashback = async (userId, before) => {
};

const deleteCashback = async (userId, before, after) => {

  const day = before.date.toDate().getDate();
  const month = before.date.toDate().getMonth() + 1;
  const year = before.date.toDate().getFullYear();
  const transactionDate = new Date(`${year}-${month}-${day + 1}`);
  // console.log('transactionDate', transactionDate);

  //similar to addSpendingToCashback
  const myCashbackRef = admin.firestore().collection('users').doc(userId).collection('myCashbacks').where('myCardUid', '==', before.fundSourceCustomId).where('validUntil', '>=', transactionDate).orderBy('validUntil', 'desc');
  const myCashbackSnapshot = await myCashbackRef.get();


  myCashbackSnapshot.forEach(doc => {
    // console.log(doc.id, '=>', doc.data());
    const data = doc.data();
    //  console.log(doc.id, '=>', doc.data());
    const validUntilDate = data.validUntil.toDate();
    //use as sample to add new one
    const day = validUntilDate.getDate();
    const month = validUntilDate.getMonth() + 1;
    const year = validUntilDate.getFullYear();
    const lowerBoundDate = new Date(`${year}-${month - 1}-${day}`);
    const upperBoundDate = new Date(`${year}-${month}-${day}`);
    // console.log(' lowerBoundDate =>', lowerBoundDate);
    // console.log(' upperBoundDate =>', upperBoundDate);
    // console.log(' transactionDate =>', transactionDate);

    if (transactionDate > lowerBoundDate && transactionDate <= upperBoundDate) {
      //add here because matches
      // console.log('he here ' , doc.id, '=>', doc.data());
      doc.ref.update({ 'totalSpending': data.totalSpending - before.amount });
      minusTotalSpendInCategory(doc.id, userId, before, transactionDate);

      return;
    }
  });
  //add back
  await addSpendingToCashback(after, userId);
};








