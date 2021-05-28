import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:coinfav/models/assets_model.dart';
import 'package:coinfav/models/favorites_model.dart';
import 'package:coinfav/models/rates_model.dart';
import 'package:coinfav/providers/api_provider.dart';
import 'package:coinfav/views/assets.dart';
import 'package:coinfav/widgets/price_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PortfolioPage extends StatefulWidget {
  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  ValueNotifier<num> _listener = ValueNotifier(0);
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://ws.coincap.io/prices?assets=ALL'),
  );
  ScrollController scrollController = ScrollController();
  var _rates = <RatesModel>[];
  num _exchangeRate = 1;
  String _currencySymbol = "";
  var _list = <AssetsModel>[];
  var _filteredList = <AssetsModel>[];
  bool _isLoading = false;
  bool _searching = false;
  final _db = Localstore.instance;
  final _items = <String, FavoritesModel>{};

  void fetchData(bool stream) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var concet = StringBuffer();
      final data = await _db.collection('favs').get();
      if (data != null) {
        data.forEach((key, value) {
          final item = FavoritesModel.fromMap(value);
          _items.putIfAbsent(item.id, () => item);
          concet.write(item.name + ',');
        });
      }
      if (concet.isNotEmpty) {
        var data = await ApiProvider.fetchAssets(concet.toString());
        if (data != null) {
          _list = data;
          _filteredList = data;

          var ratesData = await ApiProvider.fetchRates();
          if (ratesData != null) {
            _rates = ratesData;
            var currency =
                _rates.firstWhere((element) => element.symbol == "USD");
            _exchangeRate = num.parse(currency.rateUsd);
            _currencySymbol = currency.currencySymbol;
          }
          if (stream) listenWebSocket();
        }
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void listenWebSocket() async {
    _channel.stream.listen((message) {
      Map<String, dynamic> data = json.decode(message);
      data.forEach((key, value) {
        var item = _filteredList.where((element) => element.id == key);
        if (item.isNotEmpty) {
          num oldValue = num.parse(item.first.priceUsd);
          _listener.value = oldValue;
          item.first.oldValue = oldValue.toString();
          item.first.priceUsd = value.toString();
          if (!mounted) return;
          setState(() {});
        }
      });
    });
  }

  void search(String s) {
    scrollController.jumpTo(0.0);
    if (s.isNotEmpty) {
      setState(() {
        _filteredList = _list
            .where((element) =>
                element.name.toLowerCase().contains(s.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        _filteredList = _list;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(true);
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searching
            ? TextField(
                autocorrect: false,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none),
                style: TextStyle(color: Colors.white),
                onChanged: (s) {
                  search(s);
                },
                onSubmitted: (s) {
                  search(s);
                })
            : Text('Coin Fav'),
        actions: [
          IconButton(
              icon: Icon(_searching ? Icons.close : Icons.search),
              onPressed: () {
                if (_isLoading) {
                  return;
                }
                setState(() {
                  if (_searching) {
                    _searching = false;
                    _filteredList = _list;
                  } else {
                    _searching = true;
                  }
                });
              }),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : bodyWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(new MaterialPageRoute(
                builder: (context) => AssetsPage(), fullscreenDialog: true))
            .then((_) {
          fetchData(false);
        }),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget bodyWidget() {
    return ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(8.0),
        itemCount: _filteredList.length,
        itemBuilder: (context, index) =>
            cardItemExchanges(_filteredList[index]));
  }

  Widget cardItemExchanges(AssetsModel item) {
    double width = MediaQuery.of(context).size.width;
    num change = num.parse(item.changePercent24Hr);
    num mCap = num.parse(item.marketCapUsd);
    mCap *= _exchangeRate;
    bool _isFav = false;
    _items.forEach((key, value) {
      if (value.name == item.id) _isFav = true;
    });

    return InkWell(
      onTap: () {},
      child: Container(
        height: 120.0,
        padding: EdgeInsets.only(top: 10.0),
        child: Container(
          padding:
              EdgeInsets.only(top: 15.0, bottom: 15.0, left: 5.0, right: 5.0),
          color: _isFav ? Colors.black26 : Colors.black45,
          child: Row(
            children: [
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Row(children: [
                      ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: width / 3),
                          child: AutoSizeText(item.name,
                              maxLines: 2,
                              minFontSize: 0.0,
                              maxFontSize: 17.0,
                              style: TextStyle(fontSize: 17.0)))
                    ]),
                    Container(height: 5.0),
                    Row(children: [
                      !blacklist.contains(item.id)
                          ? FadeInImage(
                              image: NetworkImage(
                                  "https://static.coincap.io/assets/icons/${item.symbol.toLowerCase()}@2x.png"),
                              placeholder:
                                  AssetImage("assets/images/noimage.png"),
                              imageErrorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                    "assets/images/noimage.png",
                                    width: 30.0,
                                    height: 30.0,
                                  ),
                              fadeInDuration: const Duration(milliseconds: 100),
                              height: 32.0,
                              width: 32.0)
                          : Container(),
                      Container(width: 4.0),
                      ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: width / 3 - 40),
                          child: AutoSizeText(item.symbol, maxLines: 1))
                    ])
                  ])),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PriceText(
                        item.id,
                        item.name,
                        num.parse(item.oldValue),
                        num.parse(item.priceUsd),
                        _exchangeRate,
                        _currencySymbol,
                        _listener),
                    Text(
                        (mCap >= 0
                            ? mCap > 1
                                ? _currencySymbol +
                                    NumberFormat.currency(
                                            symbol: "", decimalDigits: 0)
                                        .format(mCap)
                                : _currencySymbol + mCap.toStringAsFixed(2)
                            : "N/A"),
                        style: TextStyle(color: Colors.grey, fontSize: 12.0)),
                    // !blacklist.contains(item.id)
                    //     ? SvgPicture.network(
                    //         "https://www.coingecko.com/coins/${item.symbol}/sparkline",
                    //         placeholderBuilder: (BuildContext context) =>
                    //             Container(width: 0, height: 35.0),
                    //         width: 105.0,
                    //         height: 35.0)
                    //     : Container(height: 35.0),
                  ]),
              Expanded(
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                change != -1000000.0
                    ? Text(
                        ((change >= 0) ? "+" : "") +
                            change.toStringAsFixed(3) +
                            "\%",
                        style: TextStyle(
                            color: ((change >= 0) ? Colors.green : Colors.red)))
                    : Text("N/A"),
                Container(width: 2),
                //Icon(_isFav ? Icons.star_rounded : Icons.star_border_rounded),
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
