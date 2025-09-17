// lib/ui/screens/patients_list_screen.dart
import 'package:ayurvedaapp/data/models/patient_models.dart';
import 'package:ayurvedaapp/ui/screens/patient_form_screen.dart';
import 'package:ayurvedaapp/ui/widgets/myButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/patient_provider.dart';

import '../widgets/empty_list_widget.dart';
import '../widgets/patient_tile.dart';

class PatientsListScreen extends StatefulWidget {
  const PatientsListScreen({super.key});

  @override
  State<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<PatientProvider>(context, listen: false).fetchPatients();
    });
  }

  Future<void> _onRefresh() async {
    await Provider.of<PatientProvider>(context, listen: false).fetchPatients();
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        actions: const [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Badge(
              child: Icon(
                Icons.notifications_outlined,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(16, 15, 10, 15),
                  width: 250,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        disabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: "Serach for treatments",
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 12, fontWeight: FontWeight.w400),
                        prefixIcon: Icon(Icons.search)),
                  )),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 85.44,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: Color.fromRGBO(0, 104, 55, 1),
                  ),
                  child: Center(
                    child: Text(
                      "Search",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 10, 10, 15),
                child: Text(
                  "Sort By:",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color.fromRGBO(64, 64, 64, 1)),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 10, 16),
                child: Container(
                  margin: EdgeInsets.fromLTRB(16, 0, 10, 16),
                  width: 169,
                  height: 39,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(33),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Date",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Color.fromRGBO(64, 64, 64, 1)),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Color.fromRGBO(0, 104, 55, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Color.fromRGBO(64, 64, 64, 1),
            thickness: 1,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: patientProvider.loading
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: const Center(child: Text("")),
                      ),
                    )
                  : patientProvider.patients.isEmpty
                      ? SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: const EmptyListWidget(
                                message: "No patients found"),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          // reverse: true,
                          itemCount: patientProvider.patients.length,
                          itemBuilder: (context, index) {
                            final Patient patient =
                                patientProvider.patients[index];
                            return Visibility(
                              visible: patient.name != "",
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: PatientTile(
                                  patient: patient,
                                  index: index + 1,
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.fromLTRB(32, 20, 10, 16),
        child: Mybutton(
            title: "Register Now",
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PatientFormScreen()));
            }),
      ),
    );
  }
}
