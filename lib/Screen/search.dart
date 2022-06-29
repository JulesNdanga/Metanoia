import 'package:flutter/material.dart';
import 'package:flutter_admob/Helper/ColorsRes.dart';
import 'package:flutter_admob/Helper/String.dart';
import 'package:flutter_admob/Model/detail.dart';
import 'package:flutter_admob/databaseHelper/dbhelper.dart';
import 'package:flutter_admob/localization/Demo_Localization.dart';

import 'chapterDetails.dart';

class ListSearch extends StatefulWidget {
  final int id;
  ListSearch({Key key, this.id}) : super(key: key);
  ListSearchState createState() => ListSearchState();
}

class ListSearchState extends State<ListSearch> {
  List<detail> item = [];
  List<detail> _notesForDisplay = [];
  TextEditingController _textController = TextEditingController();

  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();
  bool typing = false;

  //highlighttext
  String source, query;
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
              backgroundColor: ColorsRes.appColor,
              color: Colors.white,
            ),
          ),
        );
      } else if (match.start > lastMatchEnd) {
        children.add(
          TextSpan(
            text: source.substring(lastMatchEnd, match.start),
          ),
        );

        children.add(
          TextSpan(
            text: source.substring(match.start, match.end),
            style: TextStyle(
                backgroundColor: ColorsRes.appColor, color: Colors.white),
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
          text: source.substring(lastMatchEnd, source.length),
        ),
      );
    }

    return children;
  }

  @override
  void initState() {
    setState(
      () {
        instance.getSearch().then(
          (value) {
            item.addAll(value);
            _notesForDisplay = item;
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark_mode ? ColorsRes.white : ColorsRes.black,
      appBar: AppBar(
        backgroundColor: ColorsRes.appColor,
        title: typing
            ? Text(DemoLocalization.of(context).translate("title"))
            : TextField(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                cursorColor: Colors.white,
                autofocus: true,
                controller: _textController,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  hintText: DemoLocalization.of(context).translate("Search"),
                  hintStyle: TextStyle(
                    color: Colors.white60,
                    fontSize: 18,
                  ),
                ),
                onChanged: (text) {
                  text = text.toLowerCase();
                  setState(
                    () {
                      query = text;
                      _notesForDisplay = item.where(
                        (items) {
                          var noteTitle = items.Chapter.toLowerCase();
                          return noteTitle.contains(text);
                        },
                      ).toList();
                    },
                  );
                },
              ),
        actions: <Widget>[
          IconButton(
            icon: Icon(typing ? Icons.search : Icons.clear),
            onPressed: () {
              setState(
                () {
                  typing = !typing;
                  _textController.clear();
                  query = "";
                  _notesForDisplay = item;
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        //Fetching all the persons from the list using the istance of the DatabaseHelper class
        future: instance.getSearch(),
        builder: (context, index) {
          //Checking if we got data or not from the DB
          return ListView.separated(
            itemCount: _notesForDisplay.length,
            separatorBuilder: (BuildContext context, int index) => Divider(
              color: dark_mode ? Colors.white : ColorsRes.black,
              height: 5,
              thickness: 8,
            ),
            itemBuilder: (context, index) {
              var item = _notesForDisplay[index];
              return ListTile(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 16.0,
                ),
                dense: true,
                tileColor:
                    dark_mode ? ColorsRes.backgroundColor : ColorsRes.grey,
                leading: Text(
                  item.Id.toString() + '.',
                  style: TextStyle(
                    fontSize: 20,
                    color: dark_mode ? ColorsRes.black : Colors.white,
                  ),
                ),
                title: RichText(
                  text: TextSpan(
                    children: highlightOccurrences(() {
                      if (Language_flag == "en") {
                        return item.Chapter;
                      }  else if (Language_flag == "fr") {
                        return item.fr_Chapter;
                      }  else {
                        return item.Chapter;
                      }
                    }(), query),
                    style: TextStyle(
                      fontSize: 20,
                      color: dark_mode ? Colors.black : ColorsRes.white,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: RouteSettings(
                        arguments: item,
                      ),
                      builder: (context) => DetailPage(
                        id1: item.Id,
                        title: item.Chapter,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
