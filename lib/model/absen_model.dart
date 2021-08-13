import 'dart:convert';

import 'package:ta_absensi/_GlobalScript.dart' as gScript;
import 'package:http/http.dart' as http;

class AbsenModel {
  String mid, date, time;

  AbsenModel({this.mid, this.date, this.time});

  factory AbsenModel.postAbsen(Map<String, dynamic> object) {
    return AbsenModel(
        mid: object['mid'], date: object['date'], time: object['time']);
  }

  static Future<AbsenModel> connectToApi(
      String mid, String date, String time) async {
    String apiURL = gScript.apiURL + '/Absen';

    var apiResult = await http.post(apiURL, body: {
      'mid': mid,
      'date': date,
      'time': time
    }, headers: {
      'Authorization': 'Basic ZVh0cm92ZXJ0Q29EZXY6bSFuIW1BUEkyNw==',
      'LICAPI': 'pqvGB1WXVn+WKqbYu7yzfZgfzsz/ESBB0el3o5Bh'
    });
    var jsonObject = jsonDecode(apiResult.body);

    return AbsenModel.postAbsen(jsonObject);
  }
}
