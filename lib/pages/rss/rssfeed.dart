import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:webfeed/webfeed.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../drawer.dart';

class RSSFeed extends StatelessWidget {
  final client = new http.Client();
  List<String> feedUrls = [
    "http://rpsc.ru/feed/",
    "http://rpso.ru/feed/",
    "http://kirovold43.ru/feed/",
    "http://ostozhenka-hram.ru/feed/",
    "https://lo-alexey.livejournal.com/data/rss",
    "https://o-apankratov.livejournal.com/data/rss",
    "https://nbobkov.livejournal.com/data/rss",
    "https://ierej-vadim.livejournal.com/data/rss",
  ];
  List<String> shortNames = [
    "РПСЦ",
    "РЖЕВ",
    "КИРОВ",
    "ОСТОЖЕНКА",
    "ЛОПАТИН",
    "ПАНКРАТОВ",
    "БОБКОВ",
    "КОРОВИН"
  ];
  List<Color> colors = [
    Colors.blue[100],
    Colors.orange[100],
    Colors.purple[100],
    Colors.green[100],
    Colors.yellow[100],
    Colors.red[100],
    Colors.teal[100],
    Colors.indigo[100]
  ];
  List<RssWrapper> fullFeed = [];
  List<Card> fullFeedCards = [];

  RSSFeed() {}

  Widget _card(RssItem item, Color bg, String source, String link) {
    String desc = item.description.replaceAll(RegExp(r"<[^>]*>"), "");
    int len = desc.length;
    int max = 90;
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
                      ? Text(desc.substring(0, max + 1) + "...")
                      : Text(desc))
                  : null,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(link
                  .replaceAll(RegExp(r"https?://"), "")
                  .replaceAll("/", "")),
              /* FlatButton(
                child: const Text('ЧИТАТЬ'),
                onPressed: () {
                  _launchURL(item.link);
                },
              ), */
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
    Response response = await client.get(url);
    String bodyString = response.body;
    var channel = RssFeed.parse(bodyString);
    DateFormat format = DateFormat("EEE, dd MMM yyyy hh:mm:ss Z");
    return channel.items
        .map((item) => RssWrapper(
            _card(item, colors[index], shortNames[index], channel.link),
            format.parse(item.pubDate)))
        .toList();
  }

  Future<List<RssWrapper>> _gatherFeeds() async {
    List<Future<List<RssWrapper>>> futures = [];
    for (int i = 0; i < feedUrls.length; i++) {
      futures.add(_getFeedItems(feedUrls[i], i));
    }
    List<List<RssWrapper>> response = await Future.wait(futures);
    fullFeed = response.expand((i) => i).toList();
    fullFeed.sort((b, a) => a.date.compareTo(b.date));
    return fullFeed;
  }

  @override
  Widget build(BuildContext context) {
    //fullFeed.sort((a, b) => DateTime(a.pubDate))

    return Scaffold(
      drawer: DrawerOnly(),
      appBar: AppBar(
        title: Text("Новости РПСЦ"),
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
