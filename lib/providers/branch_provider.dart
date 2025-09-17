import 'dart:developer';

import 'package:ayurvedaapp/core/network/api_service.dart';
import 'package:flutter/material.dart';
import '../data/models/branch_model.dart';

class BranchProvider with ChangeNotifier {
  final ApiService api;
  BranchProvider({required this.api});

  List<Branch> _branches = [];
  bool _loading = false;

  List<Branch> get branches => _branches;
  bool get loading => _loading;

  Future<void> fetchBranches() async {
    _loading = true;
    notifyListeners();
    try {
      _branches = await api.getBranchList();
      log(branches.toString());
    } catch (e) {
      log("Error fetching branches: $e");
      _branches = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
