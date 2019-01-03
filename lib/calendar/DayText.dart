//import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:falavastr/calendar/DateService.dart';
import 'package:flutter/services.dart' show rootBundle;

class DayTextService {
  static const List<String> _minea = [
    "yanvar.json",
    "fevral.json",
    "mart.json",
    "aprel.json",
    "maii.json",
    "juni.json",
    "july.json",
    "avgust.json",
    "september.json",
    "october.json",
    "november.json",
    "december.json"
  ];

  static const String _mineaPath =  "lib/calendar/json/minea/";
  static const String _oktay =      "lib/calendar/json/oktay/oktay.json";
  static const String _svyatcy =    "lib/calendar/json/svyatcy/svyatcy.json";

  static DateTime today = DateTime.now();

  static Future<String> _load(String path) async {
    return await rootBundle.loadString(path);
  }

  static Future<DayText> getDayText(DateTime day, TEXTTYPE type) async {
    String jsonString;
    today = day;
    DayText d;

    switch (type) {
      case TEXTTYPE.SVYATCY:
        jsonString = await _load(_svyatcy);
        d = DayText.svyatcy(json.decode(jsonString), day.day, day.month);
        d.today = day;
        return d;

      case TEXTTYPE.MINEA:
        jsonString = await _load("$_mineaPath${_minea[day.month-1]}");
        d = DayText.mineaDay(json.decode(jsonString), day.day);
        d.today = day;
        return d;

      case TEXTTYPE.EVANGELIE:
      case TEXTTYPE.APOSTOL:
      case TEXTTYPE.OKTAY:
        jsonString = await _load(_oktay);
        d = DayText.oktay(json.decode(jsonString), DateService.glas(day), day.weekday);
        d.today = day;
        return d;
      case TEXTTYPE.TRIOD:

      default:
        return null;
    }
  }
}

enum TEXTTYPE { SVYATCY, EVANGELIE, APOSTOL, MINEA, OKTAY, TRIOD }

class DayText {
  final String title;
  final List<Sluzhba> sluzhby;
  DateTime today;

  DayText({this.title, this.sluzhby});

  factory DayText.oktay(List<dynamic> parsedJson, int glas, int weekday) {
    /*
    var glasy = /<c><r>конeцъ .*? глaсу\.<\/r><\/c>/gi;	
    var glasySplit = contents.split(glasy);
    var day = /\r\nВ<r>. ?.*? вeчеръ/gi; */
    
    var glasObj = parsedJson[glas-1]["text"][(weekday+1) % 7];
    List<Sluzhba> sluzhby = List()..add(Sluzhba.oktay(glasObj));
    return DayText(sluzhby: sluzhby, title: "Октай");
  }

  factory DayText.svyatcy(List<dynamic> parsedJson, int day, int month) {
    var list = parsedJson
        .where((x) => x["day"] == day && x["month"] == month)
        .toList();
    List<Sluzhba> sluzhby = List()..add(Sluzhba.svyatcy(list[0]));
    return DayText(title: "Святцы", sluzhby: sluzhby);
  }

  factory DayText.mineaDay(List<dynamic> parsedJson, int day) {
    var list = parsedJson[day - 1]['sluzhby'] as List;
    List<Sluzhba> sluzhby = list.map((i) => Sluzhba.minea(i)).toList();

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

  factory Sluzhba.svyatcy(Map<String, dynamic> parsedJson) {
    List<Part> p = List()
      ..add(Part(
          name: "Святцы",
          text: parsedJson["saints"] +
              "\n" +
              parsedJson["tropar"] +
              (parsedJson["tropar"].length > 0
                  ? "\n" + parsedJson["tropar"]
                  : "")));

    return Sluzhba(parts: p);
  }

  factory Sluzhba.oktay(Map<String, dynamic> parsedJson) {
    List<Part> p = List()..add(Part(name: parsedJson["name"], text: parsedJson["text"]));
    return Sluzhba(parts: p);
  }

  factory Sluzhba.minea(List<dynamic> parsedJson) {
    List<Part> p =
        parsedJson.map((i) => Part(name: i["name"], text: i["text"])).toList();
    return Sluzhba(parts: p);
  }
}

class Part {
  final String name;
  final String text;

  Part({this.name, this.text});
}
