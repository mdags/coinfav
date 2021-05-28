// To parse this JSON data, do
//
//     final marketsModel = marketsModelFromJson(jsonString);

import 'dart:convert';

List<MarketsModel> marketsModelFromJson(String str) => List<MarketsModel>.from(
    json.decode(str).map((x) => MarketsModel.fromJson(x)));

String marketsModelToJson(List<MarketsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MarketsModel {
  MarketsModel({
    required this.exchangeId,
    required this.rank,
    required this.baseSymbol,
    required this.baseId,
    required this.quoteSymbol,
    required this.quoteId,
    required this.priceQuote,
    required this.priceUsd,
    required this.volumeUsd24Hr,
    required this.percentExchangeVolume,
    required this.tradesCount24Hr,
    this.updated,
  });

  String exchangeId;
  String rank;
  String baseSymbol;
  String baseId;
  String quoteSymbol;
  String quoteId;
  String priceQuote;
  String priceUsd;
  String volumeUsd24Hr;
  String percentExchangeVolume;
  String tradesCount24Hr;
  int? updated;

  factory MarketsModel.fromJson(Map<String, dynamic> json) => MarketsModel(
        exchangeId: json["exchangeId"] ?? "",
        rank: json["rank"] ?? "",
        baseSymbol: json["baseSymbol"] ?? "",
        baseId: json["baseId"] ?? "",
        quoteSymbol: json["quoteSymbol"] ?? "",
        quoteId: json["quoteId"] ?? "",
        priceQuote: json["priceQuote"] ?? "",
        priceUsd: json["priceUsd"] ?? "",
        volumeUsd24Hr: json["volumeUsd24Hr"] ?? "",
        percentExchangeVolume: json["percentExchangeVolume"] ?? "",
        tradesCount24Hr: json["tradesCount24Hr"] ?? "",
        updated: json["updated"],
      );

  Map<String, dynamic> toJson() => {
        "exchangeId": exchangeId,
        "rank": rank,
        "baseSymbol": baseSymbol,
        "baseId": baseId,
        "quoteSymbol": quoteSymbol,
        "quoteId": quoteId,
        "priceQuote": priceQuote,
        "priceUsd": priceUsd,
        "volumeUsd24Hr": volumeUsd24Hr,
        "percentExchangeVolume": percentExchangeVolume,
        "tradesCount24Hr": tradesCount24Hr,
        "updated": updated,
      };
}
