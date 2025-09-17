import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TreatmentTile extends StatelessWidget {
  final String index;
  final String title;
  void Function()? onTap;
  final String femalecount;
  final String malecount;
  TreatmentTile(
      {super.key,
      required this.index,
      required this.title,
      required this.femalecount,
      required this.malecount,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: Color.fromRGBO(240, 240, 240, 1),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 310,
                child: Text(
                  "  $index. $title",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
              GestureDetector(
                  onTap: onTap,
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.red,
                  )),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 25,
              ),
              Text(
                "Male",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color.fromRGBO(0, 104, 55, 1)),
              ),
              Container(
                width: 44,
                height: 26,
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromRGBO(0, 0, 0, .25)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(malecount.toString(),
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(0, 0, 0, 1))),
                ),
              ),
              Text(
                "Female",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color.fromRGBO(0, 104, 55, 1)),
              ),
              Container(
                width: 44,
                height: 26,
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromRGBO(0, 0, 0, .25)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(femalecount.toString(),
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(0, 0, 0, 1))),
                ),
              ),
              GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.edit,
                    color: Colors.green[900],
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
