class Patient {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String payment;
  final String totalAmount;
  final String discountAmount;
  final String advanceAmount;
  final String balanceAmount;
  final DateTime dateTime;
  final List<PatientDetail> details;

  Patient({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.payment,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.dateTime,
    required this.details,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    final detailsJson = json['patientdetails_set'] as List<dynamic>? ?? [];

    return Patient(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      payment: json['payment'] ?? '',
      totalAmount: json['total_amount']?.toString() ?? '0',
      discountAmount: json['discount_amount']?.toString() ?? '0',
      advanceAmount: json['advance_amount']?.toString() ?? '0',
      balanceAmount: json['balance_amount']?.toString() ?? '0',
      dateTime: DateTime.tryParse(json['date_nd_time'] ?? '') ?? DateTime.now(),
      details: detailsJson
          .map((e) => PatientDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PatientDetail {
  final String id;
  final String male;
  final String female;
  final String treatmentId;
  final String treatmentName;

  PatientDetail({
    required this.id,
    required this.male,
    required this.female,
    required this.treatmentId,
    required this.treatmentName,
  });

  factory PatientDetail.fromJson(Map<String, dynamic> json) {
    return PatientDetail(
      id: json['id']?.toString() ?? '',
      male: json['male'] ?? "0",
      female: json['female'] ?? "0",
      treatmentId: json['treatment']?.toString() ?? '',
      treatmentName: json['treatment_name'] ?? '',
    );
  }
}
