import 'dart:convert';
import 'package:ta_absensi/_GlobalScript.dart' as gScript;
import 'package:http/http.dart' as http;

class AbsenPersonalModel {
  String timeIn, timeOut;

  AbsenPersonalModel({this.timeIn, this.timeOut});

  factory AbsenPersonalModel.getAbsen(Map<String, dynamic> object) {
    return AbsenPersonalModel(
        timeIn: object['timein'], timeOut: object['timeout']);
  }

  static Future<AbsenPersonalModel> connectToApi(
      String mid, String date) async {
    String apiURL =
        gScript.apiURL + '/AbsenPersonal?mid=' + mid + '&dt=' + date;

    var apiResult = await http.get(apiURL, headers: {
      'Authorization': 'Basic ZVh0cm92ZXJ0Q29EZXY6bSFuIW1BUEkyNw==',
      'LICAPI': 'pqvGB1WXVn+WKqbYu7yzfZgfzsz/ESBB0el3o5Bh'
    });
    var apiResponse = apiResult.statusCode;
    if (apiResponse != 404) {
      var jsonObject = jsonDecode(apiResult.body);
      var userData = (jsonObject as Map<String, dynamic>)['data'];
      return AbsenPersonalModel.getAbsen(userData[0]);
    }
    return null;
  }
}
