// To parse this JSON data, do
//
//     final webSocketModel = webSocketModelFromJson(jsonString);

import 'dart:convert';

WebSocketModel webSocketModelFromJson(String str) =>
    WebSocketModel.fromJson(json.decode(str));

String webSocketModelToJson(WebSocketModel data) => json.encode(data.toJson());

class WebSocketModel {
  WebSocketModel({
    required this.exchange,
    required this.base,
    required this.quote,
    required this.direction,
    required this.price,
    required this.volume,
    this.timestamp,
    required this.priceUsd,
  });

  String exchange;
  String base;
  String quote;
  String direction;
  double price;
  double volume;
  int? timestamp;
  double priceUsd;

  factory WebSocketModel.fromJson(Map<String, dynamic> json) => WebSocketModel(
        exchange: json["exchange"] ?? "",
        base: json["base"] ?? "",
        quote: json["quote"] ?? "",
        direction: json["direction"] ?? "",
        price: json["price"].toDouble(),
        volume: json["volume"].toDouble(),
        timestamp: json["timestamp"],
        priceUsd: json["priceUsd"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "exchange": exchange,
        "base": base,
        "quote": quote,
        "direction": direction,
        "price": price,
        "volume": volume,
        "timestamp": timestamp,
        "priceUsd": priceUsd,
      };
}
