import 'package:flutter/material.dart';
import 'package:flutter_admob/Helper/ColorsRes.dart';
import 'package:flutter_admob/Helper/String.dart';
import 'package:flutter_admob/localization/Demo_Localization.dart';

class Terms_Condition extends StatefulWidget {
  const Terms_Condition({Key key}) : super(key: key);

  @override
  _Terms_ConditionState createState() => _Terms_ConditionState();
}

class _Terms_ConditionState extends State<Terms_Condition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark_mode ? ColorsRes.white : ColorsRes.grey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          DemoLocalization.of(context).translate("Terms & Conditions"),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
            ),
            child: RichText(
              text: TextSpan(
                style: new TextStyle(
                  fontSize: 16.0,
                  color: dark_mode ? ColorsRes.black : Colors.white,
                ),
                children: <TextSpan>[
                  new TextSpan(
                    text: DemoLocalization.of(context).translate(
                      "Help us ",
                    ),
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  new TextSpan(
                    text: DemoLocalization.of(context).translate(
                      "Help us descrip",
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
