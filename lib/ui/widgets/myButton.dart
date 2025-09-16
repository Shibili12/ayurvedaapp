import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Mybutton extends StatelessWidget {
  final String title;
  void Function()? onTap;
   Mybutton({super.key, required this.title,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: Color.fromRGBO(0, 104, 55, 1),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 17, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
