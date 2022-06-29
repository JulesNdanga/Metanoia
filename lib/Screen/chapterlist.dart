import 'package:flutter_admob/Helper/ColorsRes.dart';
import 'package:flutter_admob/Helper/String.dart';
import 'package:flutter_admob/Model/detail.dart';
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
import 'package:flutter/material.dart';

class ChapterList extends StatefulWidget {
  final int id;
  final String title;
  ChapterList({Key key, this.id, this.title}) : super(key: key);
  ChapterList1 createState() => ChapterList1();
}

class ChapterList1 extends State<ChapterList> {
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  List<detail> item = [];
  List<detail> _notesForDisplay = [];
  TextEditingController _textController = TextEditingController();
  Icon searchIcon = Icon(Icons.search);
  // for indicator
  String title;
  int ccatid;
  bool typing = false;
  String source, query;
  //search highlightText
  List<TextSpan> highlightOccurrences(source, query) {
    if (query == null || query.isEmpty) {
      return [TextSpan(text: source)];
    }

    var matches = <Match>[];
    for (final token in query.trim().toLowerCase().split(' ')) {
      matches.addAll(token.allMatches(source.toLowerCase()));
    }

    if (matches.isEmpty) {
      return [TextSpan(text: source)];
    }
    matches.sort((a, b) => a.start.compareTo(b.start));

    int lastMatchEnd = 0;
    final List<TextSpan> children = [];
    for (final match in matches) {
      if (match.end <= lastMatchEnd) {
        // already matched -> ignore
      } else if (match.start <= lastMatchEnd) {
        children.add(
          TextSpan(
            text: source.substring(
              lastMatchEnd,
              match.end,
            ),
            style: TextStyle(
              backgroundColor: Color(0xff9a0b0b),
              color: Colors.white,
            ),
          ),
        );
      } else if (match.start > lastMatchEnd) {
        children.add(
          TextSpan(
            text: source.substring(
              lastMatchEnd,
              match.start,
            ),
          ),
        );

        children.add(
          TextSpan(
            text: source.substring(
              match.start,
              match.end,
            ),
            style: TextStyle(
              backgroundColor: Color(0xff9a0b0b),
              color: Colors.white,
            ),
          ),
        );
      }
      if (lastMatchEnd < match.end) {
        lastMatchEnd = match.end;
      }
    }
    if (lastMatchEnd < source.length) {
      children.add(
        TextSpan(
          text: source.substring(
            lastMatchEnd,
            source.length,
          ),
        ),
      );
    }
    return children;
  }

  @override
  void initState() {
    getTitle();
    getIndicator();
    super.initState();
    setState(
      () {
        instance.getDetail(widget.id).then(
          (value) {
            item.addAll(value);
            _notesForDisplay = item;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext con) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: dark_mode ? Colors.grey[200] : ColorsRes.grey,
          ),
          isDrawerOpen
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
              : Container(),
          Language_flag == "ar"
              ? Container(
                  decoration: BoxDecoration(
                    color: ColorsRes.appColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: ListView(padding: EdgeInsets.zero, children: <Widget>[
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
                              child:
                                  Image.asset("assets/images/splash_logo.png")),
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
                                    DemoLocalization.of(context)
                                        .translate("Dark Mode"),
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
                                    ? Image.asset(
                                        "assets/images/toggle_light.png")
                                    : Image.asset(
                                        "assets/images/toggle_dark.png"),
                              ],
                            ),
                            onTap: () {
                              //    context.read<ThemeProvider>().ChangeThemeMode();

                              setState(
                                () {
                                  //   dark_mode = !dark_mode;
                                  print("dark on off");
                                  print(dark_mode);
                                  if (dark_mode == true) {
                                    dark_mode = false;
                                    setDarkMode(dark_mode);
                                  } else {
                                    dark_mode = true;
                                    setDarkMode(dark_mode);
                                  }
                                },
                              );
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
                                Image.asset(
                                    "assets/images/privacypolicy_icon.png"),
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
                                    DemoLocalization.of(context)
                                        .translate("Rate Us"),
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
                                      DemoLocalization.of(context)
                                          .translate("Share App"),
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
                                    DemoLocalization.of(context)
                                        .translate("Contact Us"),
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
                                    DemoLocalization.of(context)
                                        .translate("About Us"),
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
                  ]),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: ColorsRes.appColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: ListView(padding: EdgeInsets.zero, children: <Widget>[
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
                              child:
                                  Image.asset("assets/images/splash_logo.png")),
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
                                    DemoLocalization.of(context)
                                        .translate("Dark Mode"),
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
                                    ? Image.asset(
                                        "assets/images/toggle_light.png")
                                    : Image.asset(
                                        "assets/images/toggle_dark.png"),
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
                                Image.asset(
                                    "assets/images/privacypolicy_icon.png"),
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
                                    DemoLocalization.of(context)
                                        .translate("Rate Us"),
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
                                      DemoLocalization.of(context)
                                          .translate("Share App"),
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
                                    DemoLocalization.of(context)
                                        .translate("Contact Us"),
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
                                    DemoLocalization.of(context)
                                        .translate("About Us"),
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
                  ]),
                ),
          AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scaleFactor)
              ..rotateY(
                isDrawerOpen ? -0.5 : 0,
              ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 60,
                  color: ColorsRes.appColor.withOpacity(0.5),
                  offset: Offset(1, 3),
                ),
              ],
              color: dark_mode ? ColorsRes.white : ColorsRes.black,
              borderRadius: BorderRadius.circular(
                isDrawerOpen ? 40 : 0.0,
              ),
            ),
            duration: Duration(milliseconds: 250),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //common appbar Container

                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 0.7,
                      color:
                          dark_mode ? Colors.grey[100] : ColorsRes.grey, //grey1
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0),
                              ),
                              // boxShadow: [
                              //   new BoxShadow(
                              //     color: Colors.black,
                              //     blurRadius: 6.0,
                              //     spreadRadius: -1,
                              //     offset: Offset(0, 1),
                              //     //offset: Offset(0.0, 1.0), //(x,y)
                              //   ),
                              // ],
                              color: dark_mode
                                  ? ColorsRes.white
                                  : ColorsRes.grey1, //grey1
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 15.0,
                                    left: 5,
                                    right: 5,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          isDrawerOpen
                                              ? IconButton(
                                                  icon: Image.asset(
                                                    "assets/images/menu_icon.png",
                                                  ),
                                                  onPressed: () {
                                                    setState(
                                                      () {
                                                        xOffset = 0;
                                                        yOffset = 0;
                                                        scaleFactor = 1;
                                                        isDrawerOpen = false;
                                                      },
                                                    );
                                                  },
                                                )
                                              : IconButton(
                                                  icon: Image.asset(
                                                    "assets/images/menu_icon.png",
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (Language_flag ==
                                                          "ar") {
                                                        xOffset = width *
                                                            -0.5; // for X- axis
                                                        yOffset = height *
                                                            0.1; // for Y -axis
                                                        scaleFactor =
                                                            0.8; // size of home screen
                                                        isDrawerOpen = true;
                                                      } else {
                                                        xOffset = width *
                                                            0.8; // for X- axis
                                                        yOffset = height *
                                                            0.1; // for Y -axis
                                                        scaleFactor =
                                                            0.8; // size of home screen
                                                        isDrawerOpen = true;
                                                      }
                                                    });
                                                  }),
                                          Text(
                                            DemoLocalization.of(context)
                                                .translate("appName"),
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
                                                  builder: (context) =>
                                                      new ListSearch(),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 12.0,
                                          left: 12.0,
                                          right: 12.0,
                                        ),
                                        child: Container(
                                          // height: 50,
                                          // width:
                                          //     MediaQuery.of(context).size.width * 0.40,
                                          // color: Colors.red,
                                          child: Text(
                                            () {
                                              if (Language_flag == "en") {
                                                return en_Title;
                                              } else if (Language_flag ==
                                                  "fr") {
                                                return fr_Title;
                                              } else {
                                                return en_Title;
                                              }
                                            }(),
                                            style: TextStyle(
                                              color: ColorsRes.appColor,
                                              fontSize: 20.0,
                                              fontFamily: "Poppings-ExtraBold",
                                              fontWeight: FontWeight.bold,
                                              height: 1.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 12.0,
                                          top: 8.0,
                                          right: 12.0,
                                        ),
                                        child: Text(
                                          DemoLocalization.of(context)
                                                  .translate("Written by") +
                                              " " +
                                              () {
                                                if (Language_flag == "en") {
                                                  return Author_name;
                                                } else if (Language_flag ==
                                                    "fr") {
                                                  return fr_Author_name;
                                                } else {
                                                  return Author_name;
                                                }
                                              }(),
                                          style: TextStyle(
                                            color: dark_mode
                                                ? ColorsRes.appColor
                                                : ColorsRes.white,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 12.0,
                                          right: 12.0,
                                        ),
                                        child: Text(
                                          "${chapter_total} " +
                                              DemoLocalization.of(context)
                                                  .translate("Chapters"),
                                          style: TextStyle(
                                              color: dark_mode
                                                  ? ColorsRes.appColor
                                                  : ColorsRes.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned.directional(
                            textDirection: Directionality.of(context),
                            //  height: 75,
                            top: height * 0.111,
                            start: width * 0.66,
                            //   textDirection: TextDirection.,
                            child: Stack(
                              children: [
                                Image.asset(
                                  "assets/images/book_container.png",
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    width: width * 0.261,
                                    height: height * 0.2,
                                    child: Center(
                                      child: Text(
                                        () {
                                          if (Language_flag == "en") {
                                            return en_Title;
                                          } else if (Language_flag == "fr") {
                                            return fr_Title;
                                          } else {
                                            return en_Title;
                                          }
                                        }(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: ColorsRes.appColor,
                                          height: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned.directional(
                            textDirection: Directionality.of(context),
                            top: width * 0.54,
                            start: width * 0.02,
                            child: GestureDetector(
                              onTap: () {
                                setState(
                                  () {
                                    showMenu<String>(
                                      color: dark_mode
                                          ? ColorsRes.appColor
                                          : ColorsRes.grey,
                                      context: context,
                                      position: RelativeRect.fromLTRB(
                                          0, width * 0.64, 0, 0.0),
                                      items: [
                                        PopupMenuItem<String>(
                                            child: Text(
                                                DemoLocalization.of(context)
                                                    .translate("ENGLISH"),
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            value: '0'),
                                        PopupMenuItem<String>(
                                            child: Text(
                                                DemoLocalization.of(context)
                                                    .translate("FRENCH"),
                                                style: TextStyle(
                                                    color: Colors.white)),
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
                                height: height * 0.055,
                                width: width * 0.20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorsRes.appColor,
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 5,
                                        right: 4,
                                      ),
                                      child: Image.asset(
                                        "assets/images/language_icon.png",
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        DemoLocalization.of(context)
                                            .translate("language"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            .merge(
                                              TextStyle(
                                                color: ColorsRes.textcolor,
                                                fontSize: 8,
                                                fontFamily:
                                                    "Popinns-ExtraLight",
                                                //       fontFamily: lang == true ? 'Arial' : 'MyFont',
                                              ),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned.directional(
                            textDirection: Directionality.of(context),
                            top: width * 0.54,
                            start: width * 0.235,
                            child: GestureDetector(
                              //  onTap: () {},\
                              onTap: () {
                                AdmobService.showInterstitialAd();
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            new BookmarkList()));
                              },
                              child: Container(
                                height: height * 0.055,
                                width: width * 0.20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorsRes.appColor,
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        right: 4,
                                      ),
                                      child: Image.asset(
                                        "assets/images/bookmark_selected.png",
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        DemoLocalization.of(context)
                                            .translate("bookMark"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            .merge(
                                              TextStyle(
                                                color: ColorsRes.textcolor,
                                                fontSize: 8,
                                                fontFamily:
                                                    "Popinns-ExtraLight",
                                                //       fontFamily: lang == true ? 'Arial' : 'MyFont',
                                              ),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned.directional(
                            textDirection: Directionality.of(context),
                            top: width * 0.54,
                            start: width * 0.45,
                            child: GestureDetector(
                              onTap: () async {
                                print("Titleeeee $title");
                                print("check==/=" + ccatid.toString());

                                await getTitle();
                                await getIndicator();
                                print("Titleeeee $title");
                                print("check==/=" + ccatid.toString());
                                setState(() {});
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
                                        DemoLocalization.of(context)
                                            .translate("Indicator not set !"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: ColorsRes.white,
                                            fontFamily: 'Times new Roman'),
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
                                  ).then(
                                    (value) {
                                      setState(
                                        () {
                                          xOffset = 0;
                                          yOffset = 0;
                                          scaleFactor = 1;
                                          isDrawerOpen = false;
                                        },
                                      );
                                    },
                                  );
                                }
                              },
                              child: Container(
                                height: height * 0.055,
                                width: width * 0.20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorsRes.appColor,
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        right: 4,
                                      ),
                                      child: ccatid == null
                                          ? Image.asset(
                                              "assets/images/pinned_unselected.png",
                                            )
                                          : Image.asset(
                                              "assets/images/pinned_selected.png",
                                            ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        DemoLocalization.of(context)
                                            .translate("pinned"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            .merge(
                                              TextStyle(
                                                color: ColorsRes.textcolor,
                                                fontSize: 8,
                                                fontFamily:
                                                    "Popinns-ExtraLight",
                                              ),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.61,
                      width: MediaQuery.of(context).size.width,
                      color:
                          dark_mode ? ColorsRes.white : ColorsRes.grey1, //grey1
                      child: Stack(
                        children: [
                          FutureBuilder(
                            //Fetching all the chapters from the list using the istance of the DatabaseHelper class
                            future: instance.getDetail(widget.id),
                            builder: (context, index) {
                              //Checking if we got data or not from the DB
                              return ListView.builder(
                                itemCount: _notesForDisplay.length,
                                itemBuilder: (context, index) {
                                  var item = _notesForDisplay[index++];

                                  Last_Chapter = _notesForDisplay.length;

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        book_notcomplete = true;
                                      });
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                            id1: item.Id,
                                            title: item.Chapter,
                                          ),
                                        ),
                                      ).then(
                                        (value) {
                                          print("test dark_mode");
                                          print(dark_mode);
                                          setState(
                                            () {
                                              xOffset = 0;
                                              yOffset = 0;
                                              scaleFactor = 1;
                                              isDrawerOpen = false;
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Container(
                                        height: height * 0.16, //100
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(30.0),
                                            topLeft: Radius.circular(30.0),
                                          ),
                                          color: dark_mode
                                              ? ColorsRes.white
                                              : ColorsRes.grey1, //grey1
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Colors.black,
                                              blurRadius: 8.0,
                                              spreadRadius: -8,
                                              offset: Offset(1, -4),
                                              //offset: Offset(0.0, 1.0), //(x,y)
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 20.0,
                                            right: 20.0,
                                            left: 20.0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  (() {
                                                    if (query == null ||
                                                        query.isEmpty) {
                                                      return Expanded(
                                                        child: Text(
                                                          () {
                                                            if (Language_flag ==
                                                                "en") {
                                                              return item
                                                                  .Chapter;
                                                            } else if (Language_flag ==
                                                                "fr") {
                                                              return item
                                                                  .fr_Chapter;
                                                            } else {
                                                              return item
                                                                  .Chapter;
                                                            }
                                                          }(),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: ColorsRes
                                                                .appColor,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      );
                                                    } else
                                                      return Text("$index.");
                                                  }()),

                                                  // highlightOccurrences(item.Title, query),
                                                  //Icon(Icons.ac_unit),

                                                  Image.asset(
                                                    "assets/images/chapter_icon.png",
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: Text(
                                                  () {
                                                    if (Language_flag == "en") {
                                                      return item
                                                          .Short_Description;
                                                    } else if (Language_flag ==
                                                        "fr") {
                                                      return item
                                                          .fr_Short_Description;
                                                    } else {
                                                      return item
                                                          .Short_Description;
                                                    }
                                                  }(),
                                                  //  "${item.Short_Description}",
                                                  style: TextStyle(
                                                    color: dark_mode
                                                        ? ColorsRes.appColor
                                                        : ColorsRes.white,
                                                    // fontFamily: "Poppins",
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          isDrawerOpen
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
              : Container(),
          isDrawerOpen
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
              : Container(),
        ],
      ),
    );
  }

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
