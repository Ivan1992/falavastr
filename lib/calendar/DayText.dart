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

  static const String _mineaPath = "lib/calendar/json/minea/";
  static const String _oktay = "lib/calendar/json/oktay/oktay.json";
  static const String _svyatcy = "lib/calendar/json/svyatcy/svyatcy.json";
  static const String _kanonnik = "lib/calendar/json/kanonnik/kanonnik.json";

  static const String _apostol = "lib/calendar/json/library/apostol.json";
  static const String _evangelie = "lib/calendar/json/library/evangelie.json";
  static const String _psalms = "lib/calendar/json/library/psalms.json";
  static const String _chasoslov = "lib/calendar/json/library/chasoslov.json";

  static DateTime today = DateTime.now();

  static Future<String> _load(String path) async {
    return await rootBundle.loadString(path);
  }

  static Future<List<DayText>> getKanonnik() async {
    List<DayText> _dayTextList = [];
    String jsonString = await _load(_kanonnik);
    List<dynamic> parsed = json.decode(jsonString);
    _dayTextList = parsed.map((item) => DayText.kanonnik(item)).toList();
    return _dayTextList;
  }

  static Future<List<DayText>> getBookByType(BOOKTYPE type) async {
    List<DayText> listDayText = [];
    if (type == BOOKTYPE.APOSTOL) {
      String jsonString = await _load(_apostol);
      Map<String, dynamic> parsed = json.decode(jsonString);
      parsed.forEach((key, value) {
        List<Part> parts = [];
        value.forEach((item) {
          parts.add(Part(name: "Зачала ${item['zach']}", text: item["text"]));
        });
        DayText dayText =
            DayText(title: key, sluzhby: List()..add(Sluzhba(parts: parts)));
        listDayText.add(dayText);
      });
    } else if (type == BOOKTYPE.EVANGELIE) {
      String jsonString = await _load(_evangelie);
      Map<String, dynamic> parsed = json.decode(jsonString);
      parsed.forEach((key, value) {
        List<Part> parts = [];
        value.forEach((item) {
          parts.add(Part(name: "Зачала ${item['zach']}", text: item["text"]));
        });
        DayText dayText =
            DayText(title: key, sluzhby: List()..add(Sluzhba(parts: parts)));
        listDayText.add(dayText);
      });
    } else if (type == BOOKTYPE.CHASOSLOV) {
      String jsonString = await _load(_chasoslov);
      Map<String, dynamic> parsed = json.decode(jsonString);
      parsed.forEach((key, value) {
        List<Part> parts = [];
        value.forEach((item) {
          parts.add(Part(name: "Часослов", text: item["text"]));
        });
        DayText dayText =
            DayText(title: key, sluzhby: List()..add(Sluzhba(parts: parts)));
        listDayText.add(dayText);
      });
    } else if (type == BOOKTYPE.PSALMS) {
      String jsonString = await _load(_psalms);
      List<dynamic> parsed = json.decode(jsonString);
      for (var i = 0; i < 20; i++) {
        List<Part> parts = [];
        parsed.where((item) => item["k"] == (i + 1)).forEach((item) {
          parts.add(
            Part(
                name: "Псалом ${parsed.indexOf(item) + 1}",
                text: item["text"]),
          );
        });

        listDayText.add(DayText(
            title: "Кафизма ${i + 1}",
            sluzhby: List()..add(Sluzhba(parts: parts))));
      }
    }
    return listDayText;
  }

  static Future<DayText> getDayText(DateTime day, TEXTTYPE type) async {
    String jsonString;
    day = day.subtract(Duration(days: 13));
    if (day.hour == 23) day = day.add(Duration(hours: 1)); //in case summer time
    today = day;
    DayText d;

    switch (type) {
      case TEXTTYPE.SVYATCY:
        jsonString = await _load(_svyatcy);
        d = DayText.svyatcy(json.decode(jsonString), day.day, day.month);
        d.today = day;
        return d;

      case TEXTTYPE.MINEA:
        jsonString = await _load("$_mineaPath${_minea[day.month - 1]}");
        d = DayText.mineaDay(json.decode(jsonString), day.day);
        d.today = day;
        return d;

      //case TEXTTYPE.EVANGELIE:
      //case TEXTTYPE.APOSTOL:
      case TEXTTYPE.OKTAY:
        jsonString = await _load(_oktay);
        day = day.add(
            Duration(days: 13)); //Calculate Oktay only based on new-stlye dates
        d = DayText.oktay(
            json.decode(jsonString), DateService.glas(day), day.weekday);
        d.today = day;
        return d;
      //case TEXTTYPE.TRIOD:

      default:
        return null;
    }
  }
}

//enum TEXTTYPE { SVYATCY, EVANGELIE, APOSTOL, MINEA, OKTAY, TRIOD }
enum TEXTTYPE { SVYATCY, MINEA, OKTAY, KANONNIK }
enum BOOKTYPE { APOSTOL, EVANGELIE, PSALMS, CHASOSLOV }

class DayText {
  final String title;
  final List<Sluzhba> sluzhby;
  DateTime today;

  DayText({this.title, this.sluzhby});

  factory DayText.empty() {
    return DayText(sluzhby: [], title: "empty");
  }

  factory DayText.oktay(List<dynamic> parsedJson, int glas, int weekday) {
    var glasObj = parsedJson[glas - 1]["text"][weekday % 7]["text"];
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
      title: "Минея", //parsedJson[day]['title'],
      sluzhby: sluzhby,
    );
  }

  factory DayText.kanonnik(dynamic item) {
    //List<Sluzhba> sluzhby = List()..add(Sluzhba.kanonnik(parsedJson));
    List<Sluzhba> sluzhby = List()
      ..add(Sluzhba(
          parts: List()..add(Part(name: item["name"], text: item["text"]))));
    return DayText(title: item["name"], sluzhby: sluzhby);
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

  factory Sluzhba.oktay(List<dynamic> parsedJson) {
    //List<Part> p = List()..add(Part(name: parsedJson["name"], text: parsedJson["text"]));
    List<Part> p =
        parsedJson.map((i) => Part(name: i["name"], text: i["text"])).toList();
    return Sluzhba(parts: p);
  }

  factory Sluzhba.minea(List<dynamic> parsedJson) {
    List<Part> p =
        parsedJson.map((i) => Part(name: i["name"], text: i["text"])).toList();
    return Sluzhba(parts: p);
  }

  /* factory Sluzhba.kanonnik(Map<String, dynamic> parsedJson) {
    List<Part> p = List()
      ..add(Part(name: parsedJson["name"], text: parsedJson["text"]));
    return Sluzhba(parts: p);
  } */
}

class Part {
  final String name;
  final String text;

  Part({this.name, this.text});
}
