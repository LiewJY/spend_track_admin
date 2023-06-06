import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//todo try to migtate here
class DataTableSearchField extends StatefulWidget {
  const DataTableSearchField(
      {super.key, required this.controller, required this.hintText, required this.action});

  final TextEditingController controller;
  final String hintText;
  final  action;

  @override
  State<DataTableSearchField> createState() => _DataTableSearchFieldState();
}

class _DataTableSearchFieldState extends State<DataTableSearchField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: widget.hintText,
          border: InputBorder.none
          //todo
          // suffixIcon: IconButton(
          //   icon: Icon(Icons.close),
          //   onPressed: () => clear(),
          // ),
          ),
      onChanged: 
        widget.action,
    );




  }
}
