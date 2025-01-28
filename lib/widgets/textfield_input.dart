import 'package:flutter/material.dart';

class TextfieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool ispassword;
  final String hinttext;
  final TextInputType textinputtype;
  const TextfieldInput(
      {super.key,
      required this.hinttext,
      this.ispassword = false,
      required this.textEditingController,
      required this.textinputtype});

  @override
  Widget build(BuildContext context) {
    final InputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
          border: InputBorder,
          hintText: hinttext,
          focusedBorder: InputBorder,
          enabledBorder: InputBorder,
          filled: true,
          contentPadding: const EdgeInsets.all(8)),
      keyboardType: textinputtype,
      obscureText: ispassword,
    );
  }
}
