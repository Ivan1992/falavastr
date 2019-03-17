import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:falavastr/bloc/library_bloc.dart';
import 'package:falavastr/calendar/DayText.dart';
import 'package:falavastr/drawer.dart';
import 'package:falavastr/pages/ustav.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final BOOKTYPE type;
  DetailsPage({this.type});

  final _apostolNames = {
    "acts": "Деяния апостольская|1-51",
    "iakov": "Иаковле послание|52-57",
    "petr1": "Петрово послание 1|58-63",
    "petr2": "Петрово послание 2|64-68",
    "ioann1": "Иоанново послание 1|69-74",
    "ioann2": "Иоанново послание 2|75",
    "ioann3": "Иоанново послание 3|76",
    "iuda": "Иудино послание|77-78",
    "rim": "К Римляном послание|79-121",
    "korinf1": "К Коринфом послание 1|122-166",
    "korinf2": "К Коринфом послание 2|167-197",
    "galatam": "К Галатом послание|198-215",
    "efeseom": "К Ефесеом послание|216-234",
    "filip": "К Филипписиом послание|235-248",
    "kolos": "К Коласаем послание|249-261",
    "solun1": "К Солуняном послание 1|262-273",
    "solun2": "К Солуняном послание 2|274-277",
    "timofey1": "К Тимофею послание 1|278-289",
    "timofey2": "К Тимофею послание 2|290-299",
    "tit": "К Титу послание|300-302",
    "filimon": "К Филимону послание|-",
    "evreom": "К Евреом послание|303-335"
  };

  final _evangelieNames = ["От Матфея", "От Марка", "От Иоанна", "От Луки"];

  final _chasoslovChapters = [
    "Чин вечерни",
    "Чин павечерницы великия",
    "Чин павечерницы средния",
    "Чин павечерницы малыя",
    "Полунощница повседневная",
    "Полунощница суботная",
    "Полунощница воскресная",
    "Начало утрени",
    "Час первыи",
    "Час третии",
    "Час шестыи",
    "Час девятыи",
    "Псалмы на литургии",
    "Тропари и кондаки воскресные на осмь гласов",
    "Тропари и кондаки дневныя",
    "Богородичны и крестоборогодичны",
    "Тропари и кондаки святыя Четверодесятницы",
    "Тропари и кондаки святыя Пятидесятницы"
  ];

  ListTile _buildApostolTile(String line, BuildContext context, DayText d) {
    String title = line.split("|")[0];
    String subtitle = line.split("|")[1];

    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        "зачала $subtitle",
        style: TextStyle(color: Colors.yellow[400]),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<Null>(builder: (BuildContext context) {
            return UstavPage(title, d, 0, false);
          }),
        );
      },
    );
  }

  ListTile _buildEvangelieTile(String title, BuildContext context, DayText d,
      [String subtitle]) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(color: Colors.yellow[900]))
          : null,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<Null>(builder: (BuildContext context) {
            return UstavPage(title, d, 0, false);
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final LibraryBloc libBloc = BlocProvider.of<LibraryBloc>(context);
    libBloc.inSwitchBook.add(type);

    return StreamBuilder(
      stream: libBloc.outLibraryList,
      builder: (BuildContext context, AsyncSnapshot<List<DayText>> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        List<ListTile> detailsList = [];

        if (type == BOOKTYPE.APOSTOL) {
          for (var i = 0; i < _apostolNames.length; i++) {
            detailsList.add(_buildApostolTile(
                _apostolNames[_apostolNames.keys.elementAt(i)],
                context,
                snapshot.data[i]));
          }
        } else if (type == BOOKTYPE.EVANGELIE) {
          for (var i = 0; i < _evangelieNames.length; i++) {
            detailsList.add(_buildEvangelieTile(
                _evangelieNames[i], context, snapshot.data[i]));
          }
        } else if (type == BOOKTYPE.PSALMS) {
          for (var i = 0; i < 20; i++) {
            String begin =
                snapshot.data[i].sluzhby[0].parts.first.name.split(" ")[1];
            String end =
                snapshot.data[i].sluzhby[0].parts.last.name.split(" ")[1];
            detailsList.add(_buildEvangelieTile("Кафизма ${i + 1}", context,
                snapshot.data[i], "псалмы $begin-$end"));
          }
        } else if (type == BOOKTYPE.CHASOSLOV) {
          for (var i = 0; i < _chasoslovChapters.length; i++) {
            detailsList.add(_buildEvangelieTile(
                _chasoslovChapters[i], context, snapshot.data[i]));
          }
        }

        return Scaffold(
          drawer: DrawerOnly(),
          appBar: AppBar(
            title: Text("Выберите главу..."),
          ),
          body: ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return detailsList[index];
            },
          ),
        );
      },
    );
  }
}
