import 'dart:convert';
import 'dart:io';
import 'package:ayurvedaapp/data/models/treatment_model.dart';
import 'package:ayurvedaapp/data/models/treatment_selection.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class PdfService {
  Future<String> createPatientPdf(Map<String, dynamic> fields) async {
    final pdf = pw.Document();

    final now = DateTime.now();
    final bookedOn = DateFormat("dd/MM/yyyy hh:mma").format(now);

    final logo = await imageFromAssetBundle('assets/assetbig.png');

    final treatmentsRaw = fields["treatments"];
    List<Map<String, dynamic>> treatments = [];

    if (treatmentsRaw is List) {
      treatments = treatmentsRaw.cast<Map<String, dynamic>>();
    } else if (treatmentsRaw is String) {
      try {
        final decoded = jsonDecode(treatmentsRaw);
        if (decoded is List) {
          treatments = decoded.cast<Map<String, dynamic>>();
        }
      } catch (e) {
        treatments = [];
      }
    }

    DateTime? treatmentDateTime;
    try {
      treatmentDateTime = DateTime.tryParse(fields["date_nd_time"] ?? "");
    } catch (_) {}
    final treatmentDate = treatmentDateTime != null
        ? DateFormat("dd/MM/yyyy").format(treatmentDateTime)
        : "-";
    final treatmentTime = treatmentDateTime != null
        ? DateFormat("hh:mma").format(treatmentDateTime)
        : "-";

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(logo, width: 80),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text("KUMARAKOM",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                      "Cheepunkal P.O. Kumarakom, Kottayam, Kerala - 686563",
                      style: const pw.TextStyle(fontSize: 10)),
                  pw.Text("e-mail: unknown@gmail.com",
                      style: const pw.TextStyle(fontSize: 10)),
                  pw.Text("Mob: +91 9876543210 | +91 9786543210",
                      style: const pw.TextStyle(fontSize: 10)),
                  pw.Text("GST No: 32AABCU9603R1ZW",
                      style: const pw.TextStyle(fontSize: 10)),
                ],
              )
            ],
          ),
          pw.SizedBox(height: 20),

          pw.Container(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text("Patient Details",
                style: pw.TextStyle(
                  fontSize: 14,
                  color: PdfColors.green,
                  fontWeight: pw.FontWeight.bold,
                )),
          ),
          pw.SizedBox(height: 10),

          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _detailRow("Name", fields["name"]),
                    _detailRow("Address", fields["address"]),
                    _detailRow("WhatsApp Number", fields["phone"]),
                  ]),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _detailRow("Booked On", bookedOn),
                    _detailRow("Treatment Date", treatmentDate),
                    _detailRow("Treatment Time", treatmentTime),
                  ]),
            ],
          ),
          pw.SizedBox(height: 20),

          if (treatments.isNotEmpty)
            pw.Table.fromTextArray(
              headers: ["Treatment", "Price", "Male", "Female", "Total"],
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey200),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 12,
              ),
              cellStyle: const pw.TextStyle(fontSize: 11),
              headerAlignment: pw.Alignment.center,
              cellAlignment: pw.Alignment.center,
              cellDecoration: (index, data, rowNum) {
                return pw.BoxDecoration(border: pw.Border.all(width: 0));
              },
              data: treatments.map((t) {
                return [
                  t["name"] ?? "",
                  "₹${t["price"] ?? 0}",
                  (t["male"] ?? 0).toString(),
                  (t["female"] ?? 0).toString(),
                  "₹${t["total"] ?? 0}",
                ];
              }).toList(),
            ),
          pw.SizedBox(height: 20),

          // Totals
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                _amountRow("Total Amount", fields["total_amount"], bold: true),
                _amountRow("Discount", fields["discount_amount"]),
                _amountRow("Advance", fields["advance_amount"]),
                _amountRow("Balance", fields["balance_amount"], bold: true),
              ],
            ),
          ),
          pw.SizedBox(height: 30),

          pw.Center(
            child: pw.Text("Thank you for choosing us",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green,
                )),
          ),
          pw.Center(
            child: pw.Text(
              "Your well-being is our commitment, and we're honored you've entrusted us with your health journey",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
          ),
          pw.SizedBox(height: 40),

          pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text("Signature",
                  style: const pw.TextStyle(fontSize: 12))),

          pw.SizedBox(height: 30),
          pw.Divider(),

          // Bottom note
          pw.Text(
            "Booking amount is non-refundable, and it's important to arrive on the allotted time for your treatment",
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File(
        "${dir.path}/patient_${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  Future<void> previewPdf(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await Printing.layoutPdf(onLayout: (_) => file.readAsBytesSync());
    }
  }

  // --- Helpers ---
  pw.Widget _detailRow(String label, String? value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        children: [
          pw.Text("$label: ",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
          pw.Text(value ?? "", style: const pw.TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  pw.Widget _amountRow(String label, String? value, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight:
                      bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
          pw.SizedBox(width: 40),
          pw.Text("₹${value ?? "0"}",
              style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight:
                      bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        ],
      ),
    );
  }
}
