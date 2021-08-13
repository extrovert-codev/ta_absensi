import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ta_absensi/absenmahasiswa.dart';
import 'package:ta_absensi/absenpersonal.dart';
import 'package:ta_absensi/login.dart';
import 'package:ta_absensi/model/absen_model.dart';
import 'package:ta_absensi/registrasimhs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:get/get.dart';
import 'package:ta_absensi/_GlobalScript.dart' as gScript;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';

class DashboardAdm extends StatefulWidget {
  @override
  _DashboardAdmState createState() => _DashboardAdmState();
}

class _DashboardAdmState extends State<DashboardAdm> {
  String dy, time, dt, outputScanner;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTime();
    refreshData();
  }

  void setTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        dy = DateFormat('EEEE').format(DateTime.now());
        time = DateFormat('HH:mm').format(DateTime.now());
        dt = DateFormat('dd MMM yyyy').format(DateTime.now());
      });
    });
  }

  Future refreshData() async {
    setState(() {
      dy = DateFormat('EEEE').format(DateTime.now());
      time = DateFormat('HH:mm').format(DateTime.now());
      dt = DateFormat('dd MMM yyyy').format(DateTime.now());
      outputScanner = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Home', style: TextStyle(fontSize: 17)),
          actions: [
            GestureDetector(
              child: Container(
                  width: 40, child: Icon(Icons.more_vert, color: Colors.white)),
              onTap: () {
                Get.offAll(Login());
              },
            ),
          ],
          backgroundColor: Color.fromARGB(255, 15, 193, 167),
          elevation: 0),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  // Header
                  Container(
                    color: Color.fromARGB(255, 15, 193, 167),
                    height: 175,
                    padding: EdgeInsets.only(top: 25),
                    child: Column(
                      children: [
                        Text(dy,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Text(time,
                            style:
                                TextStyle(color: Colors.white, fontSize: 50)),
                        Text(dt, style: TextStyle(color: Colors.white)),
                        Container(
                          margin: EdgeInsets.only(top: 40),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                      child: Center(
                                          child: Text(gScript.npm,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white))))),
                              Text('|', style: TextStyle(color: Colors.white)),
                              Expanded(
                                  child: Container(
                                      child: Center(
                                          child: Text(gScript.name,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white))))),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // Header

                  // Body
                  Column(
                    children: [
                      Container(
                          color: Colors.teal[50],
                          height: 40,
                          padding: EdgeInsets.only(left: 10),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Menu',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)))),
                      Container(
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: FlatButton(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.fingerprint,
                                          size: 40, color: Colors.blue),
                                      Text('ABSEN')
                                    ],
                                  ),
                                  onPressed: () async {
                                    Map<Permission, PermissionStatus> statuses =
                                        await [
                                      Permission.camera,
                                      Permission.storage
                                    ].request();

                                    if (statuses[Permission.camera].isGranted &&
                                        statuses[Permission.storage]
                                            .isGranted) {
                                      await _absen();
                                    }
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: FlatButton(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person_outline,
                                          size: 40, color: Colors.orange),
                                      Text('REGISTRASI'),
                                      Text('MAHASISWA')
                                    ],
                                  ),
                                  onPressed: () {
                                    Get.to(RegistrasiMhs());
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: FlatButton(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.history,
                                          size: 40, color: Colors.teal[300]),
                                      Text('ABSENKU')
                                    ],
                                  ),
                                  onPressed: () {
                                    Get.to(AbsenPersonal());
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: FlatButton(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.calendar_today,
                                          size: 40, color: Colors.redAccent),
                                      Text('ABSEN'),
                                      Text('MAHASISWA')
                                    ],
                                  ),
                                  onPressed: () {
                                    Get.to(AbsenMahasiswa());
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Body
                ],
              ),
            ),
            // Footer
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              height: 130,
              child: Center(
                  child: GestureDetector(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color.fromARGB(255, 15, 193, 167)),
                  child: Center(
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white),
                      child: Center(
                          child: Icon(Icons.fingerprint,
                              color: Color.fromARGB(255, 15, 193, 167),
                              size: 40)),
                    ),
                  ),
                ),
                onTap: () async {
                  Map<Permission, PermissionStatus> statuses =
                      await [Permission.camera, Permission.storage].request();

                  if (statuses[Permission.camera].isGranted &&
                      statuses[Permission.storage].isGranted) {
                    await _absen();
                  }
                },
              )),
            )
            // Footer
          ],
        ),
      ),
    );
  }

  Future _absen() async {
    var bytes = utf8.encode(gScript.hash);
    var hashed = sha224.convert(bytes);

    outputScanner = await scanner.scan();
    showProgressDialog(context: context, loadingText: ' Loading...');

    Future.delayed(Duration(seconds: 3)).then((value) {
      if (hashed.toString() == outputScanner) {
        AbsenModel.connectToApi(
            gScript.mid, DateFormat('yyyy-MM-dd').format(DateTime.now()), time);
        Alert(
            context: context,
            title: 'Absen berhasil',
            type: AlertType.success,
            buttons: [
              DialogButton(
                  color: Color.fromARGB(255, 15, 193, 167),
                  child: Text('OK', style: TextStyle(color: Colors.white)),
                  onPressed: () => Get.back())
            ]);
        Get.back();
      } else {
        Alert(
            context: context,
            title: 'Absen gagal',
            type: AlertType.error,
            buttons: [
              DialogButton(
                  color: Color.fromARGB(255, 15, 193, 167),
                  child: Text('OK', style: TextStyle(color: Colors.white)),
                  onPressed: () => Get.back())
            ]);
      }
      dismissProgressDialog();
    });

    setState(() {
      refreshData();
    });
  }
}
