import 'dart:convert';
import 'dart:developer';

import 'package:ayurvedaapp/data/models/branch_model.dart';
import 'package:ayurvedaapp/data/models/treatment_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ApiService {
  final String baseUrl;
  ApiService({this.baseUrl = ApiConstants.baseUrl});

  Future<String?> _getToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('auth_token');
  }

  Future<http.Response> login(
      {required String username, required String password}) async {
    final uri = Uri.parse('${baseUrl}Login');
    var request = http.MultipartRequest('POST', uri)
      ..fields['username'] = username
      ..fields['password'] = password;
    var streamed = await request.send();
    return await http.Response.fromStream(streamed);
  }

  Future<http.Response> getPatientList() async {
    final uri = Uri.parse('${baseUrl}PatientList');
    print(uri.toString());
    final token = await _getToken();
    return await http.get(uri, headers: {
      if (token != null) 'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
  }

  Future<List<Branch>> getBranchList() async {
    final url = Uri.parse("${baseUrl}BranchList");
    final token = await _getToken();
    final response = await http.get(url, headers: {
      if (token != null) 'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);

      log(decoded.toString());
      final List<dynamic> data = decoded["branches"] ?? [];

      return data.map((e) => Branch.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load branches: ${response.statusCode}");
    }
  }

  Future<List<Treatment>> getTreatmentList() async {
    final url = Uri.parse("${baseUrl}TreatmentList");
    final token = await _getToken();
    final response = await http.get(url, headers: {
      if (token != null) 'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      log(decoded.toString());
      final List<dynamic> data = decoded["treatments"] ?? [];
      return data.map((e) => Treatment.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load treatments: ${response.statusCode}");
    }
  }

  Future<http.Response> postPatientUpdate(Map<String, dynamic> fields) async {
    final uri = Uri.parse('${baseUrl}PatientUpdate');
    final token = await _getToken();

    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        if (token != null) 'Authorization': 'Bearer $token',
      });

    fields.forEach((k, v) => request.fields[k] = v);
    final streamed = await request.send();
    return await http.Response.fromStream(streamed);
  }
}
