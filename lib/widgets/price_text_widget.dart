import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class PriceText extends StatefulWidget {
  final String id;
  final String name;
  final num oldValue;
  final num priceUsd;
  final num exchangeRate;
  final String symbol;
  final ValueNotifier<num> notifier;
  PriceText(this.id, this.name, this.oldValue, this.priceUsd, this.exchangeRate,
      this.symbol, this.notifier);

  @override
  _PriceTextState createState() => _PriceTextState();
}

class _PriceTextState extends State<PriceText> {
  Color changeColor = Colors.white;
  Timer? updateTimer;
  bool disp = false;

  void update() {
    if (widget.priceUsd.compareTo(widget.notifier.value) > 0) {
      changeColor = Colors.green;
    } else {
      changeColor = Colors.red;
    }
    setState(() {});
    updateTimer = Timer(Duration(milliseconds: 400), () {
      if (disp) {
        return;
      }
      setState(() {
        changeColor = Colors.white;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(update);
  }

  @override
  void dispose() {
    super.dispose();
    disp = true;
    widget.notifier.removeListener(update);
  }

  @override
  Widget build(BuildContext context) {
    num price = widget.priceUsd * widget.exchangeRate;
    return Text(
        price >= 0
            ? NumberFormat.currency(
                    symbol: widget.symbol,
                    decimalDigits: price > 1
                        ? price < 100000
                            ? 2
                            : 0
                        : price > .000001
                            ? 6
                            : 7)
                .format(price)
            : "N/A",
        style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold, color: changeColor));
  }
}
