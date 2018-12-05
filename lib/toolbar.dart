import 'package:falavastr/Modal.dart';
import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';

import 'cstext.dart';

class MainCollapsingToolbar extends StatefulWidget {
  @override
  _MainCollapsingToolbarState createState() => _MainCollapsingToolbarState();
}

final items = List<String>.generate(10000, (i) => "Item $i");

class _MainCollapsingToolbarState extends State<MainCollapsingToolbar> {
  UnicornButton getButton(String text, Color buttonColor) {
    return UnicornButton(
      hasLabel: true,
      labelText: text,
      currentButton: FloatingActionButton(
        heroTag: "train",
        backgroundColor: buttonColor,
        mini: true,
        child: Icon(Icons.book),
        onPressed: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Modal m = new Modal();
    var childButtons = List<UnicornButton>();

    childButtons.add(
      getButton("На Господи воззвах", Colors.redAccent),
    );

    childButtons.add(
      getButton("Паремии", Colors.greenAccent),
    );

    childButtons.add(
      getButton("На стиховне", Colors.greenAccent),
    );

    childButtons.add(
      getButton("На Литии", Colors.greenAccent),
    );

    childButtons.add(
      getButton("Стихера по 50м псалме", Colors.blueAccent),
    );

    childButtons.add(
      getButton("Канон", Colors.blueAccent),
    );

    childButtons.add(
      getButton("Стихеры на Хвалитех", Colors.blueAccent),
    );

    childButtons.add(
      getButton("На литургии", Colors.cyanAccent),
    );

    TabBar _tab = TabBar(
      /* indicatorColor: Colors.red, */
      isScrollable: true,
      labelColor: Colors.black87,
      /* unselectedLabelColor: Colors.grey, */
      tabs: [
        Tab(text: "СВЯТЦЫ"),
        Tab(text: "ТРОПАРИ"),
        Tab(text: "ЕВАНГЕЛИЕ"),
        Tab(text: "АПОСТОЛ"),
        Tab(text: "ОКТАЙ"),
        Tab(text: "МИНЕЯ"),
        Tab(text: "ТРИОДЬ"),
      ],
    );
    return Scaffold(
      body: DefaultTabController(
        length: 7,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  collapseMode: CollapseMode.none,
                  title: Text("5 декабря н.ст.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                      )),
                  background: Container(
                    /* height: 250.0, */
                    color: Colors.amber,
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  _tab,
                ),
                pinned: true,
                floating: false,
              ),
            ];
          },
          body: Padding(
            padding: EdgeInsets.only(top: 0.0), //_tab.preferredSize.height),
            child: Material(
              /* color: Colors.yellow, */
              color: Colors.cyan[50],
              child: TabBarView(
                children: <Widget>[
                  Scaffold(
                    floatingActionButton: FloatingActionButton(
                      onPressed: () => m.menuBottom(context),
                      child: Icon(Icons.menu),
                    ),
                    /* UnicornDialer(
                        backgroundColor: Color.fromRGBO(0, 0, 0, 0.6),
                        parentButtonBackground: Colors.redAccent,
                        orientation: UnicornOrientation.VERTICAL,
                        parentButton: Icon(Icons.menu),
                        childButtons: childButtons), */
                    body: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(child: CsText()),
                    ),
                  ),
                  Center(child: Text("Таб 2")),
                  Center(
                      child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('${items[index]}'),
                      );
                    },
                  )),
                  Text("Таб 4"),
                  Text("Таб 5"),
                  Text("Таб 6"),
                  Text("Таб 7"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    //return _tabBar;
    return Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
