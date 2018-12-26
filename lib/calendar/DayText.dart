//import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DayTextService {
  static List<String> _minea = [
    "yanvar.json",
    "fevral.json",
    "yanvar.json",
    "fevral.json",
    "yanvar.json",
    "fevral.json",
    "yanvar.json",
    "fevral.json",
    "yanvar.json",
    "fevral.json",
    "yanvar.json",
    "fevral.json"
  ];

  static Future<String> _loadAStudentAsset(String name) async {
    return await rootBundle.loadString('lib/calendar/json/$name');
  }

  static Future<DayText> getText(DateTime day, TEXTTYPE type) async {
    String jsonString; // = await _loadAStudentAsset(_minea[day.month]);
    //final jsonResponse = json.decode(jsonString);

    switch (type) {
      case TEXTTYPE.SVYATCY:
        break;

      case TEXTTYPE.MINEA:
        jsonString = (await _loadAStudentAsset(_minea[day.month]));
        return DayText.fromJson(json.decode(jsonString), day.day);
        break;

      case TEXTTYPE.TROPARY:
      case TEXTTYPE.EVANGELIE:
      case TEXTTYPE.APOSTOL:
      case TEXTTYPE.OKTAY:
      case TEXTTYPE.TRIOD:

      default:
        return null;
    }
    return null;
  }
}

enum TEXTTYPE { SVYATCY, TROPARY, EVANGELIE, APOSTOL, MINEA, OKTAY, TRIOD }

class DayText {
  final String title;
  final List<Sluzhba> sluzhby;

  DayText({this.title, this.sluzhby});

  factory DayText.fromJson(List<dynamic> parsedJson, int day) {
    //List<Sluzhba> sluzhby = new List<Sluzhba>();
    //print( parsedJson[day]['sluzhby']);
    var list = parsedJson[day]['sluzhby'] as List;
    print(">>>>>>>>>>>>>>>>>>>>>>=${list.runtimeType}");

    List<Sluzhba> sluzhby = list.map( (i) => Sluzhba.fromJson(i)).toList();
        
    sluzhby.forEach( (x) {
      print(">>>>>>${x.parts.length}");
    });

    return DayText(
      title: parsedJson[day]['title'],
      sluzhby: sluzhby,
    );
  }

  String toString() {
    return "title=$title \n\t${sluzhby[0].parts}";
  }
}

class Sluzhba {
  final Map<String,String> parts;

  Sluzhba({this.parts});

  factory Sluzhba.fromJson(List<dynamic> parsedJson) {
    Map<String, String> vals = new Map<String,String>();
    parsedJson.forEach((map) {
      String key, value;
      map.forEach( (k,v) {
        //print("###### k=$k v=$v");
        if (k == "name") {
          key = v;
        } else {
          value = v;
        }
      });
      vals[key] = value;
    });
    return Sluzhba(parts: vals);
  }
}
