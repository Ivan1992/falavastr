import 'package:flutter/material.dart';

class CsText extends StatelessWidget {
  final String _text =
      "<r>Тропaрь. глaсъ, G. Ґ</r>пcли с™jи моли1те млcтиваго бGа, да грэх0въ њставлeніе подaстъ дш7aмъ нaшимъ. <r>кондaкъ. глaсъ, в7. Ћ</r>кw ѕвёзды всесвётлыz, просвэщaюща концы2 ґпcлы хrт0вы восхвaлимъ, філимHна слaвнагw, и3 ґрхи1ппа сщ7eннагw, и3 nни1сима. с8 ни1ми же и3 ґпфjю всемyдрую, вопію1ще, моли1те непрестaннw њ всёхъ нaсъ.";

  final RegExp regExp = new RegExp(
    r"<r>(.*?)</r>",
    caseSensitive: true,
    multiLine: true,
  );

  List<TextSpan> _createArray(String text) {
    List<TextSpan> toReturn = [];

    if (!text.contains(r"<r>")) {
      toReturn.add(TextSpan(text:text));
      return toReturn;
    }

    text.split(r"<r>").forEach((x) {
      if (x.isNotEmpty) {
        var fn = x.split(r"</r>");
        var red = fn[0];
        if (red.isNotEmpty) {
          toReturn
              .add(TextSpan(text: red, style: TextStyle(color: Colors.red)));
        }

        if (fn.length > 1) {
          var black = x.split(r"</r>")[1];
          if (black.isNotEmpty) {
            toReturn.add(TextSpan(text: black));
          }
        }
      }
    });
    /* text.replaceAllMapped(regExp, (match) {
      toReturn.add(
          TextSpan(text: match.group(1), style: TextStyle(color: Colors.red)));
      return '#${match.group(1)}#';
    }); */
    return toReturn;
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.justify,
      softWrap: true,
      textScaleFactor: 2.0,
      text: TextSpan(
        style: TextStyle(color: Colors.black, fontFamily: 'Grebnev'),
        children: _createArray(_text),
      ),
    );
  }
}
