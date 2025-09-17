
class Patient {
  final String id;
  final String name;
  final String phone;


  Patient({required this.id, required this.name, required this.phone});

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
