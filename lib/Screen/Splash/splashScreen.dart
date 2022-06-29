import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_admob/Helper/ColorsRes.dart';
import 'package:flutter_admob/Helper/String.dart';
import 'package:flutter_admob/localization/Demo_Localization.dart';

import '../home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    Timer(
      Duration(seconds: 5),
      () => Navigator.pushReplacement(
        context,
        new MaterialPageRoute(builder: (context) => Mainpage()),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsRes.white,
      body: new Container(
        color: dark_mode ? ColorsRes.backgroundColor : ColorsRes.grey,
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.20,
                      ),
                      Image.asset("assets/images/splash_logo.png"),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        DemoLocalization.of(context).translate("FLUTTER"),
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: ColorsRes.appColor,
                        ),
                      ),
                      Text(
                        DemoLocalization.of(context).translate("OFFLINE"),
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: ColorsRes.appColor,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        DemoLocalization.of(context).translate("EBOOK APP"),
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: ColorsRes.appColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Language_flag == "ar"
                    ? Image.asset("assets/images/books_splashrtl.png")
                    : Image.asset("assets/images/books_splash.png"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
