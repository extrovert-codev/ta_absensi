import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ta_absensi/model/absenpersonal_model.dart';
import 'package:ta_absensi/model/mahasiswa_model.dart';

class AbsenMahasiswa extends StatefulWidget {
  @override
  _AbsenMahasiswaState createState() => _AbsenMahasiswaState();
}

class _AbsenMahasiswaState extends State<AbsenMahasiswa> {
  String txtDate, txtTimeIn, txtTimeOut, txtMahasiswa, txtMid;
  List dataMhs, dataMid;
  DateTime getDate;

  AbsenPersonalModel absenPersonalModel;

  Future refreshData() async {
    setState(() {
      dataMid = [];
      dataMhs = [];
      txtTimeIn = '';
      txtTimeOut = '';
      getDate = DateTime.now();
      txtDate = DateFormat('EEEE, dd MMM yyyy').format(DateTime.now());
      MahasiswaModel.connectToApi().then((value) {
        setState(() {
          for (int i = 0; i < value.length; i++) {
            dataMid.add(value[i].mid);
            dataMhs.add(value[i].name);
          }
          txtMahasiswa = dataMhs[0];
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Absen Mahasiswa',
          style: TextStyle(fontSize: 17),
        ),
        backgroundColor: Color.fromARGB(255, 15, 193, 167),
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: Color.fromARGB(255, 15, 193, 167),
            child: RefreshIndicator(
              onRefresh: () => refreshData(),
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: DropdownButton(
                      value: txtMahasiswa,
                      items: dataMhs.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          txtMahasiswa = value;
                          txtMid = dataMid[dataMhs.indexOf(value)];
                        });
                      },
                    ),
                  ),
                  CalendarDatePicker(
                      initialDate: getDate,
                      firstDate: DateTime(1945),
                      lastDate: DateTime.now(),
                      onDateChanged: (value) {
                        setState(() {
                          getDate = value;
                          txtDate =
                              DateFormat('EEEE, dd MMM yyyy').format(getDate);

                          AbsenPersonalModel.connectToApi(txtMid,
                                  DateFormat('yyyy-MM-dd').format(getDate))
                              .then((value) {
                            absenPersonalModel = value;

                            if (absenPersonalModel != null) {
                              txtTimeIn = absenPersonalModel.timeIn;
                              txtTimeOut = absenPersonalModel.timeOut;
                            }
                          });
                        });
                      }),
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 50,
                    color: Colors.teal[50],
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        txtDate,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 15, 193, 167)),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Row(
                              children: [
                                Icon(Icons.watch,
                                    color: Color.fromARGB(255, 15, 193, 167)),
                                Text(
                                  ' Time In',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 15, 193, 167)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  txtTimeIn,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 15, 193, 167)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Row(
                              children: [
                                Icon(Icons.watch,
                                    color: Color.fromARGB(255, 15, 193, 167)),
                                Text(
                                  ' Time Out',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 15, 193, 167)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  txtTimeOut,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 15, 193, 167)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
