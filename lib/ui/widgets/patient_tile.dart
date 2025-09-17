// lib/ui/widgets/patient_tile.dart
import 'package:ayurvedaapp/data/models/patient_models.dart';
import 'package:flutter/material.dart';

class PatientTile extends StatelessWidget {
  final Patient patient;
  const PatientTile({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(patient.name.isNotEmpty ? patient.name[0] : "?"),
        ),
        title: Text(patient.name),
        subtitle: Text("Phone: ${patient.phone}"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Navigate to patient detail or edit screen
        },
      ),
    );
  }
}
