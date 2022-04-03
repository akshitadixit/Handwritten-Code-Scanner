// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class customTextField extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  const customTextField({Key? key, this.controller}) : super(key: key);

  @override
  State<customTextField> createState() => _customTextFieldState();
}

class _customTextFieldState extends State<customTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.greenAccent[400],
      cursorRadius: const Radius.circular(10.0),
      cursorWidth: 5.0,
      controller: widget.controller,
      keyboardAppearance: Brightness.dark,
      keyboardType: TextInputType.multiline,
      maxLines: 99,
      style: TextStyle(color: Colors.blue[50]),
      decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.blueGrey[800],
          contentPadding: const EdgeInsets.all(8.0),
          hintText: "Start writing your code here."),
    );
  }
}
