const functions = require("firebase-functions");

// Firebase Admin SDK
const admin = require("firebase-admin");

// auth
const { getAuth } = require("firebase-admin/auth");

// firebase function logging
require("firebase-functions/logger/compat");


// delete card 
exports.deleteCard = functions.https.onCall(async (data, context) => {

  return admin.firestore().recursiveDelete(admin.firestore().collection('cards').doc(data.uid)).then(() => {
    console.log('Successfully deleted card');
  }
  ).catch((error) => {
    console.log('Error deleting card:', error);
    return error;
  });;

});

//firestore triggered functions
//todo

//todo updatecard -> admin(card) -> user(mycards)
//similar to wallet









//todo 
//todo 
//todo
//todo : trigger changes for credit cards, cashbacks and wallets
//fixme  card update can replicate for wallet 
exports.triggerUpdateCards = functions.firestore.document('wallets/{cardsId}')
  .onUpdate(async (change, context) => {

    const before = change.before.data();
    const after = change.after.data();

    const uid = context.params.cardsId;
    console.log('Document ID:', uid);

    const usersSnapshot = await admin.firestore().collection('users').get();
    const batch = admin.firestore().batch();
    usersSnapshot.forEach(async (userDoc) => {
      const myWalletsRef = userDoc.ref.collection('myWallets').where('uid', '==', uid).get();
      //todo
      myWalletsRef.forEach(async (walletref) => {
        console.log('werewrwrw');
      });

      // if (!myWalletsRef.empty) {
      //   // const targetDocumentRef = myWalletsRef.docs.ref;
      //   // await targetDocumentRef.update({ description: after.description });
      //   console.log('Description updated in target document');
      // } else {
      //   console.log('Target document not found');
      // }




      // if (!myWalletsRef.empty) {


      //     // const targetDocumentRef = querySnapshot.docs[0].ref;
      //     // await targetDocumentRef.update({ description: after.description });
      //     console.log('Description updated in target document');
      //   } else {
      //     console.log('Target document not found');
      //   }
      // batch.update(
      //    myWalletsRef.update({description : 'dddddd'})
      //   );
      // Repeat the above line for each document within myWallets collection


    });
    await batch.commit();

    //console.log('myWallets updated for all users');

    // } catch (error) {
    //   console.error('Error updating myWallets:', error);
    // }

    //  try {
    //   const usersSnapshot = await admin.firestore().collection('users').get();

    //   const batch = admin.firestore().batch();

    //   usersSnapshot.forEach((userDoc) => {
    //     const myWalletsRef = userDoc.ref.collection('myWallets');

    //     batch.update(myWalletsRef.doc('myWalletId'), { /* Update fields here */ });
    //     // Repeat the above line for each document within myWallets collection
    //   });

    //   await batch.commit();

    //   console.log('myWallets updated for all users');
    // } catch (error) {
    //   console.error('Error updating myWallets:', error);
    // }

    // console.log('Document ID:', id);


    // const querySnapshot = await admin.firestore().collection('users/F33La1CkhI1krgDxjGVac8diwmJU/myWallets').get();

    // .where('uid', '==', '2sSHuH1dX4fSFyaK7byZ').get();

    // if (!querySnapshot.empty) {
    //   // const targetDocumentRef = querySnapshot.docs[0].ref;
    //   // await targetDocumentRef.update({ description: after.description });
    //   console.log('Description updated in target document');
    // } else {
    //   console.log('Target document not found');
    // }





    // console.log( aaa);

    //  .then((data) => {
    //  // console.log('yayayaya     dsssw');


    // });



    // admin.firestore().collection('admins').doc(userRecord.uid).set({ 'admin': true });


    // Get an object representing the document
    // // e.g. {'name': 'Marie', 'age': 66}
    // const newValue = change.after.data();

    // // ...or the previous value before this update
    // const previousValue = change.before.data();

    // // access a particular field as you would any JS property
    // const name = newValue.name;

    // perform desired operations ...
  });






// exports.deleteMyCardCashbacksCollection = functions.firestore.document('users/{userId}/myCards/{cardsId}').onDelete((snap, context) => {
//   const deleteDocumentRef = snap.ref;
//   admin.firestore().recursiveDelete(deleteDocumentRef).then(() => {
//     console.log('Successfully deleted card');
//   }
//   ).catch((error) => {
//     console.log('Error deleting card:', error);
//     return error;
//   });;

// });