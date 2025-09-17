import 'dart:convert';
import 'dart:developer';
import 'package:ayurvedaapp/data/models/patient_models.dart';
import 'package:flutter/material.dart';
import '../core/network/api_service.dart';

class PatientProvider extends ChangeNotifier {
  final ApiService api;
  bool loading = false;
  List<Patient> patients = [];

  PatientProvider({required this.api});

  Future<void> fetchPatients() async {
  loading = true;
  notifyListeners();

  try {
    final resp = await api.getPatientList();

    if (resp.statusCode == 200) {
      final j = jsonDecode(resp.body);
      final list = (j['patient'] ?? j['patients'] ?? []) as List;
      patients = list.map((e) => Patient.fromJson(e)).toList();
    } else {
      patients = [];
    }
  } catch (e) {
    patients = [];
  } finally {
    loading = false;
    notifyListeners();
  }
}

  Future<bool> submitPatient(Map<String, dynamic> fields) async {
    loading = true;
    notifyListeners();
    final resp = await api.postPatientUpdate(fields);
    loading = false;
    if (resp.statusCode == 200) {
      await fetchPatients();
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }
}
