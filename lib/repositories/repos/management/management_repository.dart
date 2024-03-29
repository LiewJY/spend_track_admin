import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManagementRepository {
  //firestore instance
  final db = FirebaseFirestore.instance;
  //cloud function instance
  final cf = FirebaseFunctions.instance;
  //for display all admin users
  _queryAdminUsers() async {
    List<Map<String, dynamic>> adminDataList = [];
    await FirebaseFirestore.instance.collection('admins').get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          adminDataList.add({'uid': docSnapshot.id});
        }
      },
      onError: (e) => print('Error completing: $e'),
    );
    return adminDataList;
  }

  Future<List<Map<String, dynamic>>> getAdminUsers() async {
    List<Map<String, dynamic>> adminDataList = await _queryAdminUsers();
    try {
      //call cloud function with admin sdk
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('adminUsers');
      //query param
      final result = await callable.call(
        {
          'filter': adminDataList,
        },
      );
      List<Map<String, dynamic>> userList = List.from(result.data);
      return userList;
    } catch (e) {
      log(e.toString());
      throw 'cannotRetrieveData';
    }
  }

  //add admin
  addAdmin(
      {required String email,
      required String password,
      required String name}) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('addUser');
      final result = await callable.call({
        'email': email,
        'password': password,
        'name': name,
        'isAdmin': true,
      });

      if (result.data.toString() == 'auth/email-already-exists') {
        throw 'email-already-exists';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  //toggle enable admin
  toggleEnableUser({required String uid, required bool isEnabled}) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('toggleEnableUser');
      final result = await callable.call(
        {
          'uid': uid,
          'isEnabled': isEnabled,
        },
      );
      if (result.data.toString() == 'null') {
        throw 'unknown';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  //delete admin
  deleteAdmin({required String uid}) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('deleteAdminUser');
      final result = await callable.call(
        {
          'uid': uid,
          'isAdmin': true,
        },
      );
      log(result.data.toString());
      if (result.data.toString() != 'null') {
        throw 'unknown';
      }
    } catch (e) {
      throw e.toString();
    }
  }
  
    Future<void> sendResetPasswordEmail({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    // } on FirebaseAuth.FirebaseAuthException catch (e) {
    //   throw e.code;
    } catch (_) {
      throw "unknown";
    }
  }
}
