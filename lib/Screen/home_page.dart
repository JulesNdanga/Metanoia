import 'dart:ui';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admob/Helper/ColorsRes.dart';
import 'package:flutter_admob/Helper/String.dart';
import 'package:flutter_admob/Model/Category.dart';
import 'package:flutter_admob/Screen/search.dart';
import 'package:flutter_admob/databaseHelper/dbhelper.dart';
import 'package:flutter_admob/localization/Demo_Localization.dart';
import 'package:flutter_admob/localization/language_constants.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TermFeed/About_Us.dart';
import 'TermFeed/Contact_Us.dart';
import 'TermFeed/Privacy_Policy.dart';
import 'TermFeed/Terms___Conditions.dart';
import 'admob_service.dart';
import 'bookmarklist.dart';
import 'chapterDetails.dart';
import 'chapterlist.dart';

class Mainpage extends StatefulWidget {
  final int id;
  Mainpage({Key key, this.id}) : super(key: key);
  MyHomePage createState() => MyHomePage();
}

class MyHomePage extends State<Mainpage> {
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();
  Icon searchIcon = Icon(Icons.search);
  int ccatid;
  String title;
  var currentIndexPage = 0;
  final PageController controller = PageController(initialPage: 0);
  final key = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getTitle();
    getIndicator();
    setState(() {
      super.initState();
    });
  }

//------------------------------------------------------------------------------
//===============================For Arabic ==============================

  arDrawer() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsRes.appColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.75,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: ColorsRes.textcolor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.42,
            child: Stack(
              children: [
                Positioned(
                    top: height * 0.06,
                    left: width * 0.15,
                    child: Image.asset("assets/images/splash_logo.png")),
                Positioned(
                  top: height * 0.34,
                  left: width * 0.18,
                  child: Text(
                    "Metanoia",
                    style: TextStyle(
                        color: ColorsRes.appColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins"),
                  ),
                ),
                Positioned(
                  top: height * 0.37,
                  left: width * 0.270,
                  child: Text(
                    DemoLocalization.of(context).translate("Explore"),
                    style: TextStyle(
                      color: ColorsRes.appColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Image.asset("assets/images/mode_icon.png"),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          DemoLocalization.of(context).translate("Dark Mode"),
                          style: TextStyle(
                            color: ColorsRes.white,
                            fontSize: 20,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      dark_mode == true
                          ? Image.asset("assets/images/toggle_light.png")
                          : Image.asset("assets/images/toggle_dark.png"),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      if (dark_mode == true) {
                        dark_mode = false;
                        setDarkMode(dark_mode);
                      } else {
                        dark_mode = true;
                        setDarkMode(dark_mode);
                      }
                    });
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Image.asset("assets/images/termscond_icon.png"),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          DemoLocalization.of(context)
                              .translate("Terms & Conditions"),
                          style: TextStyle(
                            color: ColorsRes.white,
                            fontSize: 20,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new Terms_Condition(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Image.asset("assets/images/privacypolicy_icon.png"),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          DemoLocalization.of(context)
                              .translate("Privacy Policy"),
                          style: TextStyle(
                            color: ColorsRes.white,
                            fontSize: 20,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new Privacy_Policy(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Image.asset("assets/images/rateus_icon.png"),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          DemoLocalization.of(context).translate("Rate Us"),
                          style: TextStyle(
                            color: ColorsRes.white,
                            fontSize: 20,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    LaunchReview.launch(
                      androidAppId: "com.julesndanga.Metanoia",
                      iOSAppId: "585027354",
                    );
                  },
                ),
                ListTile(
                    title: Row(
                      children: [
                        Image.asset("assets/images/share_app.png"),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            DemoLocalization.of(context).translate("Share App"),
                            style: TextStyle(
                              color: ColorsRes.white,
                              fontSize: 20,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        Share.share(
                            'https://play.google.com/store/apps/details? id=com.book.reading');
                      });
                    }),
                ListTile(
                  title: Row(
                    children: [
                      Image.asset("assets/images/contactus_icon.png"),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          DemoLocalization.of(context).translate("Contact Us"),
                          style: TextStyle(
                            color: ColorsRes.white,
                            fontSize: 20,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new Contact_Us()));
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Image.asset("assets/images/aboutus_icon.png"),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          DemoLocalization.of(context).translate("About Us"),
                          style: TextStyle(
                            color: ColorsRes.white,
                            fontSize: 20,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new About_Us()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//------------------------------------------------------------------------------
//===============================Other All ==============================

  commanDrawer() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsRes.appColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.75,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: ColorsRes.textcolor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.42,
            child: Stack(
              children: [
                Positioned(
                    top: height * 0.06,
                    left: width * 0.15,
                    child: Image.asset("assets/images/splash_logo.png")),
                Positioned(
                  top: height * 0.34,
                  left: width * 0.18,
                  child: Text(
                    "Metanoia",
                    style: TextStyle(
                        color: ColorsRes.appColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins-Bold"),
                  ),
                ),
                Positioned(
                  top: height * 0.37,
                  left: width * 0.270,
                  child: Text(
                    DemoLocalization.of(context).translate("Explore"),
                    style: TextStyle(
                      color: ColorsRes.appColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Image.asset("assets/images/mode_icon.png"),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          DemoLocalization.of(context).translate("Dark Mode"),
                          style: TextStyle(
                            color: ColorsRes.white,
                            fontSize: 20,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      dark_mode == true
                          ? Image.asset("assets/images/toggle_light.png")
                          : Image.asset("assets/images/toggle_dark.png"),
                    ],
                  ),
                  onTap: () {
                    if (dark_mode == true) {
                      setState(() {
                        dark_mode = false;
                        setDarkMode(dark_mode);
                      });
                    } else {
                      setState(() {
                        dark_mode = true;
                        setDarkMode(dark_mode);
                      });
                    }
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Image.asset("assets/images/termscond_icon.png"),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          DemoLocalization.of(context)
                              .translate("Terms & Conditions"),
                          style: TextStyle(
                            color: ColorsRes.white,
                            fontSize: 20,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new Terms_Condition(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Image.asset("assets/images/privacypolicy_icon.png"),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          DemoLocalization.of(context)
                              .translate("Privacy Policy"),
                          style: TextStyle(
                            color: ColorsRes.white,
                            fontSize: 20,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new Privacy_Policy(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Image.asset("assets/images/rateus_icon.png"),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          DemoLocalization.of(context).translate("Rate Us"),
                          style: TextStyle(
                            color: ColorsRes.white,
                            fontSize: 20,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    LaunchReview.launch(
                      androidAppId: "com.julesndanga.Metanoia",
                      iOSAppId: "585027354",
                    );
                  },
                ),
                ListTile(
                    title: Row(
                      children: [
                        Image.asset("assets/images/share_app.png"),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            DemoLocalization.of(context).translate("Share App"),
                            style: TextStyle(
                              color: ColorsRes.white,
                              fontSize: 20,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        Share.share(
                            'https://play.google.com/store/apps/details? id=com.book.reading');
                      });
                    }),
                ListTile(
                  title: Row(
                    children: [
                      Image.asset("assets/images/contactus_icon.png"),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          DemoLocalization.of(context).translate("Contact Us"),
                          style: TextStyle(
                            color: ColorsRes.white,
                            fontSize: 20,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new Contact_Us()));
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Image.asset("assets/images/aboutus_icon.png"),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          DemoLocalization.of(context).translate("About Us"),
                          style: TextStyle(
                            color: ColorsRes.white,
                            fontSize: 20,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new About_Us()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//------------------------------------------------------------------------------
//=============================== Animated Container ==============================

  animatedContainer() {
    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(scaleFactor)
        ..rotateY(
          isDrawerOpen ? -0.5 : 0,
        ),
      decoration: BoxDecoration(
        color: dark_mode ? ColorsRes.white : ColorsRes.grey,
        boxShadow: [
          BoxShadow(
            blurRadius: 60,
            color: ColorsRes.appColor.withOpacity(0.5),
            offset: Offset(1, 3),
          ),
        ],
        //  border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0),
      ),
      duration: Duration(milliseconds: 250),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          controller: controller,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              mainHeading(),
              getSliders(),
              threeButtons(),
              getBooks(),
            ],
          ),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------
//=============================== Head Menue ==============================

  mainHeading() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isDrawerOpen
              ? IconButton(
                  icon: Image.asset(
                    "assets/images/menu_icon.png",
                  ),
                  onPressed: () {
                    setState(() {
                      xOffset = 0;
                      yOffset = 0;
                      scaleFactor = 1;
                      isDrawerOpen = false;
                    });
                  },
                )
              : IconButton(
                  icon: Image.asset(
                    "assets/images/menu_icon.png",
                  ),
                  onPressed: () {
                    setState(
                      () {
                        if (Language_flag == "ar") {
                          xOffset = width * -0.5; // for X- axis
                          yOffset = height * 0.1; // for Y -axis
                          scaleFactor = 0.8; // size of home screen
                          isDrawerOpen = true;
                        } else {
                          xOffset = width * 0.8; // for X- axis
                          yOffset = height * 0.1; // for Y -axis
                          scaleFactor = 0.8; // size of home screen
                          isDrawerOpen = true;
                        }
                      },
                    );
                  },
                ),
          Text(
            DemoLocalization.of(context).translate("appName"),
            style: TextStyle(
                fontSize: 25,
                color: ColorsRes.appColor,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500),
          ),
          IconButton(
            icon: Image.asset(
              "assets/images/search_icon.png",
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new ListSearch()));
            },
          ),
        ],
      ),
    );
  }
//------------------------------------------------------------------------------
//=============================== Sliders ==============================

  getSliders() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        height: width / 1.5,
        child: Carousel(
          dotSize: 5.0,
          dotSpacing: 15.0,
          animationCurve: Curves.easeInOutSine,
          animationDuration: Duration(seconds: 1),
          autoplay: true,
          dotColor: ColorsRes.textcolor,
          indicatorBgPadding: 5.0,
          dotVerticalPadding: 5.0,
          dotBgColor: Colors.transparent,
          dotPosition: DotPosition.bottomCenter,
          images: [
            Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assets/images/slider_home.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: height * 0.075,
                  left: width * 0.390,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      DemoLocalization.of(context).translate("Explore"),
                      style: TextStyle(
                        color: ColorsRes.textcolor,
                        fontFamily: "Poppins",
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.095,
                  left: width * 0.388,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      DemoLocalization.of(context).translate("Instructive"),
                      style: TextStyle(
                        color: ColorsRes.textcolor,
                        fontSize: 25,
                        //   fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.148,
                  left: width * 0.74,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        DemoLocalization.of(context).translate("Books"),
                        style: TextStyle(
                          color: ColorsRes.textcolor,
                          fontSize: 14,
                          fontFamily: "Poppins-Thin",
                          fontWeight: FontWeight.w300,
                        ),
                      )),
                ),
                
              ],
            ),
            Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assets/images/slider2_home.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: height * 0.085,
                  left: width * 0.447,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        DemoLocalization.of(context).translate("Explore"),
                        style: TextStyle(
                          color: ColorsRes.textcolor,
                          fontFamily: "Poppins-Thin",
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      )),
                ),
                Positioned(
                  top: height * 0.105,
                  left: width * 0.447,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      DemoLocalization.of(context).translate("Biography"),
                      style: TextStyle(
                        color: ColorsRes.textcolor,
                        fontSize: 25,
                        fontFamily: "Poppins-ExtraBold",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.1555,
                  left: width * 0.72,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        DemoLocalization.of(context).translate("Books"),
                        style: TextStyle(
                          color: ColorsRes.textcolor,
                          fontSize: 15,
                          fontFamily: "Poppins-Thin",
                          fontWeight: FontWeight.w300,
                        ),
                      )),
                ),
                
              ],
            ),
            Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assets/images/slider3_home.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: height * 0.078,
                  left: width * 0.3868,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        DemoLocalization.of(context).translate("Explore"),
                        style: TextStyle(
                          color: ColorsRes.textcolor,
                          fontFamily: "Poppins-Thin",
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      )),
                ),
                Positioned(
                  top: height * 0.105,
                  left: width * 0.3868,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      DemoLocalization.of(context).translate("Historical"),
                      style: TextStyle(
                        color: ColorsRes.textcolor,
                        fontSize: 25,
                        fontFamily: "Poppins-ExtraBold",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.16,
                  left: width * 0.695,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        DemoLocalization.of(context).translate("Books"),
                        style: TextStyle(
                          color: ColorsRes.textcolor,
                          fontSize: 15,
                          fontFamily: "Poppins-Thin",
                          fontWeight: FontWeight.w300,
                        ),
                      )),
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }

//------------------------------------------------------------------------------
//=============================== 3 Buttons ==============================

  threeButtons() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getFirstButton(),
          getSecondButton(),
          getThirdButton(),
        ],
      ),
    );
  }

  //First Button
  getFirstButton() {
    return InkWell(
      onTap: () {
        setState(
          () {
            showMenu<String>(
              color: ColorsRes.appColor,
              context: context,
              position: RelativeRect.fromLTRB(25.0, 0.0, 0.0, 0.0),
              items: [
                PopupMenuItem<String>(
                    child: Text(
                        DemoLocalization.of(context).translate("ENGLISH"),
                        style: TextStyle(color: Colors.white)),
                    value: '0'),
                PopupMenuItem<String>(
                    child: Text(
                        DemoLocalization.of(context).translate("FRENCH"),
                        style: TextStyle(color: Colors.white)),
                    value: '1'),
              ],
              elevation: 7.0,
            ).then<void>(
              (String itemSelected) {
                if (itemSelected == null) return;
                if (itemSelected == "0") {
                  print("ENGLISH");
                  setState(() async {
                    changeLanguage(context, "en");
                  });
                } else if (itemSelected == "1") {
                  print("FRENCH");
                  setState(() async {
                    changeLanguage(context, "fr");
                  });
                }
              },
            );
          },
        );
      },
      child: Container(
        height: 40,
        width: 100,
        decoration: BoxDecoration(
          color: ColorsRes.appColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 8,
            ),
            Image.asset(
              "assets/images/language_icon.png",
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  DemoLocalization.of(context).translate("language"),
                  style: TextStyle(
                    fontSize: 10,
                    color: ColorsRes.textcolor,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Second Button
  getSecondButton() {
    return InkWell(
      onTap: () {
        AdmobService.showInterstitialAd();
        Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new BookmarkList()))
            .then(
          (value) {
            setState(
              () {},
            );
          },
        );
      },
      child: Container(
        height: 40,
        width: 100,
        decoration: BoxDecoration(
          color: ColorsRes.appColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 8,
            ),
            Image.asset(
              "assets/images/bookmark_selected.png",
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  DemoLocalization.of(context).translate("bookMark"),
                  style: TextStyle(
                    fontSize: 10,
                    color: ColorsRes.textcolor,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Third Button
  getThirdButton() {
    return InkWell(
      onTap: () async {
        print("Title === $title");
        print("check === " + ccatid.toString());
        await getTitle();
        await getIndicator();
        print("Title === $title");
        print("check === " + ccatid.toString());
        if (ccatid == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            new SnackBar(
              backgroundColor: ColorsRes.appColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              duration: Duration(
                seconds: 2,
              ),
              content: new Text(
                DemoLocalization.of(context).translate("Indicator not set !"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorsRes.white,
                  fontFamily: 'Times new Roman',
                ),
              ),
            ),
          );
        } else {
          print("inside navigation");
          print(ccatid);
          print(title);
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new DetailPage(
                id1: ccatid,
                title: title,
              ),
            ),
          );
        }
      },
      child: Container(
        height: 40,
        width: 100,
        //  width: MediaQuery.of(context).size.width / 3.5,
        decoration: BoxDecoration(
          color: ColorsRes.appColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 8,
            ),
            ccatid == null
                ? Image.asset(
                    "assets/images/pinned_unselected.png",
                  )
                : Image.asset(
                    "assets/images/pinned_selected.png",
                  ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  DemoLocalization.of(context).translate("pinned"),
                  style: TextStyle(
                    fontSize: 10,
                    color: ColorsRes.textcolor,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//------------------------------------------------------------------------------
//=============================== 3 Buttons ==============================
  getBooks() {
    return Container(
      margin: EdgeInsets.all(15),
      color: dark_mode ? ColorsRes.white : ColorsRes.grey,
      child: FutureBuilder(
        //Fetching all the persons from the list using the istance of the DatabaseHelper class
        future: instance.getCategory(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //Checking if we got data or not from the DB
          if (snapshot.hasData) {
            print("check poit ${snapshot.hasData}");
            return GridView.builder(
              physics: BouncingScrollPhysics(parent: ScrollPhysics()),
              itemCount: snapshot.data.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.965,
              ),
              itemBuilder: (BuildContext context, int index) {
                Category item = snapshot.data[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // data base to global variable title
                        en_Title = item.Title;
                        fr_Title = item.fr_Title;

                        // data base to global variable Author
                        Author_name = item.Author;
                        fr_Author_name = item.fr_Author;

                        // data base to global variable For Chapter Count
                        chapter_total = item.Chapter;
                        AdmobService.showInterstitialAd();
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => ChapterList(
                              id: item.Id,
                              title: item.Title,
                            ),
                          ),
                        ).then(
                          (value) {
                            setState(
                              () {
                                xOffset = 0;
                                yOffset = 0;
                                scaleFactor = 1;
                                isDrawerOpen = false;
                                initState();
                              },
                            );
                          },
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            "assets/images/container_box.png",
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  //"Ramayana ",
                                  () {
                                    if (Language_flag == "en") {
                                      return item.Title;
                                    } else if (Language_flag == "fr") {
                                      return item.fr_Title;
                                    } else {
                                      return item.Title;
                                    }
                                  }(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorsRes.appColor,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return Center(child: new CircularProgressIndicator());
          }
        },
      ),
    );
  }
//------------------------------------------------------------------------------
//=============================== main Conteiner ==============================

  mainContainer() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: dark_mode ? Colors.grey[200] : ColorsRes.grey,
    );
  }

//------------------------------------------------------------------------------
//=============================== Blurr Desing for drawer ==============================

  blurrDesing1() {
    return isDrawerOpen
        ? Positioned.directional(
            textDirection: Directionality.of(context),
            top: height * 0.0,
            start: width * 0.50,
            child: Container(
              width: width * 0.25,
              height: height,
              color: Colors.white.withOpacity(0.3),
            ),
          )
        : Container();
  }

  blurrDesing2() {
    return isDrawerOpen
        ? Positioned.directional(
            textDirection: Directionality.of(context),
            top: height * 0.0,
            start: width * 0.75,
            child: Container(
              width: width * 0.25,
              height: height,
              color: Colors.white.withOpacity(0.3),
            ),
          )
        : Container();
  }

//------------------------------------------------------------------------------
//=============================== Tapped Drawer ==============================

  forDrawerTaping() {
    return isDrawerOpen
        ? Positioned.directional(
            textDirection: Directionality.of(context),
            top: height * 0.1,
            start: width * 0.8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  xOffset = 0;
                  yOffset = 0;
                  scaleFactor = 1;
                  isDrawerOpen = false;
                });
                print("Tapped Drawer ");
              },
              child: Container(
                width: width * 0.195,
                height: height * 0.79,
                color: Colors.transparent,
              ),
            ),
          )
        : Container();
  }

//------------------------------------------------------------------------------
//=============================== Build Method ==============================

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: key,
      backgroundColor: dark_mode ? Colors.grey[200] : ColorsRes.grey,
      body: Stack(
        children: [
          mainContainer(),
          blurrDesing1(),
          Language_flag == "ar" ? arDrawer() : commanDrawer(),
          animatedContainer(),
          blurrDesing2(),
          forDrawerTaping(),
        ],
      ),
    );
  }

//------------------------------------------------------------------------------
//=============================== Shared Preferance ==============================

  Future<String> getTitle() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    title = preferences.getString("Title");
    print("Title- is ---$title");
    return title;
  }

  Future<int> getIndicator() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    ccatid = preferences.getInt("In");
    print("Category id----" + preferences.getInt("Category").toString());
    return ccatid;
  }

  setDarkMode(bool dark_mode) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool("Dark_Mode", dark_mode);
  }
}
