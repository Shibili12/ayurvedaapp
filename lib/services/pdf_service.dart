import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class PdfService {
  /// Generate patient PDF
  Future<String> createPatientPdf(Map<String, dynamic> fields) async {
    final pdf = pw.Document();

    // Treatment table rows
    final treatments = (fields["treatmentsList"] ?? []) as List<Map<String, dynamic>>;

    final now = DateTime.now();
    final formattedNow = DateFormat("dd/MM/yyyy hh:mm a").format(now);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Header
          pw.Center(
            child: pw.Text(
              "Amritha Ayurveda",
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Center(
            child: pw.Text("Panchakarma / Treatments",
                style: pw.TextStyle(fontSize: 14)),
          ),
          pw.SizedBox(height: 20),

          // Patient details
          pw.Text("Patient Details",
              style: pw.TextStyle(
                  fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text("Name: ${fields["name"] ?? ""}"),
          pw.Text("Address: ${fields["address"] ?? ""}"),
          pw.Text("WhatsApp Number: ${fields["phone"] ?? ""}"),
          pw.Text("Treatment Date: ${fields["date"] ?? DateFormat("dd/MM/yyyy").format(now)}"),
          pw.Text("Treatment Time: ${fields["time"] ?? DateFormat("hh:mm a").format(now)}"),
          pw.SizedBox(height: 16),

          // Treatments Table
          pw.Table.fromTextArray(
            headers: ["Treatment", "Price", "Male", "Female", "Total"],
            cellAlignment: pw.Alignment.center,
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
            ),
            data: treatments.map((t) {
              return [
                t["name"],
                "₹${t["price"]}",
                t["maleCount"].toString(),
                t["femaleCount"].toString(),
                "₹${t["total"]}",
              ];
            }).toList(),
          ),
          pw.SizedBox(height: 20),

          // Amount summary
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text("Advance: ₹${fields["advance_amount"] ?? "0"}"),
                pw.Text("Balance: ₹${fields["balance_amount"] ?? "0"}"),
                pw.Text("Discount: ₹${fields["discount_amount"] ?? "0"}"),
                pw.Text(
                  "Total Amount: ₹${fields["total_amount"] ?? "0"}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 30),

          // Footer
          pw.Text(
            "Thank you for choosing us\nYour well-being is our commitment.",
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 20),
          pw.Text("KUMARAKOM", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text("Cheepunkal P.O. Kumarakom, Kottayam, Kerala - 686563"),
          pw.Text("e-mail: unknown@gmail.com"),
          pw.Text("Mob: +91 9876543210 | +91 9786543210"),
          pw.SizedBox(height: 8),
          pw.Text("Booked On $formattedNow"),
          pw.SizedBox(height: 4),
          pw.Text(
            "“Booking amount is non-refundable, and it's important to arrive on time for your treatment”",
            style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
          ),
          pw.SizedBox(height: 4),
          pw.Text("GST No: 32AABCU9603R1ZW"),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/patient_${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  /// Preview the PDF
  Future<void> previewPdf(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await Printing.layoutPdf(onLayout: (_) => file.readAsBytesSync());
    }
  }
}
