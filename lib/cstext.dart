import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CsText extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CsText();
}

class _CsText extends State<CsText> {
  double _fontSize = 2.0;
  double _previousScale = 2.0;
  String _fontFamily = 'Grebnev';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getDouble("fontSize") ?? 2.0;
    _fontFamily = prefs.getString("fontFamily") ?? 'Grebnev';
  }

  final String _text2 =
      "<c><r>МЦCА ГЕНУА~РIZ ВЪ А& ДН&Ь</r></c>\n<r>є4же п0 плоти њбрёзаніе гDа нaшегw ї©а хrтA.</r>\nи3<r> пaмzть и4же во с™hхъ nц7а нaшегw васи1ліz вели1кагw. </r>ѓ<r>ще ли же случи1тсz в8 нLю, совершaемъ бдёніе. Н</r>а мaлэй вечeрни, стихёры воскrны. <c>T<r> бытіS, чтeніе.</r></c>";

  final String _text =
      "К<r>ан0нъ прaзднику, со їрмос0мъ, нa ѕ7. глaсъ, в7. пёснь, №. їрм0съ. П</r>yть морскjи волнyzсz пёнами, сyхъ kви1сz. їзрaильты пріeмлz. си1нz же пучи1на тристaты є3гЂпетски, потопи2 ѕэлw2, водослaненъ гр0бъ, си1лою крёпкою, десни1цею владhчнею.\r\n<r>запёвъ: С</r>лaва гDи бGоzвлeнію твоемY.<r> О</r>µ4тру ћвльшусz чlкwмъ свэтон0сну. нhнэ t пустhни к8 водaмъ їwрдaнскимъ, цRю преклони1лъ є3си2 сlнце свою2 вhю, ли1ка мрaчна родоначaльника восхити1ти, сквeрны же всsкіz њчи1стити твaрь. <r>Б</r>ез8начaльне водaми спогрeбшатисz сл0ве, пловhи прев0диши и3стлёвшаго лeстію. сеS несказaннw вhше kви1въ, даровaніе держaвнw. сeй воз8лю1бленныи, рaвенъ же ми2 џтрокъ є3стеств0мъ.\r\nК<r>ан0нъ с™0му, на }. творeніе fеHфаново. глaсъ, в7. пёснь, №. їрм0съ. В</r>о глубинЁ потопи2 дрeвле, фараwни1тскаz всS в0инства, преwружeну си1лу. вопл0щшеесz сл0во, преспёющіz грэхи2 потреби1ло є4сть, преслaвныи гDь, ћкw прослaвисz.\r\n<r>запёвъ: П</r>рпdбне џ§е fеодHсіе, моли2 бGа њ нaсъ. <r>Ћ</r>кw премyдръ чиноначaльникъ нaшъ, џ§е fеодHсіе, бGолёпнw пёснь начни2, пришeдшему во всеми1рное спасeніе, хrтY бGу. и3 всес™yю пaмzть твою2, с8 соб0ю прослaвльшему. <r>И#</r>з8 пустhни п®тча хrт0въ, t ґарHновы є3лисавeти прозsбыи пріи1де. в8 купёли же fеодHсіи р0ждьсz д¦омъ, пустhнныи грaжданинъ бhсть, ї©ови послёд8ствуz. <r>К</r>Rщьшусz в8 водaхъ хrтY, ї}льтескому соб0рищу потреби1сz шатaніе. в8 цRкви же, равноѓгGльно житіE насади1сz. є4же неукл0нно п0жилъ є3си2 пребlжeнне, fеодHсіе. <r>слaва. N</r>бeщникъ стрaсти бhвъ џ§е воздержaніемъ, и4же нaсъ рaди на кrтЁ пригвождeнному. дост0йнw соњбрaзенъ бhсть тогw2 воскrнію. и3 наслёдникъ бhлъ є3си2 слaвэ fеодHсіе. <r>и3 нн7э, боg. N</r>трокови1цъ бжcтвеныи ли1къ смотрели1вно в8 женaхъ тS д0брую и3менyютъ бцdе вLчце, добр0тами ўкрaшену бжcтвA. добротвори1тельно бо сл0во, пaче сл0ва породилA є3си2.\n<r>катавaсіz: Г</r>";

  List<Widget> _parseText(String text) {
    List<Widget> toReturn = [];
    if (!text.contains(r"<r>")) {
      toReturn.add(RichText(text: TextSpan(text: text)));
      return toReturn;
    }

    text.split(r"<c>").forEach((part) {
      if (part.isNotEmpty) {
        var fn = part.split("</c>");
        var left = fn[0];
        if (left.isNotEmpty && fn.length > 1) {
          toReturn.add(Text.rich(
            TextSpan(
                style: TextStyle(color: Colors.black, fontFamily: _fontFamily),
                children: _parseRed(left)),
            textAlign: TextAlign.center,
            textScaleFactor: _fontSize,
          ));
        } else {
          toReturn.add(RichText(
            textAlign: TextAlign.justify,
            textScaleFactor: _fontSize,
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontFamily: _fontFamily),
              children: _parseRed(left),
            ),
          ));
        }

        if (fn.length > 1) {
          var right = fn[1];
          if (right.isNotEmpty) {
            toReturn.add(RichText(
              textAlign: TextAlign.justify,
              textScaleFactor: _fontSize,
              text: TextSpan(
                style: TextStyle(color: Colors.black, fontFamily: _fontFamily),
                children: _parseRed(right),
              ),
            ));
          }
        }
      }
    });
    return toReturn;
  }

  List<TextSpan> _parseRed(String text) {
    List<TextSpan> toReturn = [];

    text.split(r"<r>").forEach((x) {
      if (x.isNotEmpty) {
        var fn = x.split(r"</r>");
        var red = fn[0];
        if (red.isNotEmpty && fn.length > 1) {
          toReturn
              .add(TextSpan(text: red, style: TextStyle(color: Colors.red)));
        } else if (fn.length == 1) {
          toReturn.add(TextSpan(text: red));
        }

        if (fn.length > 1) {
          var black = fn[1];
          if (black.isNotEmpty) {
            toReturn.add(TextSpan(text: black));
          }
        }
      }
    });
    return toReturn;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _fontSize = (_previousScale * details.scale).clamp(1.0, 4.0);
    });
  }

  void _handleOnScaleStart(ScaleStartDetails details) {
    setState(() {
      _previousScale = _fontSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _handleOnScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      child: ListView(
        children: _parseText(_text),
      ),
    );
  }
}
