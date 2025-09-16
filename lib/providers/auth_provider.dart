
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/network/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService api;
  String? token;
  bool loading = false;
  AuthProvider({required this.api});

  Future<bool> login(String username, String password) async {
    loading = true;
    notifyListeners();
    final resp = await api.login(username: username, password: password);
    loading = false;
    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body);
      final t = json['token'] ?? json['Token'] ?? json['data']?['token'];
      if (t != null) {
        token = t.toString();
        final sp = await SharedPreferences.getInstance();
        await sp.setString('auth_token', token!);
        notifyListeners();
        return true;
      }
    }
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove('auth_token');
    token = null;
    notifyListeners();
  }
}
