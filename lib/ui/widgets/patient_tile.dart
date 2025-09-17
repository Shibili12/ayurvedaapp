import 'package:ayurvedaapp/data/models/patient_models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PatientTile extends StatelessWidget {
  final Patient patient;
  final int index;
  const PatientTile({super.key, required this.patient, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 166,
      decoration: BoxDecoration(
        color: Color.fromRGBO(240, 240, 240, 1),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 18,
              ),
              Container(
                width: 310,
                child: Text(
                  " $index . ${patient.name}",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 25,
              ),
              Text(
                patient.details[0].treatmentName ?? "",
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                  color: Color.fromRGBO(0, 104, 55, 1),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 25,
              ),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.red,
                    size: 15,
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(patient.dateTime) ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Color.fromRGBO(0, 0, 0, .5),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 25,
              ),
              Row(
                children: [
                  Icon(
                    Icons.call,
                    color: Colors.red,
                    size: 15,
                  ),
                  Text(
                    patient.phone ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Color.fromRGBO(0, 0, 0, .5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(
            color: Color.fromRGBO(0, 0, 0, .2),
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "View Details",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Color.fromRGBO(0, 0, 0, .5),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Color.fromRGBO(0, 104, 55, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
