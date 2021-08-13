import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:ta_absensi/dashboardadm.dart';
import 'package:ta_absensi/model/login_model.dart';
import 'package:ta_absensi/model/registrasi_model.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
import 'package:get/get.dart';

class RegistrasiMhs extends StatefulWidget {
  @override
  _RegistrasiMhsState createState() => _RegistrasiMhsState();
}

class _RegistrasiMhsState extends State<RegistrasiMhs> {
  TextEditingController txtNPM = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtDOB = TextEditingController();

  LoginModel loginModel;

  bool valAdmin;
  String isAdmin;
  DateTime getDOB;

  Future refreshData() async {
    setState(() {
      txtNPM.text = '';
      txtName.text = '';
      txtDOB.text = '';
      valAdmin = false;
      isAdmin = '';
      getDOB = DateTime.now();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Registrasi', style: TextStyle(fontSize: 17)),
            backgroundColor: Color.fromARGB(255, 15, 193, 167),
            elevation: 0),
        body: Theme(
          data: ThemeData(primaryColor: Color.fromARGB(255, 15, 193, 167)),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: GlowingOverscrollIndicator(
                      axisDirection: AxisDirection.down,
                      color: Color.fromARGB(255, 15, 193, 167),
                      child: ListView(
                        padding: EdgeInsets.all(10),
                        children: [
                          TextField(
                              controller: txtNPM,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.featured_play_list),
                                  hintText: 'NPM'),
                              onSubmitted: (value) {
                                setState(() {
                                  txtNPM.text = value;
                                });
                              }),
                          TextField(
                            controller: txtName,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                icon: Icon(Icons.person),
                                hintText: 'Nama lengkap'),
                            onSubmitted: (value) {
                              setState(() {
                                txtName.text = value;
                              });
                            },
                          ),
                          TextField(
                            keyboardType: TextInputType.datetime,
                            controller: txtDOB,
                            readOnly: true,
                            decoration: InputDecoration(
                                icon: Icon(Icons.calendar_today),
                                hintText: 'Date of Birth'),
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: getDOB,
                                      firstDate: DateTime(1945),
                                      lastDate: DateTime.now())
                                  .then((value) {
                                setState(() {
                                  getDOB = value;
                                  txtDOB.text =
                                      DateFormat('dd MMM yyyy').format(getDOB);
                                });
                              });
                            },
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 25),
                            child: Row(
                              children: [
                                Checkbox(
                                    activeColor:
                                        Color.fromARGB(255, 15, 193, 167),
                                    value: valAdmin,
                                    onChanged: (value) {
                                      setState(() {
                                        valAdmin = value;
                                        (valAdmin == true)
                                            ? isAdmin = '1'
                                            : isAdmin = '0';
                                      });
                                    }),
                                Text('Admin')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: 70,
                  child: Center(
                    child: GestureDetector(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 15, 193, 167),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Text(
                            'Simpan',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (txtNPM.text == '' ||
                            txtName.text == '' ||
                            txtDOB.text == '') {
                          Alert(
                              context: context,
                              title: 'Harap isi dengan benar',
                              type: AlertType.warning,
                              buttons: [
                                DialogButton(
                                    color: Color.fromARGB(255, 15, 193, 167),
                                    child: Text('OK',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () => Get.back())
                              ]).show();
                        } else {
                          showProgressDialog(
                              context: context, loadingText: ' Loading...');

                          Future.delayed(Duration(seconds: 3)).then((value) {
                            LoginModel.connectToApi(txtNPM.text).then((value) {
                              setState(() {
                                loginModel = value;
                                if (loginModel != null) {
                                  Alert(
                                      context: context,
                                      title: 'NPM sudah terdaftar',
                                      type: AlertType.error,
                                      buttons: [
                                        DialogButton(
                                            color: Color.fromARGB(
                                                255, 15, 193, 167),
                                            child: Text('OK',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            onPressed: () {
                                              Get.back();
                                            })
                                      ]).show();
                                } else {
                                  RegistrasiModel.connectToAPI(
                                          txtNPM.text,
                                          txtName.text,
                                          DateFormat('yyyy-MM-dd')
                                              .format(getDOB),
                                          isAdmin)
                                      .then((value) {
                                    setState(() {
                                      refreshData();
                                    });
                                  });
                                  Alert(
                                      context: context,
                                      title: 'Registrasi berhasil',
                                      type: AlertType.success,
                                      buttons: [
                                        DialogButton(
                                            color: Color.fromARGB(
                                                255, 15, 193, 167),
                                            child: Text('OK',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            onPressed: () =>
                                                Get.offAll(DashboardAdm()))
                                      ]).show();
                                }
                              });
                            });
                            dismissProgressDialog();
                          });
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
