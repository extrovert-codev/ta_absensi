import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ta_absensi/model/absenpersonal_model.dart';
import 'package:ta_absensi/_GlobalScript.dart' as gScript;

class AbsenPersonal extends StatefulWidget {
  @override
  _AbsenPersonalState createState() => _AbsenPersonalState();
}

class _AbsenPersonalState extends State<AbsenPersonal> {
  String txtDate, txtTimeIn, txtTimeOut;
  DateTime getDate;

  AbsenPersonalModel absenPersonalModel;

  Future refreshData() async {
    setState(() {
      txtTimeIn = '';
      txtTimeOut = '';
      getDate = DateTime.now();
      txtDate = DateFormat('EEEE, dd MMM yyyy').format(DateTime.now());
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
          title: Text('Absenku', style: TextStyle(fontSize: 17)),
          backgroundColor: Color.fromARGB(255, 15, 193, 167),
          elevation: 0),
      body: Container(
        color: Colors.white,
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: Color.fromARGB(255, 15, 193, 167),
          child: RefreshIndicator(
            onRefresh: () => refreshData(),
            child: ListView(
              children: [
                CalendarDatePicker(
                    initialDate: getDate,
                    firstDate: DateTime(1945),
                    lastDate: DateTime.now(),
                    onDateChanged: (value) {
                      getDate = value;
                      txtDate = DateFormat('EEEE, dd MMM yyyy').format(getDate);

                      AbsenPersonalModel.connectToApi(gScript.mid,
                              DateFormat('yyyy-MM-dd').format(getDate))
                          .then((value) {
                        absenPersonalModel = value;
                        setState(() {
                          if (absenPersonalModel != null) {
                            txtTimeIn = absenPersonalModel.timeIn;
                            txtTimeOut = absenPersonalModel.timeOut;
                          } else {
                            txtTimeIn = '';
                            txtTimeOut = '';
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
                Divider(height: 0, thickness: 1),
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
    );
  }
}
