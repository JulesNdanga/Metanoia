import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admob/Helper/String.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screen/Splash/splashScreen.dart';
import 'Screen/admob_service.dart';
import 'localization/Demo_Localization.dart';
import 'localization/language_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light));
  await AdmobService.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}
// global variable for language define here

class _MyAppState extends State<MyApp> {
  SharedPreferences prefs;

  Locale _locale;
  bool lan;
  @override
  initState() {
    getDarkMode();
    super.initState();
  }

  setLocale(Locale locale) {
    setState(
      () {
        _locale = locale;
      },
    );
  }

  @override
  void didChangeDependencies() {
    setState(
      () {
        getLocale().then(
          (locale) {
            setState(
              () {
                this._locale = locale;
              },
            );
          },
        );
      },
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metanoia',
      theme: dark_mode
          ? ThemeData(brightness: Brightness.light)
          : ThemeData(brightness: Brightness.dark),
      locale: _locale,
      localizationsDelegates: [
        CountryLocalizations.delegate,
        DemoLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("fr", "FR"),
        Locale("en", "US")
        
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }

  //set title for indicator page
  getDarkMode() async {
    print("here exution in dark mode sharedpreference");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    dark_mode = preferences.getBool("Dark_Mode") ?? true;
    return dark_mode;
  }
}
