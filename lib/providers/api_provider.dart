import 'dart:convert';

import 'package:coinfav/models/assets_model.dart';
import 'package:coinfav/models/exchanges_model.dart';
import 'package:coinfav/models/markets_model.dart';
import 'package:coinfav/models/rates_model.dart';
import 'package:http/http.dart' as http;

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
}
