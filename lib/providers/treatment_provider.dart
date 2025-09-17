// lib/providers/treatment_provider.dart
import 'dart:developer';

import 'package:ayurvedaapp/core/network/api_service.dart';
import 'package:flutter/material.dart';
import '../data/models/treatment_model.dart';
import '../data/models/treatment_selection.dart';

class TreatmentProvider with ChangeNotifier {
  final ApiService api;
  TreatmentProvider({required this.api});

  // API treatments
  List<Treatment> _treatments = [];
  bool _loading = false;

  // User-selected treatments with male/female counts
  final List<TreatmentSelection> _selectedTreatments = [];

  List<Treatment> get treatments => _treatments;
  bool get loading => _loading;

  List<TreatmentSelection> get selectedTreatments => _selectedTreatments;

  /// Fetch treatment list from API
  Future<void> fetchTreatments() async {
    _loading = true;
    notifyListeners();
    try {
      _treatments = await api.getTreatmentList();
    } catch (e) {
      log("Error fetching treatments: $e");
      _treatments = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void addTreatment(TreatmentSelection selection) {
  final index = _selectedTreatments.indexWhere(
    (t) => t.treatmentId == selection.treatmentId,
  );
  if (index == -1) {
    _selectedTreatments.add(selection);
  } else {
    // Update counts
    _selectedTreatments[index] = _selectedTreatments[index].copyWith(
      maleCount: _selectedTreatments[index].maleCount + selection.maleCount,
      femaleCount: _selectedTreatments[index].femaleCount + selection.femaleCount,
    );
  }
  notifyListeners();
}

  /// Remove treatment from list
  void removeTreatment(int index) {
    if (index >= 0 && index < _selectedTreatments.length) {
      _selectedTreatments.removeAt(index);
      notifyListeners();
    }
  }

  /// Reset all selections (useful after form submission)
  void clearSelections() {
    _selectedTreatments.clear();
    notifyListeners();
  }
  String get maleIds => _selectedTreatments
    .where((t) => t.maleCount > 0)
    .map((t) => t.treatmentId)
    .join(",");

String get femaleIds => _selectedTreatments
    .where((t) => t.femaleCount > 0)
    .map((t) => t.treatmentId)
    .join(",");

  /// Prepare API payload (example structure)
  Map<String, dynamic> toApiPayload() {
    final maleIds = <String>[];
    final femaleIds = <String>[];

    for (var t in _selectedTreatments) {
      if (t.maleCount > 0) maleIds.add(t.treatmentId);
      if (t.femaleCount > 0) femaleIds.add(t.treatmentId);
    }

    return {
      "male": maleIds.join(","),
      "female": femaleIds.join(","),
      "treatments": [...maleIds, ...femaleIds].join(","),
    };
  }
}
