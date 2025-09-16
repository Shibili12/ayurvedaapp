import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextfieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  Function? onpressed;
  String? Function(String?)? validator;

  MyTextfieldWidget(
      {super.key,
      required this.controller,
      required this.hint,
      this.onpressed,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromRGBO(217, 217, 217, .25),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, .1))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, .1))),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, .1))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, .1))),
        hintText: hint,
        hintStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w300),
      ),
      validator: validator,
    );
  }
}
