import 'dart:convert';
import 'package:ta_absensi/_GlobalScript.dart' as gScript;
import 'package:http/http.dart' as http;

class LoginModel {
  String mid, npm, name, pass, isAdmin;

  LoginModel({this.mid, this.npm, this.name, this.pass, this.isAdmin});

  factory LoginModel.getMahasiswa(Map<String, dynamic> object) {
    return LoginModel(
        mid: object['mahasiswa_id'],
        npm: object['npm'],
        name: object['name'],
        pass: object['password'],
        isAdmin: object['isadmin']);
  }

  static Future<LoginModel> connectToApi(String npm) async {
    String apiURL = gScript.apiURL + '/Login?npm=' + npm;

    var apiResult = await http.get(apiURL, headers: {
      'Authorization': 'Basic ZVh0cm92ZXJ0Q29EZXY6bSFuIW1BUEkyNw==',
      'LICAPI': 'pqvGB1WXVn+WKqbYu7yzfZgfzsz/ESBB0el3o5Bh'
    });
    var apiResponse = apiResult.statusCode;
    if (apiResponse != 404) {
      var jsonObject = jsonDecode(apiResult.body);
      var userData = (jsonObject as Map<String, dynamic>)['data'];
      return LoginModel.getMahasiswa(userData[0]);
    }
    return null;
  }
}
