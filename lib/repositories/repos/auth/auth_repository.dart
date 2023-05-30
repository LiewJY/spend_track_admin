import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:intl/date_time_patterns.dart';
import 'package:track_admin/repositories/models/user.dart';

class AuthRepository {
  //create firebase auth instance
  final firebase_auth.FirebaseAuth _firebaseAuth;
  AuthRepository({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  //init as empty
  var currentUser = User.empty;

  //return a stream of the current user
  Stream<User> get user {
    //var user;
    var firebaseUser = _firebaseAuth.currentUser;

    //return User(id: firebaseUser?.uid, email: firebaseUser?.email, name: firebaseUser?.displayName);

    return _firebaseAuth.userChanges().map((firebaseUser) {
      final currentUser =
          firebaseUser == null ? User.empty : firebaseUser.toUser;
      //return the mapped user
      return currentUser;
    });
  }

  //sign up
  //todo not in use
  Future<void> signUp(
      {required String email,
      required String password,
      required String name}) async {
    try {
      var authRegisterResult = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await authRegisterResult.user
          ?.updateDisplayName(name)
          .whenComplete(() => authRegisterResult.user?.reload());
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw e.code;
    } catch (_) {
      throw "unknown";
    }
  }

  //login
  Future<void> loginWithCredentials(
      {required String email, required String password}) async {
    try {
      var authLoginResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw e.code;
    } catch (_) {
      throw "unknown";
    }
  }

  //logout
  Future<void> logout() async {
    try {
      currentUser = User.empty;
      await Future.wait([_firebaseAuth.signOut()]);
    } catch (e) {
      throw Exception(e);
    }
  }

  //update name
  Future<void> updateName({required String name}) async {
    try {
      await _firebaseAuth.currentUser?.updateDisplayName(name);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw e.code;
    } catch (_) {
      throw "unknown";
    }
  }

  //check user role
  get isAdmin async {
    try {
      bool documentExists = false;
      // log(_firebaseAuth.currentUser?.uid ??'');
      documentExists = await FirebaseFirestore.instance
          .collection('admins')
          .doc(_firebaseAuth.currentUser?.uid)
          .get()
          .then((doc) => doc.exists);
      return documentExists;
    } catch (e) {
      log(e.toString());
    }
  }

  //reauth
  // //todo now not in use
  // Future<void> reAuth({required String email, required String password}) async {
  //   try {
  //     final credential = firebase_auth.EmailAuthProvider.credential(email : email, password : password);
  //     await _firebaseAuth.currentUser
  //         ?.reauthenticateWithCredential(credential);
  //   } on firebase_auth.FirebaseAuthException catch (e) {
  //     throw e.code;
  //   } catch (_) {
  //     throw "unknown";
  //   }
  // }

  //   Future<void> sendResetPasswordEmail({required String email}) async {
  //   try {
  //     await _firebaseAuth.sendPasswordResetEmail(email: email);
  //   } on firebase_auth.FirebaseAuthException catch (e) {
  //     throw e.code;
  //   } catch (_) {
  //     throw "unknown";
  //   }
  // }

  //todo
  //update profile

  //todo google login and link with account
  //google login
}

extension on firebase_auth.User {
  //map firebase user to user model
  User get toUser {
    return User(id: uid, email: email, name: displayName);
  }
}
