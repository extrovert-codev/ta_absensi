import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ta_absensi/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) => Get.off(Login(),
        transition: Transition.native, duration: Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 15, 193, 167),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('abs',
                      style: TextStyle(fontSize: 60, color: Colors.white)),
                  Icon(Icons.fingerprint, size: 70, color: Colors.white),
                  Text('nsiQ',
                      style: TextStyle(fontSize: 60, color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
