import 'package:flutter/material.dart';
import 'package:track_admin/l10n/l10n.dart';

String authErrorMessage(BuildContext context, String errorCode) {
  final l10n = context.l10n;
  switch (errorCode) {
    //login errors
    case 'user-disabled':
      return l10n.userDisabled;
    case 'user-not-found':
      return l10n.userNotFound;
    case 'wrong-password':
      return l10n.wrongPassword;
    //sign up error
    case 'invalid-email':
      return l10n.invalidEmail;
    case 'user-disabled':
      return l10n.userDisabled;
    case 'email-already-in-use':
      return l10n.emailAlreadyInUse;
    case 'operation-not-allowed':
      return l10n.operationNotAllowed;
    case 'weak-password':
      return l10n.weakPassword;
    default:
      return l10n.firebaseAuthDefault;
  }
}
