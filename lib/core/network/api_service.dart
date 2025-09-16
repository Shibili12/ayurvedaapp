
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

  Future<http.Response> login({required String username, required String password}) async {
    final uri = Uri.parse('${baseUrl}Login');
    var request = http.MultipartRequest('POST', uri)
      ..fields['username'] = username
      ..fields['password'] = password;
    var streamed = await request.send();
    return await http.Response.fromStream(streamed);
  }

  
}
