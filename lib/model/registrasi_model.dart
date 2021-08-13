import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ta_absensi/_GlobalScript.dart' as gScript;

class RegistrasiModel {
  String npm, name, dob, isAdmin;

  RegistrasiModel({this.npm, this.name, this.dob, this.isAdmin});

  factory RegistrasiModel.postMahasiswa(Map<String, dynamic> object) {
    return RegistrasiModel(
      npm: object['npm'],
      name: object['name'],
      dob: object['dob'],
      isAdmin: object['isadmin'],
    );
  }

  static Future<RegistrasiModel> connectToAPI(
      String npm, String name, String dob, String isAdmin) async {
    String apiURL = gScript.apiURL + '/Registrasi';

    var apiResult = await http.post(apiURL, body: {
      'npm': npm,
      'name': name,
      'dob': dob,
      'isadmin': isAdmin,
    }, headers: {
      'Authorization': 'Basic ZVh0cm92ZXJ0Q29EZXY6bSFuIW1BUEkyNw==',
      'LICAPI': 'pqvGB1WXVn+WKqbYu7yzfZgfzsz/ESBB0el3o5Bh'
    });
    var jsonObject = jsonDecode(apiResult.body);

    return RegistrasiModel.postMahasiswa(jsonObject);
  }
}
