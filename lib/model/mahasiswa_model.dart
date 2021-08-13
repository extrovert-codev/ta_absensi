import 'dart:convert';

import 'package:ta_absensi/_GlobalScript.dart' as gScript;
import 'package:http/http.dart' as http;

class MahasiswaModel {
  String mid, name;

  MahasiswaModel({this.mid, this.name});

  factory MahasiswaModel.getMahasiswa(Map<String, dynamic> object) {
    return MahasiswaModel(mid: object['mahasiswa_id'], name: object['name']);
  }

  static Future<List<MahasiswaModel>> connectToApi() async {
    String apiURL = gScript.apiURL + '/Mahasiswa';

    var apiResult = await http.get(apiURL, headers: {
      'Authorization': 'Basic ZVh0cm92ZXJ0Q29EZXY6bSFuIW1BUEkyNw==',
      'LICAPI': 'pqvGB1WXVn+WKqbYu7yzfZgfzsz/ESBB0el3o5Bh'
    });
    var jsonObject = jsonDecode(apiResult.body);
    List<dynamic> listData = (jsonObject as Map<String, dynamic>)['data'];

    List<MahasiswaModel> mhs = [];
    for (int i = 0; i < listData.length; i++) {
      mhs.add(MahasiswaModel.getMahasiswa(listData[i]));
    }
    return mhs;
  }
}
