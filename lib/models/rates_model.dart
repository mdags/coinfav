// To parse this JSON data, do
//
//     final ratesModel = ratesModelFromJson(jsonString);

import 'dart:convert';

List<RatesModel> ratesModelFromJson(String str) =>
    List<RatesModel>.from(json.decode(str).map((x) => RatesModel.fromJson(x)));

String ratesModelToJson(List<RatesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RatesModel {
  RatesModel({
    required this.id,
    required this.symbol,
    required this.currencySymbol,
    required this.type,
    required this.rateUsd,
  });

  String id;
  String symbol;
  String currencySymbol;
  String type;
  String rateUsd;

  factory RatesModel.fromJson(Map<String, dynamic> json) => RatesModel(
        id: json["id"] ?? "",
        symbol: json["symbol"] ?? "",
        currencySymbol: json["currencySymbol"] ?? "",
        type: json["type"] ?? "",
        rateUsd: json["rateUsd"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "symbol": symbol,
        "currencySymbol": currencySymbol,
        "type": type,
        "rateUsd": rateUsd,
      };
}
