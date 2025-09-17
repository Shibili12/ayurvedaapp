import 'package:ayurvedaapp/data/models/branch_model.dart';
import 'package:ayurvedaapp/data/models/treatment_selection.dart';
import 'package:ayurvedaapp/providers/branch_provider.dart';
import 'package:ayurvedaapp/providers/treatment_provider.dart';
import 'package:ayurvedaapp/services/pdf_service.dart';
import 'package:ayurvedaapp/ui/widgets/count_button.dart';
import 'package:ayurvedaapp/ui/widgets/myButton.dart';
import 'package:ayurvedaapp/ui/widgets/mytextfield.dart';
import 'package:ayurvedaapp/ui/widgets/treatment_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/patient_provider.dart';

class PatientFormScreen extends StatefulWidget {
  const PatientFormScreen({super.key});

  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _execController = TextEditingController();
  final _paymentController = TextEditingController();

  final _totalController = TextEditingController();
  final _discountController = TextEditingController();
  final _advanceController = TextEditingController();
  final _balanceController = TextEditingController();

  String? _selectedBranch;
  String? _selectedLocation;
  List<String> _selectedTreatments = [];

  final List<String> _locations = ["Location A", "Location B", "Location C"];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _execController.dispose();
    _paymentController.dispose();
    _totalController.dispose();
    _discountController.dispose();
    _advanceController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _calculateBalance() {
    final total = double.tryParse(_totalController.text) ?? 0;
    final discount = double.tryParse(_discountController.text) ?? 0;
    final advance = double.tryParse(_advanceController.text) ?? 0;
    final balance = total - (discount + advance);
    _balanceController.text = balance.toStringAsFixed(2);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final patientProvider =
        Provider.of<PatientProvider>(context, listen: false);
    final treatmentProvider =
        Provider.of<TreatmentProvider>(context, listen: false);

    final branchId = _selectedBranch ?? "";

    final body = {
      "name": _nameController.text,
      "excecutive": "",
      "payment": _paymentController.text,
      "phone": _phoneController.text,
      "address": _addressController.text,
      "total_amount": _totalController.text,
      "discount_amount": _discountController.text,
      "advance_amount": _advanceController.text,
      "balance_amount": _balanceController.text,
      "date_nd_time": DateTime.now().toString(),
      "id": "",
      "male": treatmentProvider.maleIds,
      "female": treatmentProvider.femaleIds,
      "treatments": treatmentProvider.toApiPayload()["treatments"],
      "branch": branchId,
    };

    final success = await patientProvider.submitPatient(body);

    if (success && mounted) {
      final pdfService = PdfService();
      final filePath = await pdfService.createPatientPdf(body);
      await pdfService.previewPdf(filePath);

      if (mounted) Navigator.pop(context); // go back after success
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to register patient")),
        );
      }
    }
  }

  @override
  void initState() {
    Future.microtask(() =>
        Provider.of<BranchProvider>(context, listen: false).fetchBranches());
    // Future.microtask(() =>
    //     Provider.of<TreatmentProvider>(context, listen: false)
    //         .fetchTreatments());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context);
    final branchProvider = Provider.of<BranchProvider>(context);
    final treatmentProvider = Provider.of<TreatmentProvider>(context);
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
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Text(
                  "Register",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Color.fromRGBO(64, 64, 64, 1)),
                ),
              ),
              Divider(
                color: Color.fromRGBO(64, 64, 64, 1),
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
                child: Text("Name",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color.fromRGBO(64, 64, 64, 1))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
                child: MyTextfieldWidget(
                  controller: _nameController,
                  hint: "Enter your Fullname",
                  onpressed: () {},
                  validator: (val) {
                    return val == null || val.isEmpty
                        ? "Enter your Fullname"
                        : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
                child: Text("Whatsapp Number",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color.fromRGBO(64, 64, 64, 1))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
                child: MyTextfieldWidget(
                  controller: _phoneController,
                  hint: "Enter your Whatsapp Number",
                  onpressed: () {},
                  validator: (val) {
                    return val == null || val.isEmpty
                        ? "Enter your Whatsapp Number"
                        : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
                child: Text("Address",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color.fromRGBO(64, 64, 64, 1))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
                child: MyTextfieldWidget(
                  controller: _addressController,
                  hint: "Enter your Full Address",
                  onpressed: () {},
                  validator: (val) {
                    return val == null || val.isEmpty
                        ? "Enter your Full Address"
                        : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
                child: Text("Location",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color.fromRGBO(64, 64, 64, 1))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
                child: DropdownButtonFormField<String>(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Color.fromRGBO(0, 104, 55, 1),
                  ),
                  value: _selectedLocation,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(217, 217, 217, .25),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, .1))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, .1))),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, .1))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, .1))),
                    hintText: "Location",
                    hintStyle: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                  items: _locations
                      .map((loc) =>
                          DropdownMenuItem(value: loc, child: Text(loc)))
                      .toList(),
                  onChanged: (val) {
                    setState(() => _selectedLocation = val);
                  },
                  validator: (val) => val == null ? "Select a branch" : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
                child: Text("Branch",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color.fromRGBO(64, 64, 64, 1))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
                child: DropdownButtonFormField<String>(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Color.fromRGBO(0, 104, 55, 1),
                  ),
                  value: branchProvider.branches
                          .any((b) => b.id == _selectedBranch)
                      ? _selectedBranch
                      : null,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(217, 217, 217, .25),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, .1))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, .1))),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, .1))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 0, 0, .1))),
                    hintText: "Branch",
                    hintStyle: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                  items: branchProvider.branches.map((b) {
                    return DropdownMenuItem(
                      value: b.id,
                      child: Text(b.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBranch = value;
                    });
                  },
                  validator: (val) => val == null ? "Select a branch" : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
                child: Text("Treatments",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color.fromRGBO(64, 64, 64, 1))),
              ),
              ...treatmentProvider.selectedTreatments
                  .asMap()
                  .entries
                  .map((entry) {
                final idx = entry.key;
                final item = entry.value;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: TreatmentTile(
                    index: (idx + 1).toString(),
                    title: item.treatmentName,
                    femalecount: item.femaleCount.toString(),
                    malecount: item.maleCount.toString(),
                    onTap: () {
                      treatmentProvider.removeTreatment(idx);
                    },
                  ),
                );
              }).toList(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
                child: GestureDetector(
                  onTap: () async {
                    final provider = context.read<TreatmentProvider>();
                    await provider.fetchTreatments(); // fetch before opening
                    if (!mounted) return;
                    _showAddTreatmentBottomSheet(context);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: Color.fromRGBO(56, 154, 72, .3),
                    ),
                    child: Center(
                      child: Text(
                        " + Add treatment",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
                child: Text("Total Amount",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color.fromRGBO(64, 64, 64, 1))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
                child: MyTextfieldWidget(
                  controller: _totalController,
                  hint: "Enter your Total Amount",
                  onpressed: () {},
                  validator: (val) {
                    return val == null || val.isEmpty
                        ? "Enter your Total Amount"
                        : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
                child: Text("Discount",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color.fromRGBO(64, 64, 64, 1))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
                child: MyTextfieldWidget(
                  controller: _discountController,
                  hint: "Enter your Discount",
                  onpressed: () {},
                  validator: (val) {
                    return val == null || val.isEmpty
                        ? "Enter your Discount"
                        : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
                child: Text("Payment Option",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color.fromRGBO(64, 64, 64, 1))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(value: "Cash", groupValue: "op", onChanged: (v) {}),
                      Text("Cash",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color.fromRGBO(64, 64, 64, 1))),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(value: "Card", groupValue: "op", onChanged: (v) {}),
                      Text("card",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color.fromRGBO(64, 64, 64, 1))),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(value: "UPI", groupValue: "op", onChanged: (v) {}),
                      Text("UPI",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color.fromRGBO(64, 64, 64, 1))),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
                child: Text("Advance Amount",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color.fromRGBO(64, 64, 64, 1))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
                child: MyTextfieldWidget(
                  controller: _advanceController,
                  hint: "Enter your Advance Amount",
                  onpressed: () {},
                  validator: (val) {
                    return val == null || val.isEmpty
                        ? "Enter your Advance Amount"
                        : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
                child: Text("Balance",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color.fromRGBO(64, 64, 64, 1))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
                child: MyTextfieldWidget(
                  controller: _balanceController,
                  hint: "Enter your Balance",
                  onpressed: () {},
                  validator: (val) {
                    return val == null || val.isEmpty
                        ? "Enter your Balance"
                        : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 25, 16, 8),
                child: Mybutton(
                    title: patientProvider.loading ? "......" : "Register",
                    onTap: patientProvider.loading ? null : _submitForm),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTreatmentBottomSheet(BuildContext context) {
    final treatmentProvider =
        Provider.of<TreatmentProvider>(context, listen: false);
    final treatments = treatmentProvider.treatments;

    String? selectedTreatmentId;
    int maleCount = 0;
    int femaleCount = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
                    child: Text("Choose Treatments",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color.fromRGBO(64, 64, 64, 1))),
                  ),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    alignment: Alignment.centerLeft,
                    style: TextStyle(fontSize: 12, color: Colors.black),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Color.fromRGBO(0, 104, 55, 1),
                    ),
                    iconSize: 15,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(217, 217, 217, .25),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 0, 0, .1))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 0, 0, .1))),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 0, 0, .1))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 0, 0, .1))),
                      hintText: "Choose Treatment",
                      hintStyle: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w300),
                    ),
                    items: treatments.map((t) {
                      return DropdownMenuItem(
                        value: t.id,
                        child: Text(
                          t.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() => selectedTreatmentId = val);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
                    child: Text("Add patients",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color.fromRGBO(64, 64, 64, 1))),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 124,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(217, 217, 217, .25),
                          border:
                              Border.all(color: Color.fromRGBO(0, 0, 0, .25)),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Center(
                          child: Text("Male",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(0, 0, 0, 1))),
                        ),
                      ),
                      Row(
                        children: [
                          CountButton(
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                            onTap: () {
                              if (maleCount > 0) {
                                setState(() => maleCount--);
                              }
                            },
                          ),
                          Container(
                            width: 48,
                            height: 44,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromRGBO(0, 0, 0, .25)),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Center(
                              child: Text(maleCount.toString(),
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(0, 0, 0, 1))),
                            ),
                          ),
                          CountButton(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            onTap: () {
                              setState(() => maleCount++);
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 124,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(217, 217, 217, .25),
                          border:
                              Border.all(color: Color.fromRGBO(0, 0, 0, .25)),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Center(
                          child: Text("Female",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(0, 0, 0, 1))),
                        ),
                      ),
                      Row(
                        children: [
                          CountButton(
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                            onTap: () {
                              if (femaleCount > 0) {
                                setState(() => femaleCount--);
                              }
                            },
                          ),
                          Container(
                            width: 48,
                            height: 44,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromRGBO(0, 0, 0, .25)),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Center(
                              child: Text(femaleCount.toString(),
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(0, 0, 0, 1))),
                            ),
                          ),
                          CountButton(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            onTap: () {
                              setState(() => femaleCount++);
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                    child: Mybutton(
                        title: "Save",
                        onTap: () {
                          if (selectedTreatmentId != null) {
                            final treatment = treatments
                                .firstWhere((t) => t.id == selectedTreatmentId);
                            treatmentProvider.addTreatment(
                              TreatmentSelection(
                                treatmentId: treatment.id,
                                treatmentName: treatment.name,
                                maleCount: maleCount,
                                femaleCount: femaleCount,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        }),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
