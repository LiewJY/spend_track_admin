import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ManagementRepository {
  //firestore instance
  final db = FirebaseFirestore.instance;
  //cloud function instance
  final cf = FirebaseFunctions.instance;
  //for display all admin users
  _queryAdminUsers() async {
    List<Map<String, dynamic>> adminDataList = [];
    await FirebaseFirestore.instance.collection("admins").get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          adminDataList.add({'uid': docSnapshot.id});
        }
      },
      onError: (e) => print("Error completing: $e"),
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
          "filter": adminDataList,
        },
      );
      List<Map<String, dynamic>> userList = List.from(result.data);
      return userList;
    } catch (e) {
      log(e.toString());
      throw "unknown";
    }
  }

  //todo add admin

  //todo edit admin

  //todo delete admin

  //todo enable admin

  //todo disable admin
  
}
