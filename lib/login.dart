import 'dart:async';
import 'package:ta_absensi/dashboardmhs.dart';
import 'package:ta_absensi/dashboardadm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ta_absensi/model/login_model.dart';
import 'package:ta_absensi/_GlobalScript.dart' as gScript;
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController txtNPM = TextEditingController();
  TextEditingController txtPass = TextEditingController();
  LoginModel loginModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txtNPM.text = '';
    txtPass.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Theme(
        data: ThemeData(hintColor: Colors.white),
        child: Container(
          color: Color.fromARGB(255, 15, 193, 167),
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('abs',
                        style: TextStyle(fontSize: 40, color: Colors.white)),
                    Icon(Icons.fingerprint, size: 50, color: Colors.white),
                    Text('nsiQ',
                        style: TextStyle(fontSize: 40, color: Colors.white)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: txtNPM,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(30)),
                      hintText: 'NPM'),
                  onSubmitted: (value) {
                    setState(() {
                      txtNPM.text = value;
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextField(
                  controller: txtPass,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(30)),
                      hintText: 'Password'),
                  obscureText: true,
                  onSubmitted: (value) {
                    setState(() {
                      txtPass.text = value;
                    });
                  },
                ),
              ),
              GestureDetector(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Color.fromARGB(255, 15, 193, 167),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (txtNPM.text == '' || txtPass.text == '') {
                    Alert(
                        context: context,
                        title: 'Harap isi data dengan benar',
                        type: AlertType.error,
                        buttons: [
                          DialogButton(
                              color: Color.fromARGB(255, 15, 193, 167),
                              child: Text('OK',
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () => Get.back())
                        ]).show();
                  } else {
                    showProgressDialog(
                      context: context,
                      loadingText: ' Loading...',
                      orientation: ProgressOrientation.horizontal,
                    );

                    Future.delayed(Duration(seconds: 3)).then((value) {
                      LoginModel.connectToApi(txtNPM.text).then((value) {
                        setState(() {
                          loginModel = value;
                          if (loginModel != null) {
                            if (loginModel.pass == txtPass.text) {
                              gScript.mid = loginModel.mid;
                              gScript.npm = loginModel.npm;
                              gScript.name = loginModel.name;
                              (loginModel.isAdmin == '1')
                                  ? Get.off(DashboardAdm())
                                  : Get.off(DashboardMhs());
                            } else {
                              Alert(
                                  context: context,
                                  title: 'NPM atau password tidak terdaftar',
                                  type: AlertType.error,
                                  buttons: [
                                    DialogButton(
                                        color:
                                            Color.fromARGB(255, 15, 193, 167),
                                        child: Text('OK',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        onPressed: () => Get.back())
                                  ]).show();
                              setState(() {
                                txtPass.text = '';
                              });
                            }
                          } else {
                            Alert(
                                context: context,
                                title: 'NPM atau password tidak terdaftar',
                                type: AlertType.error,
                                buttons: [
                                  DialogButton(
                                      color: Color.fromARGB(255, 15, 193, 167),
                                      child: Text('OK',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      onPressed: () => Get.back())
                                ]).show();
                            setState(() {
                              txtPass.text = '';
                            });
                          }
                        });
                      });
                      dismissProgressDialog();
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
