import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:webfeed/webfeed.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../drawer.dart';

class RSSFeed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RSSFeedState();
}

class _RSSFeedState extends State<RSSFeed> {
  final client = new http.Client();

  List<RssWrapper> fullFeed = [];

  final List<RSSChannelWrapper> feeds = [
    RSSChannelWrapper("http://rpsc.ru/feed/", "РПСЦ", "Официальный сайт РПСЦ",
        Colors.blue[50]),
    RSSChannelWrapper("http://rpso.ru/feed/", "РЖЕВ", "Сайт общины г. Ржева",
        Colors.indigo[50]),
    RSSChannelWrapper("http://kirovold43.ru/feed/", "КИРОВ",
        "Сайт общины г. Кирова", Colors.purple[50]),
    RSSChannelWrapper("http://ostozhenka-hram.ru/feed/", "ОСТОЖЕНКА",
        "Сайт общины г. Москвы", Colors.green[50]),
    RSSChannelWrapper("https://izdrevle.ru/feed", "ИЗДРЕВЛЕ",
        "Сайт общины г. Ростова", Colors.red[50]),
    RSSChannelWrapper("https://lo-alexey.livejournal.com/data/rss", "ЛОПАТИН",
        "ЖЖ о.Алексея Лопатина", Colors.yellow[50], false),
    RSSChannelWrapper("https://o-apankratov.livejournal.com/data/rss",
        "ПАНКРАТОВ", "ЖЖ о.Александра Панкратова", Colors.teal[50], false),
    RSSChannelWrapper("https://nbobkov.livejournal.com/data/rss", "БОБКОВ",
        "ЖЖ о.Николы Бобкова", Colors.indigo[50], false),
    RSSChannelWrapper("https://ierej-vadim.livejournal.com/data/rss", "КОРОВИН",
        "ЖЖ о.Вадима Коровина", Colors.brown[50], false),
  ];

  /*  @override
  void initState() {
    super.initState();
    feeds.addAll();
  } */

  Widget _card(RssItem item, Color bg, String source, String link) {
    String desc = item.description.replaceAll(RegExp(r"<[^>]*>"), "");
    int len = desc.length;
    int max = 180;
    DateFormat sourceFormat = DateFormat("EEE, dd MMM yyyy hh:mm:ss Z");
    DateTime d = sourceFormat.parse(item.pubDate);
    DateFormat outputFormat = DateFormat("dd.MM.yyyy");
    return Card(
      color: bg,
      child: InkWell(
        onTap: () => _launchURL(item.link),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(outputFormat.format(d)),
                  Text(
                    source,
                    style: TextStyle(
                        backgroundColor: bg.withOpacity(0.5),
                        color: Colors.black),
                  )
                ],
              ),
              title: Text(item.title),
              subtitle: len > 0
                  ? (len > max
                      ? Text(desc.substring(0, max + 1) + "...",
                          style: TextStyle(fontFamily: "PTSerif"))
                      : Text(desc, style: TextStyle(fontFamily: "PTSerif")))
                  : null,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(link
                  .replaceAll(RegExp(r"https?://"), "")
                  .replaceAll("/", "")),
            ])
          ],
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Future<List<RssWrapper>> _getFeedItems(String url, int index) async {
    try {
      Response response = await client.get(url);
      String bodyString = response.body;
      var channel = RssFeed.parse(bodyString);
      DateFormat format = DateFormat("EEE, dd MMM yyyy hh:mm:ss Z");
      return channel.items
          .map((item) => RssWrapper(
              _card(item, feeds[index].color, feeds[index].shortName,
                  channel.link),
              format.parse(item.pubDate)))
          .toList();
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List<RssWrapper>> _gatherFeeds() async {
    List<Future<List<RssWrapper>>> futures = [];
    for (int i = 0; i < feeds.length; i++) {
      if (feeds[i].enabled) {
        futures.add(_getFeedItems(feeds[i].url, i));
      }
    }
    List<List<RssWrapper>> response = await Future.wait(futures);
    fullFeed = response.expand((i) => i).toList();
    fullFeed.sort((b, a) => a.date.compareTo(b.date));
    return fullFeed;
  }

  void _showList() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(title: Text('Новостные каналы'), children: [
            MyDialogClass(
              feeds: feeds,
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ]);
        });
    fullFeed = [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerOnly(),
      appBar: AppBar(
        title: Text("Новости РПСЦ"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _showList,
          ),
        ],
      ),
      body: FutureBuilder(
        future: _gatherFeeds(),
        builder: (BuildContext ctx, AsyncSnapshot<List<RssWrapper>> snapshot) {
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data.length == 0)
            return Center(child: CircularProgressIndicator());

          return Container(
            child: ListView(
              children: snapshot.data.map((item) => item.card).toList(),
            ),
          );
        },
      ),
    );
  }
}

class RssWrapper {
  final Card card;
  final DateTime date;

  RssWrapper(this.card, this.date);
}

class RSSChannelWrapper {
  final String url;
  final String shortName;
  final String longName;
  final Color color;
  bool enabled;

  RSSChannelWrapper(this.url, this.shortName, this.longName, this.color,
      [this.enabled = true]);
}

class MyDialogClass extends StatefulWidget {
  MyDialogClass({Key key, this.feeds}) : super(key: key);

  final List<RSSChannelWrapper> feeds;

  @override
  _MyDialogClassState createState() => _MyDialogClassState();
}

class _MyDialogClassState extends State<MyDialogClass> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: widget.feeds
          .map(
            (feed) => CheckboxListTile(
                  title: Text(feed.longName),
                  value: feed.enabled,
                  onChanged: (val) {
                    setState(() {
                      feed.enabled = val;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
          )
          .toList(),
    );
  }
}
