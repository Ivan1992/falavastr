import 'package:falavastr/bloc/bloc_provider.dart';
import 'package:falavastr/bloc/library_bloc.dart';
import 'package:falavastr/calendar/DayText.dart';
import 'package:falavastr/drawer.dart';
import 'package:falavastr/pages/ustav.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final BOOKTYPE type;
  DetailsPage({this.type});

  final apostolNames = {
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

  final evangelieNames = ["От Матфея", "От Марка", "От Иоанна", "От Луки"];

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
      subtitle: subtitle != null ? Text(subtitle) : null,
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
          for (var i = 0; i < apostolNames.length; i++) {
            detailsList.add(_buildApostolTile(
                apostolNames[apostolNames.keys.elementAt(i)],
                context,
                snapshot.data[i]));
          }
        } else if (type == BOOKTYPE.EVANGELIE) {
          for (var i = 0; i < evangelieNames.length; i++) {
            detailsList.add(_buildEvangelieTile(
                evangelieNames[i], context, snapshot.data[i]));
          }
        } else if (type == BOOKTYPE.PSALMS) {
          for (var i = 0; i < 20; i++) {
            detailsList.add(_buildEvangelieTile(
                "Кафизма ${i + 1}", context, snapshot.data[i]));
          }
        } else if (type == BOOKTYPE.CHASOSLOV) {

        }

        return Scaffold(
          drawer: DrawerOnly(),
          appBar: AppBar(
            title: Text("Выберите часть..."),
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
