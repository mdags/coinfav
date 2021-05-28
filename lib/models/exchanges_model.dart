// To parse this JSON data, do
//
//     final exchangesModel = exchangesModelFromJson(jsonString);

import 'dart:convert';

List<ExchangesModel> exchangesModelFromJson(String str) =>
    List<ExchangesModel>.from(
        json.decode(str).map((x) => ExchangesModel.fromJson(x)));

String exchangesModelToJson(List<ExchangesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExchangesModel {
  ExchangesModel({
    required this.exchangeId,
    required this.name,
    required this.rank,
    required this.percentTotalVolume,
    required this.volumeUsd,
    required this.tradingPairs,
    this.socket,
    required this.exchangeUrl,
    this.updated,
  });

  String exchangeId;
  String name;
  String rank;
  String percentTotalVolume;
  String volumeUsd;
  String tradingPairs;
  bool? socket;
  String exchangeUrl;
  int? updated;

  factory ExchangesModel.fromJson(Map<String, dynamic> json) => ExchangesModel(
        exchangeId: json["exchangeId"] ?? "",
        name: json["name"] ?? "",
        rank: json["rank"] ?? "",
        percentTotalVolume: json["percentTotalVolume"] ?? "0",
        volumeUsd: json["volumeUsd"] ?? "0",
        tradingPairs: json["tradingPairs"] ?? "",
        socket: json["socket"],
        exchangeUrl: json["exchangeUrl"] ?? "",
        updated: json["updated"],
      );

  Map<String, dynamic> toJson() => {
        "exchangeId": exchangeId,
        "name": name,
        "rank": rank,
        "percentTotalVolume": percentTotalVolume,
        "volumeUsd": volumeUsd,
        "tradingPairs": tradingPairs,
        "socket": socket,
        "exchangeUrl": exchangeUrl,
        "updated": updated,
      };
}
