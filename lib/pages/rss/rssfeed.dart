import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/domain/dublin_core/dublin_core.dart';
import 'package:webfeed/webfeed.dart';

class RSSFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var client = new http.Client();

    // RSS feed
    client.get("https://goloscerkvi.info/feed/").then((response) {
      return response.body;
    }).then((bodyString) {
      var channel = new RssFeed.parse(bodyString);
      channel.items.forEach((item) {
        DublinCore dc = item.dc;
        
        print("title: ${item.title}");
      });
      return channel;
    });
    print("test");

    return Container(
      child: Center(
        child: Text("test"),
      ),
    );
  }
}
