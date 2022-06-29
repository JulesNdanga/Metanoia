import 'dart:ui';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_admob/Helper/ColorsRes.dart';
import 'package:flutter_admob/Helper/String.dart';
import 'package:flutter_admob/Model/bookmark.dart';
import 'package:flutter_admob/Model/detail.dart';
import 'package:flutter_admob/databaseHelper/bookmarkDbHelper.dart';
import 'package:flutter_admob/databaseHelper/dbhelper.dart';
import 'package:flutter_admob/localization/Demo_Localization.dart';
import 'package:flutter_admob/localization/language_constants.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:launch_review/launch_review.dart';
import 'package:lottie/lottie.dart';
import 'package:screen/screen.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'TermFeed/About_Us.dart';
import 'TermFeed/Contact_Us.dart';
import 'TermFeed/Privacy_Policy.dart';
import 'TermFeed/Terms___Conditions.dart';

// ignore: must_be_immutable
class DetailPage extends StatefulWidget {
  int id1;
  String title;
  DetailPage({Key key, this.id1, this.title}) : super(key: key);
  DetailPage1 createState() => DetailPage1();
}

class DetailPage1 extends State<DetailPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  final key = new GlobalKey<ScaffoldState>();
  detail item;

//==============================================================================
// --------------------------- 1... Pinned -------------------------------------
  int ccatId;
  int catId = 0;
  String pinned_icon = "pinned_unselected";
  //indicator move to main page
  setCategory(int catID) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("Category", catID);
  }

  //set title for indicator page
  setTitle(String title) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("Title", title);
  }

  //set indicator in current page
  setIndicator() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setInt("In", ccatId);
  }

  getIndicator() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt("In");
  }

//indicator
  setDataIndic() async {
    getIndicator().then((value) {
      setState(() {
        ccatId = value;
        setIconIndic();
      });
    });
  }

//indicator icon
  setIconIndic() async {
    if (ccatId != widget.id1) {
      setState(
        () {
          pinned_icon = "pinned_unselected"; // unselected
        },
      );
    } else {
      setState(
        () {
          pinned_icon = "pinned_selected"; // selected
        },
      );
    }
  }

//==============================================================================
// --------------------------- 1... BookMark -----------------------------------

  Bookmark book;
  bool bmark = true;
  int bbmarkId;
  String bookmark_icon = "bookmark_unselected";

  static final bookmarkHelper instance1 = bookmarkHelper.privateConstructor();

  //get bookmarkIcon
  _restorebmark() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("bookmark") ?? true;
  }

  //set bookmarkIcon
  _bmark() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool("bookmark", bmark);
  }

  setBookmarkId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setInt("bb", bbmarkId);
  }

  getBookmarkId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt("bb");
  }

  setDataBmark() async {
    getBookmarkId().then(
      (value) {
        setState(
          () {
            bbmarkId = value;
          },
        );
      },
    );
  }

  setDataBmark1() async {
    _restorebmark().then(
      (value) {
        setState(
          () {
            bmark = value;
            setIconBmark();
          },
        );
      },
    );
  }

  setIconBmark() async {
    if (bbmarkId == widget.id1) {
      if (bmark) {
        setState(
          () {
            bookmark_icon = "bookmark_unselected"; // unselected
          },
        );
      } else {
        setState(
          () {
            bookmark_icon = "bookmark_selected"; // selected
          },
        );
      }
    }
  }
//==============================================================================
// --------------------------- 1... brightness ---------------------------------

  double brightness = 0.1;

  getBrightnessSlider() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getDouble('brightness');
  }

  brightnessSet() async {
    brightness = await Screen.brightness;
    setState(
      () {
        brightness = brightness;
      },
    );
  }

  Future<Null> showBrightness() async {
    return showDialog<Null>(
      context: context,
      builder: (_) {
        return FittedBox(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: dark_mode ? ColorsRes.appColor : ColorsRes.grey,
            insetPadding: EdgeInsets.symmetric(horizontal: 70, vertical: 350),
            content: StatefulBuilder(
              builder: (context, state) => FittedBox(
                child: Column(
                  children: [
                    Text(
                      DemoLocalization.of(context).translate("Brightness"),
                      style: TextStyle(
                        color: ColorsRes.white,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Slider(
                      value: brightness,
                      divisions: 6,
                      inactiveColor: ColorsRes.white,
                      activeColor: ColorsRes.white,
                      onChanged: (double b) {
                        state(
                          () {
                            setState(
                              () {
                                brightness = b;
                              },
                            );
                            Screen.setBrightness(b);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

//===================================================================================
// --------------------------- 2. Font Color ---------------------------------------------

  Color _tempMainColor, _mainColor = dark_mode ? Colors.black : Colors.white;

  setColorSlider() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setInt('Color', _mainColor.value);
  }

  getColorSlider() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Color myColor = Color(preferences.getInt('Color') ?? _mainColor.value);
    return myColor;
  }

  colorPicker() async {
    getColorSlider().then(
      (value) {
        setState(
          () {
            _mainColor = value;
          },
        );
      },
    );
  }

  void _fontDialog() async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: dark_mode ? ColorsRes.appColor : ColorsRes.grey,
          title: Text(
            DemoLocalization.of(context).translate("Set color"),
            style: TextStyle(
              fontSize: 18,
              color: ColorsRes.white,
            ),
          ),
          content: Container(
            height: height * 0.3,
            child: MaterialColorPicker(
              onMainColorChange: (color) =>
                  setState(() => _tempMainColor = color),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                DemoLocalization.of(context).translate("Cancel"),
                style: TextStyle(
                  color: ColorsRes.white,
                  fontSize: 18,
                ),
              ),
              onPressed: Navigator.of(context).pop,
            ),
            TextButton(
              child: Text(
                DemoLocalization.of(context).translate("Submit"),
                style: TextStyle(
                  color: ColorsRes.white,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _mainColor = _tempMainColor);
                setColorSlider();
              },
            ),
          ],
        );
      },
    );
  }

//===================================================================================
// --------------------------- 3. Text Size ---------------------------------------------

  double _fontSize = 18;

  setFontSlider() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setDouble('Font', _fontSize);
    print("font size  ============ $_fontSize");
  }

  getFontSlider() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getDouble('Font');
  }

  fontSize() async {
    getFontSlider().then(
      (value) {
        setState(
          () {
            _fontSize = value;
          },
        );
      },
    );
  }

  void showFont() async {
    showDialog(
      context: context,
      builder: (_) {
        return FittedBox(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: dark_mode ? ColorsRes.appColor : ColorsRes.grey,
            insetPadding: EdgeInsets.symmetric(horizontal: 70, vertical: 300),
            content: StatefulBuilder(
              builder: (context, state) => FittedBox(
                child: Column(
                  children: [
                    Text(
                      DemoLocalization.of(context)
                          .translate("Change font Size"),
                      style: TextStyle(
                        color: ColorsRes.white,
                        fontSize: 20,
                      ),
                    ),
                    Slider(
                      label: (_fontSize ?? 18).toStringAsFixed(0),
                      value: _fontSize ?? 18,
                      activeColor: ColorsRes.white,
                      min: 15,
                      max: 40,
                      divisions: 10,
                      inactiveColor: ColorsRes.white,
                      onChanged: (value) {
                        state(
                          () {
                            setState(
                              () {
                                _fontSize = value;
                                Fontsize_for_read_along = _fontSize;
                                setFontSlider();
                              },
                            );
                          },
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setFontSlider();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        DemoLocalization.of(context).translate("Done"),
                      ),
                      style: ButtonStyle(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

//===================================================================================
// --------------------------- 4. Text Alighment ---------------------------------------------

  int text_alighn = 3;
  setAlighment() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('text_alighn', text_alighn);
    print("font size");
  }

  getAlighment() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt('text_alighn');
  }

  Alighnment() async {
    getAlighment().then(
      (value) {
        setState(
          () {
            print("test value");
            print(value);
            text_alighn = value ?? 3;
          },
        );
      },
    );
  }

  void showTextAlighment() async {
    showDialog(
      context: context,
      builder: (_) {
        return FittedBox(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: dark_mode ? ColorsRes.appColor : ColorsRes.grey,
            insetPadding: EdgeInsets.symmetric(horizontal: 70, vertical: 300),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DemoLocalization.of(context)
                            .translate("Change TextAlignment"),
                        style: TextStyle(
                          fontSize: 40,
                          color: ColorsRes.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        text_alighn = 0;
                        setAlighment();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        Image.asset(
                          "assets/images/center_align.png",
                          fit: BoxFit.cover,
                          height: 25,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          DemoLocalization.of(context)
                              .translate("Alignment Center"),
                          style: TextStyle(
                            fontSize: 40,
                            color: ColorsRes.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        text_alighn = 1;
                        setAlighment();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        Image.asset(
                          "assets/images/right_align.png",
                          fit: BoxFit.cover,
                          height: 25,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          DemoLocalization.of(context)
                              .translate("Alignment Right"),
                          style: TextStyle(
                            fontSize: 40,
                            color: ColorsRes.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        text_alighn = 2;
                        setAlighment();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        Image.asset(
                          "assets/images/left_align.png",
                          fit: BoxFit.cover,
                          height: 25,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          DemoLocalization.of(context)
                              .translate("Alignment left"),
                          style: TextStyle(
                            fontSize: 40,
                            color: ColorsRes.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        text_alighn = 3;
                        setAlighment();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        Image.asset(
                          "assets/images/justify_align.png",
                          fit: BoxFit.cover,
                          height: 25,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          DemoLocalization.of(context)
                              .translate("Alignment Justify"),
                          style: TextStyle(
                            fontSize: 40,
                            color: ColorsRes.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

//===================================================================================
// --------------------------- 5. Line & Latter Spacing  ---------------------------------------------

  double _linespacing = 1;
  //LineSpacing

  setLineSpacingSlider() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setDouble('linespacing', _linespacing);
  }

  getLineSpacingSlider() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getDouble('linespacing');
  }

  LineSpacing() async {
    getLineSpacingSlider().then(
      (value) {
        setState(
          () {
            _linespacing = value ?? 1;
            Linespacing_for_read_along = _linespacing;
          },
        );
      },
    );
  }

  double lattersapcing = 1;
  //LatterSpacing

  setLatterSpacingSlider() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setDouble('linespacing', lattersapcing);
  }

  getLatterSpacingSlider() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getDouble('linespacing');
  }

  LatterSpacing() async {
    getLatterSpacingSlider().then(
      (value) {
        setState(
          () {
            lattersapcing = value ?? 1;
          },
        );
      },
    );
  }

  Future lineSpacing() async {
    return showDialog<Null>(
      context: context,
      builder: (_) {
        return FittedBox(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: dark_mode ? ColorsRes.appColor : ColorsRes.grey,
            insetPadding: EdgeInsets.symmetric(horizontal: 70, vertical: 350),
            content: StatefulBuilder(
              builder: (context, state) => FittedBox(
                child: Column(
                  children: [
                    Text(
                      DemoLocalization.of(context).translate("Line Spacing"),
                      style: TextStyle(
                        fontSize: 25,
                        color: ColorsRes.white,
                      ),
                    ),
                    Divider(
                      height: 10,
                    ),
                    Slider(
                      value: _linespacing,
                      min: 1,
                      max: 5,
                      inactiveColor: ColorsRes.white,
                      activeColor: ColorsRes.white,
                      onChanged: (double b) {
                        state(
                          () {
                            setState(
                              () {
                                _linespacing = b;
                                Linespacing_for_read_along = _linespacing;
                                setLineSpacingSlider();
                              },
                            );
                          },
                        );
                      },
                    ),
                    Divider(
                      height: 10,
                    ),
                    Text(
                      DemoLocalization.of(context).translate("Latter Spacing"),
                      style: TextStyle(
                        fontSize: 25,
                        color: ColorsRes.white,
                      ),
                    ),
                    Divider(
                      height: 10,
                    ),
                    Slider(
                      value: lattersapcing,
                      min: 0,
                      max: 4,
                      inactiveColor: ColorsRes.white,
                      //     divisions: 5,
                      activeColor: ColorsRes.white,
                      onChanged: (double b) {
                        state(
                          () {
                            setState(
                              () {
                                lattersapcing = b;
                                Lattersapcing_for_read_along = lattersapcing;
                                setLatterSpacingSlider();
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

//===================================================================================
// --------------------------- 5. Auto Scroll ---------------------------------------

  bool _isVisible = false;
  ScrollController _scrollController = ScrollController();
  double speedFactor = 15;
  bool scrollText = true, scroll = false;
  bool navbar_visible = false;
  //scroll content
  _scroll() {
    double maxExtent = _scrollController.position.maxScrollExtent;
    double distanceDifference = maxExtent - _scrollController.offset;
    double durationDouble = distanceDifference / speedFactor;

    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: durationDouble.toInt()),
        curve: Curves.linear);
  }

  _toggleScrolling() {
    setState(() {
      scroll = !scroll;
    });

    if (scroll) {
      _scroll();
    } else {
      _scrollController.animateTo(_scrollController.offset,
          duration: Duration(seconds: 10), curve: Curves.linear);
    }
  }

//===================================================================================
// --------------------------- 6. Text To Speech ------------------------------------

  final FlutterTts fluttertts = FlutterTts();
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print("inside didchangeAppLifecycle =================");
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('appLifeCycleState inactive');
        await fluttertts.stop();
        setState(() {
          print("inside setState");
          play = false;
        });

        break;
      case AppLifecycleState.resumed:
        print('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        print('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        print('appLifeCycleState detached');
        break;
    }
  }

  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool play = false;

  Future TextToSpeech() async {
    return showDialog<Null>(
      context: context,
      builder: (_) {
        return FittedBox(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: dark_mode ? ColorsRes.appColor : ColorsRes.grey,
            insetPadding: EdgeInsets.symmetric(horizontal: 70, vertical: 350),
            content: StatefulBuilder(
              builder: (context, state) => FittedBox(
                child: Column(
                  children: [
                    Text(
                      "Volume",
                      style: TextStyle(
                        fontSize: 25,
                        color: ColorsRes.white,
                      ),
                    ),
                    Divider(
                      height: 10,
                    ),
                    Slider(
                      value: volume,
                      min: 0.0,
                      max: 1.0,
                      inactiveColor: ColorsRes.white,
                      activeColor: ColorsRes.white,
                      onChanged: (double newVolume) {
                        state(
                          () {
                            setState(
                              () {
                                volume = newVolume;
                              },
                            );
                          },
                        );
                      },
                    ),
                    Divider(
                      height: 10,
                    ),
                    Text(
                      "Pitch",
                      style: TextStyle(
                        fontSize: 25,
                        color: ColorsRes.white,
                      ),
                    ),
                    Divider(
                      height: 10,
                    ),
                    Slider(
                      value: pitch,
                      min: 0.5,
                      max: 2.0,
                      inactiveColor: ColorsRes.white,
                      activeColor: ColorsRes.white,
                      onChanged: (double changePitch) {
                        state(
                          () {
                            setState(
                              () {
                                pitch = changePitch;
                              },
                            );
                          },
                        );
                      },
                    ),
                    Text(
                      "Rate",
                      style: TextStyle(
                        fontSize: 25,
                        color: ColorsRes.white,
                      ),
                    ),
                    Divider(
                      height: 10,
                    ),
                    Slider(
                      value: rate,
                      min: 0.0,
                      max: 1.0,
                      inactiveColor: ColorsRes.white,
                      activeColor: ColorsRes.white,
                      onChanged: (double changeRate) {
                        state(
                          () {
                            setState(
                              () {
                                rate = changeRate;
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

//===================================================================================
// --------------------------- 7. Read Along With Text ---------------------------------------------

  bool read_along_text_on = false;
  int currentLine = -1;
  List<LineMetrics> lineMetrics = [];
  final List<TextSpan> children = [];
  Timer timer;
  List<AnimationController> animationControllers = [];
  int milliseconds = 5000;

  void getLineMatrix() {
    print("Fontsize_for_read_along ::: ");
    print(Fontsize_for_read_along);
    final textPainter = TextPainter(
        text: TextSpan(
          text: detailtext,
          style: TextStyle(
            fontSize: Fontsize_for_read_along, //18,
            color: Colors.black,
            letterSpacing: Lattersapcing_for_read_along,
            height: Linespacing_for_read_along,
          ),
        ),
        textDirection: TextDirection.ltr);
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);
    setState(
      () {
        lineMetrics = textPainter.computeLineMetrics();
        currentLine = 0;
        lineMetrics.forEach(
          (element) {
            animationControllers.add(
              AnimationController(
                vsync: this,
                duration: Duration(
                  milliseconds: milliseconds,
                ),
              ),
            );
          },
        );
      },
    );
    //
    animationControllers.first.forward();
    //
    timer = Timer.periodic(
      Duration(milliseconds: milliseconds + 150),
      (timer) {
        if (currentLine == (lineMetrics.length - 1)) {
          timer.cancel();
        } else {
          currentLine++;
          animationControllers[currentLine].forward();
        }
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    animationControllers.forEach(
      (element) {
        element.dispose();
      },
    );
    super.dispose();
    fluttertts.stop();
  }

  //Container desingn

  Widget _buildBackgroundHighlightContainers() {
    return currentLine == -1
        ? Container()
        : Positioned(
            left: 0.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lineMetrics.map(
                (e) {
                  return AnimatedBuilder(
                    animation: animationControllers[e.lineNumber],
                    builder: (context, child) {
                      return Container(
                        height: e.height,
                        width: width * animationControllers[e.lineNumber].value,
                        color: dark_mode
                            ? ColorsRes.textcolor
                            : ColorsRes.appColor,
                      );
                    },
                  );
                },
              ).toList(),
            ),
          );
  }

  void ReadAlongWithText() async {
    showDialog(
      context: context,
      builder: (_) {
        return FittedBox(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: dark_mode ? ColorsRes.appColor : ColorsRes.grey,
            insetPadding: EdgeInsets.symmetric(horizontal: 70, vertical: 300),
            content: StatefulBuilder(
              builder: (context, state) => FittedBox(
                child: Column(
                  children: [
                    Text(
                      DemoLocalization.of(context).translate("Adjust Speed"),
                      style: TextStyle(
                        color: ColorsRes.white,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Slider(
                      label: DemoLocalization.of(context)
                          .translate("Decrement ->"),
                      value: (milliseconds).toDouble(),
                      activeColor: ColorsRes.white,
                      min: 2000,
                      max: 8000,
                      divisions: 7,
                      inactiveColor: ColorsRes.white,
                      onChanged: (value) {
                        state(
                          () {
                            setState(
                              () {
                                milliseconds = (value).toInt();
                              },
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        read_along_text_on = true;
                        Navigator.of(context).pop();
                        getLineMatrix();
                      },
                      child: Text(
                        DemoLocalization.of(context).translate("Start"),
                      ),
                      style: ButtonStyle(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

//===================================================================================
// --------------------------- 8. Reset ---------------------------------------------

  resets() async {
    SharedPreferences prefrences = await SharedPreferences.getInstance();
    await prefrences.remove('Color');
    await prefrences.remove('Font');
    await prefrences.remove('brightness');
    await prefrences.remove('linespacing');
    await prefrences.remove('lattersapcing');
    setState(
      () {
        _mainColor = dark_mode ? ColorsRes.black : Colors.white; //Colors.black;
        _fontSize = 18;
        Screen.setBrightness(0.03);
        _linespacing = 1;
        lattersapcing = 1;
        text_alighn = 3;
        navbar_visible = false;
        pitch = 1.0;
        volume = 0.5;
        rate = 0.5;
        play = false;
        currentLine = -1;
        milliseconds = 5000;
        fluttertts.stop();
      },
    );
  }

  void reset() async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: dark_mode ? ColorsRes.appColor : ColorsRes.grey,
          insetPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 100),
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: DemoLocalization.of(context)
                  .translate("Conform Reset operations"),
              style: TextStyle(
                color: ColorsRes.white,
                fontSize: 20,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: DemoLocalization.of(context).translate("Are you sure"),
                  style: TextStyle(
                    color: ColorsRes.white,
                    fontSize: 18,
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                DemoLocalization.of(context).translate("No"),
                style: TextStyle(
                  color: ColorsRes.white,
                  fontSize: 18,
                ),
              ),
              onPressed: Navigator.of(context).pop,
            ),
            TextButton(
              child: Text(
                DemoLocalization.of(context).translate("Yes"),
                style: TextStyle(
                  color: ColorsRes.white,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                resets();
              },
            ),
          ],
        );
      },
    );
  }

//===================================================================================
// --------------------------- Search Logic -----------------------------------------

  TextEditingController _textController = TextEditingController();
  bool typing = false;
  String source, query;
  List<TextSpan> highlightOccurrences(source, query) {
    if (query == null || query.isEmpty) {
      return [
        TextSpan(text: source),
      ];
    }

    var matches = <Match>[];
    for (final token in query.trim().toLowerCase().split(' ')) {
      matches.addAll(
        token.allMatches(
          source.toLowerCase(),
        ),
      );
    }
    if (matches.isEmpty) {
      return [
        TextSpan(text: source),
      ];
    }
    matches.sort(
      (a, b) => a.start.compareTo(b.start),
    );
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
              backgroundColor: ColorsRes.appColor,
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
            text: source.substring(match.start, match.end),
            style: TextStyle(
              backgroundColor: ColorsRes.appColor,
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

//===================================================================================
// ----------------------------------------------------------------------------------

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    brightnessSet();
    setDataIndic();
    setDataBmark();
    setDataBmark1();
    getBrightnessSlider();
    colorPicker();
    fontSize();
    Alighnment();
    LineSpacing();
    LatterSpacing();
    _scrollController.addListener(
      () {
        setState(
          () {
            _isVisible = _scrollController.position.userScrollDirection ==
                ScrollDirection.forward;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
//=====================================================================
//--------------------- text to audio ---------------------------------

    speak(String Description) async {
      await fluttertts.setVolume(volume);
      await fluttertts.setSpeechRate(rate);
      await fluttertts.setPitch(pitch);
      await fluttertts.getLanguages;
      print("length of string : ${Description.length}");
      List<dynamic> languages = await fluttertts.getLanguages;
      print(languages);
      await fluttertts.setLanguage(() {
        if (Language_flag == "en") {
          return "en-IN";
        } else if (Language_flag == "fr") {
          return "fr-FR";
        } else {
          return "fr-FR";
        }
      }());
      int length = Description.length;
      if (length < 4000) {
        print("inrange of 4000");
        await fluttertts.speak(Description);
        fluttertts.setCompletionHandler(() {
          fluttertts.stop();
          play = false;
        }());
      } else if (length < 8000) {
        print("inrange of 8000");
        String temp1 = Description.substring(0, length ~/ 2);
        print(temp1.length);
        await fluttertts.speak(temp1);
        fluttertts.setCompletionHandler(() {}());
        String temp2 = Description.substring(temp1.length, Description.length);

        await fluttertts.speak(temp2);
        fluttertts.setCompletionHandler(() {
          play = false;
        }());
      } else if (length < 12000) {
        print("inrange of 12000");
        String temp1 = Description.substring(0, 3999);
        await fluttertts.speak(temp1);
        fluttertts.setCompletionHandler(() {}());
        String temp2 = Description.substring(temp1.length, 7999);
        await fluttertts.speak(temp2);
        fluttertts.setCompletionHandler(() {}());
        String temp3 = Description.substring(temp2.length, Description.length);
        await fluttertts.speak(temp3);
        fluttertts.setCompletionHandler(() {
          play = false;
          print("execution complete");
        }());
      }
    }

    stop() async {
      await fluttertts.stop();
    }

//=====================================================================
//--------------------- Body Part Start here --------------------------

    return Scaffold(
      key: key,
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
                                child: Image.asset(
                                    "assets/images/splash_logo.png")),
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
                                DemoLocalization.of(context)
                                    .translate("Explore"),
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
                                    setState(
                                      () {
                                        _mainColor = dark_mode
                                            ? ColorsRes.white
                                            : Colors.black;
                                      },
                                    );
                                    //  dark_mode = !dark_mode;
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
                                  Image.asset(
                                      "assets/images/termscond_icon.png"),
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
                                setState(
                                  () {
                                    Share.share(
                                        'https://play.google.com/store/apps/details? id=com.book.reading'); //Modifier ici plutard après publication
                                  },
                                );
                              },
                            ),
                            ListTile(
                              title: Row(
                                children: [
                                  Image.asset(
                                      "assets/images/contactus_icon.png"),
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
                                        builder: (context) =>
                                            new Contact_Us()));
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
                                    builder: (context) => new About_Us(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                                child: Image.asset(
                                    "assets/images/splash_logo.png")),
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
                                DemoLocalization.of(context)
                                    .translate("Explore"),
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
                                setState(
                                  () {
                                    _mainColor = dark_mode
                                        ? ColorsRes.white
                                        : Colors.black;
                                  },
                                );
                                if (dark_mode == true) {
                                  setState(
                                    () {
                                      dark_mode = false;
                                      setDarkMode(dark_mode);
                                    },
                                  );
                                } else {
                                  setState(
                                    () {
                                      dark_mode = true;
                                      setDarkMode(dark_mode);
                                    },
                                  );
                                }
                              },
                            ),
                            ListTile(
                              title: Row(
                                children: [
                                  Image.asset(
                                      "assets/images/termscond_icon.png"),
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
                                setState(
                                  () {
                                    Share.share(
                                        'https://play.google.com/store/apps/details? id=com.book.reading');
                                  },
                                );
                              },
                            ),
                            ListTile(
                              title: Row(
                                children: [
                                  Image.asset(
                                      "assets/images/contactus_icon.png"),
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
                                        builder: (context) =>
                                            new Contact_Us()));
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
                    ],
                  ),
                ),
          AnimatedContainer(
            duration: Duration(milliseconds: 250),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scaleFactor)
              ..rotateY(isDrawerOpen ? -0.5 : 0),
            decoration: BoxDecoration(
              color: dark_mode ? Colors.grey[100] : ColorsRes.grey, //grey1
              boxShadow: [
                BoxShadow(
                  blurRadius: 60,
                  color: ColorsRes.appColor.withOpacity(0.9),
                  offset: Offset(1, 3),
                ),
              ], //
              borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0),
              child: Column(
                children: [
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
                            color:
                                dark_mode ? ColorsRes.white : ColorsRes.grey1,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  setState(
                                                    () {
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
                                                        navbar_visible =
                                                            false; // for navigation bar close
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                        typing
                                            ? Container(
                                                height: height * 0.055,
                                                width: width * 0.5,
                                                margin: EdgeInsets.only(top: 5),
                                                child: Center(
                                                  child: TextField(
                                                    style: TextStyle(
                                                        color: dark_mode
                                                            ? ColorsRes.appColor
                                                            : ColorsRes.white,
                                                        fontSize: 18),
                                                    cursorColor:
                                                        ColorsRes.appColor,
                                                    autofocus: true,
                                                    controller: _textController,
                                                    decoration:
                                                        new InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: DemoLocalization
                                                              .of(context)
                                                          .translate("Search"),
                                                      hintStyle: TextStyle(
                                                          color: ColorsRes
                                                              .appColor,
                                                          fontSize: 18),
                                                    ),
                                                    onChanged: (text) {
                                                      text = text.toLowerCase();
                                                      setState(
                                                        () {
                                                          query = text;
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                DemoLocalization.of(context)
                                                    .translate("appName"),
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: ColorsRes.appColor,
                                                    fontFamily: "Poppins",
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                        IconButton(
                                          icon: typing
                                              ? Icon(
                                                  Icons.clear,
                                                  color: ColorsRes.appColor,
                                                )
                                              : Image.asset(
                                                  "assets/images/search_icon.png",
                                                ),
                                          onPressed: () {
                                            _textController.clear();
                                            query = "";
                                            setState(
                                              () {
                                                typing = !typing;
                                              },
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
                                          style: TextStyle(
                                            color: ColorsRes.appColor,
                                            fontSize: 20,
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
                                              : ColorsRes.white,
                                        ),
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
                          top: height * 0.111,
                          start: width * 0.66,
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
                                              color: Colors.white,
                                            ),
                                          ),
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
                                          play = false;
                                          stop();
                                          changeLanguage(context, "en");
                                        });
                                      } else if (itemSelected == "1") {
                                        print("FRENCH");
                                        setState(() async {
                                          play = false;
                                          stop();
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
                                              fontFamily: "Popinns-ExtraLight",
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
                            onTap: () {
                              print("bbmarkId : $bbmarkId");
                              print("bmark : $bmark");
                              print("widget.id1 : ${widget.id1}");

                              if (bbmarkId == widget.id1) {
                                if (bmark) {
                                  bmark = false;

                                  setBookmarkId();
                                  _bmark();
                                  setIconBmark();
                                  Bookmark bookmark =
                                      new Bookmark(v_id: widget.id1);
                                  print("--/==" + widget.id1.toString());
                                  instance1.insertIntoDb(widget.id1);
                                } else {
                                  print("inside else statement");
                                  bmark = true;

                                  _bmark();
                                  setBookmarkId();
                                  setIconBmark();

                                  Bookmark bookmark =
                                      new Bookmark(v_id: widget.id1);
                                  print("****" + widget.id1.toString());
                                  instance1.delete_id(widget.id1);
                                }
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
                                    child: Image.asset(
                                      "assets/images/$bookmark_icon.png",
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
                                              fontFamily: "Popinns-ExtraLight",
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
                            onTap: () {
                              print("ccatId : $ccatId");
                              print("widget.id1 : ${widget.id1}");
                              if (ccatId == widget.id1) {
                                print("in if part");
                                setIndicator();
                                setIconIndic();
                                print("catId : $catId");
                                setCategory(catId);
                                print("widget.title : ${widget.title}");
                                setTitle(widget.title);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  new SnackBar(
                                    margin: EdgeInsets.all(70),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                    ),
                                    duration: Duration(seconds: 1),
                                    content: new Text(
                                      "Indicator set Successful !",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Times new Roman'),
                                    ),
                                  ),
                                );
                              } else {
                                print("else part");
                                setIndicator();
                                setState(() {
                                  getIndicator();
                                  setIconIndic();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  new SnackBar(
                                    margin: EdgeInsets.all(70),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    duration: Duration(seconds: 1),
                                    content: new Text(
                                      "Remove  Successful !",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Times new Roman'),
                                    ),
                                  ),
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
                                    child: Image.asset(
                                      "assets/images/$pinned_icon.png",
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
                                              fontFamily: "Popinns-ExtraLight",
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
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      controller: _scrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      child: book_notcomplete
                          ? FutureBuilder(
                              //Fetching all the persons from the list using the istance of the DatabaseHelper class
                              future: instance.getDetail1(widget.id1),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                //Checking if we got data or not from the DB
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    //   controller: _scrollController,
                                    itemCount: snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      item = snapshot.data[index];
                                      catId = item.Category_Id;
                                      ccatId = item.Id;
                                      bbmarkId = item.Id;

                                      Author_name = item.en_Author_name;
                                      fr_Author_name = item.fr_Author_name;

                                      //total chapter
                                      chapter_total = item.Chapter_Total;
                                      // Book_name
                                      en_Title = item.Title;
                                      fr_Title = item.fr_Title;

                                      //book=item.Id;
                                      return Column(
                                        children: [
                                          Container(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(30.0),
                                                  topLeft:
                                                      Radius.circular(30.0),
                                                  bottomLeft:
                                                      Radius.circular(30.0),
                                                  bottomRight:
                                                      Radius.circular(30.0),
                                                ),
                                                color: dark_mode
                                                    ? ColorsRes.white
                                                    : ColorsRes
                                                        .grey1, //for detail
                                              ),
                                              child: ListTile(
                                                title: new Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
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
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  color: ColorsRes
                                                                      .appColor,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                GestureDetector(
                                                                  child: Image
                                                                      .asset(
                                                                          "assets/images/setting_icon.png"),
                                                                  onTap: () {
                                                                    if (read_along_text_on ==
                                                                        true) {
                                                                      setState(
                                                                        () {
                                                                          read_along_text_on =
                                                                              false;
                                                                          timer
                                                                              ?.cancel();
                                                                          animationControllers
                                                                              .forEach(
                                                                            (element) {
                                                                              element.reset();
                                                                            },
                                                                          );
                                                                        },
                                                                      );
                                                                    }
                                                                    showMenu<
                                                                        String>(
                                                                      color: dark_mode
                                                                          ? ColorsRes
                                                                              .appColor
                                                                          : ColorsRes
                                                                              .grey,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0),
                                                                        ),
                                                                      ),
                                                                      context:
                                                                          context,
                                                                      position: RelativeRect.fromLTRB(
                                                                          width,
                                                                          width,
                                                                          0.0,
                                                                          0.0),
                                                                      items: [
                                                                        PopupMenuItem<
                                                                                String>(
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Image.asset("assets/images/brightness_icon.png"),
                                                                                SizedBox(
                                                                                  width: 35,
                                                                                ),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    DemoLocalization.of(context).translate("Brightness"),
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            value:
                                                                                '0'),
                                                                        PopupMenuItem<
                                                                                String>(
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Image.asset("assets/images/fontcolor_icon.png"),
                                                                                SizedBox(
                                                                                  width: 35,
                                                                                ),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    DemoLocalization.of(context).translate("Font color"),
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            value:
                                                                                '1'),
                                                                        PopupMenuItem<
                                                                                String>(
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Image.asset("assets/images/textsize_icon.png"),
                                                                                SizedBox(
                                                                                  width: 35,
                                                                                ),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    DemoLocalization.of(context).translate("Text Size"),
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            value:
                                                                                '2'),
                                                                        PopupMenuItem<
                                                                                String>(
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Image.asset("assets/images/Text alignment_icon.png"),
                                                                                SizedBox(
                                                                                  width: 35,
                                                                                ),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    DemoLocalization.of(context).translate("Text Alighment"),
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            value:
                                                                                '3'),
                                                                        PopupMenuItem<
                                                                                String>(
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Image.asset("assets/images/loose_icon.png"),
                                                                                SizedBox(
                                                                                  width: 35,
                                                                                ),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    DemoLocalization.of(context).translate("Line Spacing"),
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            value:
                                                                                '4'),
                                                                        PopupMenuItem<
                                                                                String>(
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Image.asset("assets/images/scroll_icon.png"),
                                                                                SizedBox(
                                                                                  width: 35,
                                                                                ),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    DemoLocalization.of(context).translate("Auto Scroll"),
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            value:
                                                                                '5'),
                                                                        PopupMenuItem<
                                                                                String>(
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Image.asset("assets/images/textspeech_icon.png"),
                                                                                SizedBox(
                                                                                  width: 35,
                                                                                ),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    DemoLocalization.of(context).translate("Text To Speech"),
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                                play
                                                                                    ? AbsorbPointer(
                                                                                        absorbing: false,
                                                                                        child: GestureDetector(
                                                                                          child: Image.asset(
                                                                                            "assets/images/2.0x/toggle_on.png",
                                                                                          ),
                                                                                          onTap: () {
                                                                                            setState(
                                                                                              () {
                                                                                                play = false;
                                                                                                stop();
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      )
                                                                                    : AbsorbPointer(
                                                                                        absorbing: false,
                                                                                        child: GestureDetector(
                                                                                          child: Image.asset(
                                                                                            "assets/images/2.0x/toggle_off.png",
                                                                                          ),
                                                                                          onTap: () {
                                                                                            setState(
                                                                                              () {
                                                                                                speak(() {
                                                                                                  if (Language_flag == "en") {
                                                                                                    return item.Description;
                                                                                                  } else if (Language_flag == "fr") {
                                                                                                    return item.fr_Description;
                                                                                                  } else {
                                                                                                    return item.Description;
                                                                                                  }
                                                                                                }());
                                                                                                play = true;
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                              ],
                                                                            ),
                                                                            value:
                                                                                '6'),
                                                                        PopupMenuItem<
                                                                                String>(
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Image.asset("assets/images/readalong_icon.png"),
                                                                                SizedBox(
                                                                                  width: 35,
                                                                                ),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    DemoLocalization.of(context).translate("Read Along Text"),
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            value:
                                                                                '7'),
                                                                        PopupMenuItem<
                                                                            String>(
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.settings,
                                                                                color: Colors.white,
                                                                                size: 22,
                                                                              ),
                                                                              SizedBox(
                                                                                width: 35,
                                                                              ),
                                                                              Expanded(
                                                                                child: Text(
                                                                                  DemoLocalization.of(context).translate("Reset"),
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          value:
                                                                              '8',
                                                                        ),
                                                                      ],
                                                                      elevation:
                                                                          7.0,
                                                                    ).then<
                                                                        void>(
                                                                      (String
                                                                          itemSelected) {
                                                                        if (itemSelected ==
                                                                            null)
                                                                          return;
                                                                        if (itemSelected ==
                                                                            "0") {
                                                                          print(
                                                                              "brightness");
                                                                          showBrightness();
                                                                        } else if (itemSelected ==
                                                                            "1") {
                                                                          print(
                                                                              "FontColor");
                                                                          _fontDialog();
                                                                          setState(
                                                                              () {});
                                                                        } else if (itemSelected ==
                                                                            "2") {
                                                                          print(
                                                                              "textsize");
                                                                          showFont();
                                                                        } else if (itemSelected ==
                                                                            "3") {
                                                                          print(
                                                                              "Text Alighment");
                                                                          showTextAlighment();
                                                                        } else if (itemSelected ==
                                                                            "4") {
                                                                          print(
                                                                              "line spacing");
                                                                          lineSpacing();
                                                                        } else if (itemSelected ==
                                                                            "5") {
                                                                          print(
                                                                              "Auto Scroll");
                                                                          setState(
                                                                              () {
                                                                            currentLine =
                                                                                -1;
                                                                            if (navbar_visible) {
                                                                              setState(() {
                                                                                navbar_visible = false;
                                                                              });
                                                                            } else {
                                                                              setState(() {
                                                                                navbar_visible = true;
                                                                              });
                                                                            }
                                                                          });
                                                                        } else if (itemSelected ==
                                                                            "6") {
                                                                          print(
                                                                              "Text To Speech");
                                                                          TextToSpeech();
                                                                        } else if (itemSelected ==
                                                                            "7") {
                                                                          print(
                                                                              "Read Along With Text");
                                                                          setState(
                                                                              () {
                                                                            // _linespacing =
                                                                            //     1;
                                                                            // lattersapcing =
                                                                            //     1;
                                                                            text_alighn =
                                                                                3;
                                                                            // _fontSize =
                                                                            //     18;
                                                                          });

                                                                          setState(
                                                                              () {});
                                                                          ReadAlongWithText();
                                                                        } else if (itemSelected ==
                                                                            "8") {
                                                                          print(
                                                                              "Reset All Setings");
                                                                          reset();
                                                                        }
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        // for description start here
                                                        Stack(
                                                          children: [
                                                            _buildBackgroundHighlightContainers(),
                                                            RichText(
                                                              //text aligment logic
                                                              textAlign: (() {
                                                                if (text_alighn ==
                                                                    0)
                                                                  return TextAlign
                                                                      .center;
                                                                else if (text_alighn ==
                                                                    1)
                                                                  return TextAlign
                                                                      .right;
                                                                else if (text_alighn ==
                                                                    2)
                                                                  return TextAlign
                                                                      .left;
                                                                else if (text_alighn ==
                                                                    3)
                                                                  return TextAlign
                                                                      .justify;
                                                                // your code here
                                                              }()),
                                                              //item.Description
                                                              text: TextSpan(
                                                                children:
                                                                    highlightOccurrences(
                                                                        () {
                                                                  // Fontsize_for_read_along =
                                                                  //     _fontSize;
                                                                  //Lattersapcing_for_read_along =
                                                                  //    lattersapcing;
                                                                  // Linespacing_for_read_along =
                                                                  //     lattersapcing;
                                                                  if (Language_flag ==
                                                                      "en") {
                                                                    detailtext =
                                                                        item.Description;

                                                                    return item
                                                                        .Description;
                                                                  } else if (Language_flag ==
                                                                      "fr") {
                                                                    detailtext =
                                                                        item.fr_Description;

                                                                    return item
                                                                        .fr_Description;
                                                                  } else {
                                                                    detailtext =
                                                                        item.Description;

                                                                    return item
                                                                        .Description;
                                                                  }
                                                                }(), query),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      _fontSize,
                                                                  color: _mainColor ??
                                                                      Colors
                                                                          .black,
                                                                  height:
                                                                      _linespacing,
                                                                  letterSpacing:
                                                                      lattersapcing,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                if (item.Chapter_Count <
                                                    chapter_total) {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    new MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailPage(
                                                        id1: (item.Id) + 1,
                                                        title: item.Chapter,
                                                      ),
                                                    ),
                                                  ).then((value) {
                                                    setState(
                                                      () {
                                                        book_notcomplete =
                                                            false;
                                                      },
                                                    );
                                                  });
                                                } else {
                                                  print(
                                                    "go to finish Book Page",
                                                  );
                                                  setState(
                                                    () {
                                                      book_notcomplete = false;
                                                    },
                                                  );
                                                }
                                              },
                                              child: Container(
                                                width: width * 0.7,
                                                height: width * 0.15,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: ColorsRes.appColor,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    DemoLocalization.of(context)
                                                        .translate(
                                                            "Next Chapter >>>"), // "Next Chapter >>>",
                                                    style: TextStyle(
                                                      fontSize: width * 0.06,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          ColorsRes.textcolor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            )
                          : Column(
                              children: [
                                Container(
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Lottie.asset(
                                                "assets/images/35139-claping-animation.json",
                                              ),
                                            ),
                                            Text(
                                              DemoLocalization.of(context)
                                                  .translate(
                                                      "Congratulation!!!"),
                                              style: TextStyle(
                                                fontSize: 25,
                                                color: ColorsRes.appColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            Expanded(
                                              child: Lottie.asset(
                                                "assets/images/35139-claping-animation.json",
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          DemoLocalization.of(context).translate(
                                              "You Have Complete this book. "),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: dark_mode
                                                ? Colors.grey[600]
                                                : ColorsRes.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: height * 0.40,
                                  width: width,
                                  child: Lottie.asset(
                                    "assets/images/21903-online-class-animation.json",
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    DemoLocalization.of(context).translate(
                                        "Now Time To Explore Other Book's"),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: dark_mode
                                          ? Colors.grey[600]
                                          : ColorsRes.white,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                      color: ColorsRes.appColor,
                                    ),
                                    child: Text(
                                      DemoLocalization.of(context)
                                          .translate("Explore Now"),
                                      style: TextStyle(
                                        color: ColorsRes.textcolor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
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
                      setState(
                        () {
                          xOffset = 0;
                          yOffset = 0;
                          scaleFactor = 1;
                          isDrawerOpen = false;
                        },
                      );
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: read_along_text_on
          ? FloatingActionButton(
              isExtended: true,
              child: Text("STOP"),
              backgroundColor: ColorsRes.appColor,
              onPressed: () {
                setState(
                  () {
                    read_along_text_on = false;
                    timer?.cancel();
                    animationControllers.forEach(
                      (element) {
                        element.reset();
                      },
                    );
                  },
                );
              },
            )
          : Container(),
      bottomNavigationBar: navbar_visible
          ? Container(
              color: dark_mode ? ColorsRes.white : ColorsRes.grey1,
              child: Container(
                width: width,
                height: height * 0.11,
                decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.black,
                        blurRadius: 15.0,
                        spreadRadius: -5,
                      ),
                    ],
                    color: dark_mode ? ColorsRes.white : ColorsRes.grey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    )),
                child: Row(
                  children: [
                    SizedBox(
                      width: width * 0.04,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            _toggleScrolling();
                            if (scrollText) {
                              scrollText = false;
                            } else {
                              scrollText = true;
                            }
                          },
                        );
                      },
                      child: scrollText
                          ? Image.asset("assets/images/play_icon.png")
                          : Image.asset("assets/images/pause_icon.png"),
                    ),
                    Container(
                      width: width * 0.87,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: ColorsRes.appColor,
                          inactiveTrackColor: ColorsRes.appColor,
                          trackShape: RectangularSliderTrackShape(),
                          trackHeight: 4.0,
                          thumbColor: ColorsRes.appColor,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 12.0),
                          overlayColor: ColorsRes.appColor,
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 28.0),
                        ),
                        child: Slider(
                          inactiveColor: ColorsRes.textcolor,
                          //mouseCursor: MouseCursor.defer,
                          value: speedFactor,
                          min: 15,
                          max: 40,
                          activeColor: ColorsRes.appColor,
                          onChanged: (double value) {
                            setState(() {
                              speedFactor = value;
                            });
                            _toggleScrolling();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              height: 0,
              width: 0,
            ),
    );
  }

  setDarkMode(bool dark_mode) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool("Dark_Mode", dark_mode);
  }
}
