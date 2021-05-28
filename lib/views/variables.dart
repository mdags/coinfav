import 'dart:collection';
import 'package:flutter/material.dart';

class Variables {
  static Color kPrimaryColor = Color(0xFF1f1f35);
  static Color kSecondaryColor = Color(0xFF35375a);
  static Color kThirdColor = Color(0xFFd7971f);
  static Color kFourColor = Color(0xFF0f8d8f);
  static Color kFiveColor = Color(0xFF438bbd);

  static LinkedHashSet<String> supportedCurrencies = LinkedHashSet.from([
    "USD",
    "AUD",
    "BGN",
    "BRL",
    "CAD",
    "CHF",
    "CNY",
    "CZK",
    "DKK",
    "EUR",
    "GBP",
    "HKD",
    "HRK",
    "HUF",
    "IDR",
    "ILS",
    "INR",
    "ISK",
    "JPY",
    "KRW",
    "MXN",
    "MYR",
    "NOK",
    "NZD",
    "PHP",
    "PLN",
    "RON",
    "RUB",
    "SEK",
    "SGD",
    "THB",
    "TRY",
    "ZAR"
  ]);
}
