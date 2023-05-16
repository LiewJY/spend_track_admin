import 'package:flutter/material.dart';

TextInputAction inputAction(String? inputAction) {
    switch (inputAction) {
      case 'next':
        return TextInputAction.next;
      default:
        return TextInputAction.done;
    }
}
