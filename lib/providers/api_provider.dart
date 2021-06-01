import 'dart:convert';
import 'dart:convert' show utf8;

import 'package:coinfav/models/article_model.dart';
import 'package:coinfav/models/assets_model.dart';
import 'package:coinfav/models/exchanges_model.dart';
import 'package:coinfav/models/markets_model.dart';
import 'package:coinfav/models/rates_model.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/domain/rss_feed.dart';

class ApiProvider {
  static var client = http.Client();
  static String api = "https://api.coincap.io/v2/";

  static Future<List<AssetsModel>?> fetchAssets(String ids) async {
    String param = ids.isNotEmpty ? '&ids=' + ids : '';
    var response = await client
        .get(Uri.parse(api + 'assets?limit=2000' + param), headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      var map = json.decode(response.body) as Map;
      var str = json.encode(map["data"]);
      return assetsModelFromJson(str);
    } else {
      return null;
    }
  }

  static Future<List<RatesModel>?> fetchRates() async {
    var response = await client.get(Uri.parse(api + 'rates'), headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      var map = json.decode(response.body) as Map;
      var str = json.encode(map["data"]);
      return ratesModelFromJson(str);
    } else {
      return null;
    }
  }

  static Future<List<ExchangesModel>?> fetchExchanges() async {
    var response = await client.get(Uri.parse(api + 'exchanges'), headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      var map = json.decode(response.body) as Map;
      var str = json.encode(map["data"]);
      return exchangesModelFromJson(str);
    } else {
      return null;
    }
  }

  static Future<List<MarketsModel>?> fetchMarkets(String exchangeId) async {
    var response = await client
        .get(Uri.parse(api + 'markets?exchangeId=' + exchangeId), headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      var map = json.decode(response.body) as Map;
      var str = json.encode(map["data"]);
      return marketsModelFromJson(str);
    } else {
      return null;
    }
  }

  static Future<List<ArticleModel>?> fetchNews() async {
    List<ArticleModel> news = [];
    String url =
        "http://newsapi.org/v2/everything?language=tr&q=coin&sortBy=popularity&apiKey=348b6cf1f3fb4075bafd1852c454710c";
    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ArticleModel article = ArticleModel(
            title: element['title'] ?? "",
            author: element['author'] ?? "",
            description: element['description'] ?? "",
            urlToImage: element['urlToImage'] ?? "",
            publshedAt: DateTime.parse(element['publishedAt']),
            content: element["content"] ?? "",
            articleUrl: element["url"] ?? "",
          );
          news.add(article);
        }
      });
      return news;
    }
  }

  static Future<List<ArticleModel>?> fetchRss() async {
    String rssUrl = "https://www.bloomberght.com/rss";

    final response = await http.get(Uri.parse(rssUrl));
    if (response.statusCode == 200) {
      var _decoded = new RssFeed.parse(utf8.decode(response.bodyBytes));
      return _decoded.items!
          .map((item) => ArticleModel(
              title: item.title ?? "",
              description: item.description ?? "",
              author: item.author ?? "",
              content: item.description ?? "",
              publshedAt: item.pubDate ?? DateTime.now(),
              urlToImage: item.imageUrl ?? "",
              articleUrl: item.link ?? ""))
          .toList();
    } else {
      return null;
      //throw HttpException('Failed to fetch the data');
    }
  }
}
