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
    return await rootBundle.loadString('lib/calendar/json/minea/$name');
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
    var list = parsedJson[day-1]['sluzhby'] as List;

    List<Sluzhba> sluzhby = list.map( (i) => Sluzhba.fromJson(i)).toList();
        

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
  final List<Part> parts;

  Sluzhba({this.parts});

  factory Sluzhba.fromJson(List<dynamic> parsedJson) {
    List<Part> p = parsedJson.map((i) => Part(name: i["name"], text: i["text"])).toList();
    return Sluzhba(parts: p);
  }
}

class Part {
  final String name;
  final String text;

  Part({this.name, this.text});
}
