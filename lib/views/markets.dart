import 'package:coinfav/models/markets_model.dart';
import 'package:coinfav/models/web_socket_model.dart';
import 'package:coinfav/providers/api_provider.dart';
import 'package:coinfav/views/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MarketsPage extends StatefulWidget {
  final String exchangeId;
  final String name;

  MarketsPage({required this.exchangeId, required this.name});

  @override
  _MarketsPageState createState() => _MarketsPageState();
}

class _MarketsPageState extends State<MarketsPage> {
  ValueNotifier<num> _listener = ValueNotifier(0);
  final _channel = WebSocketChannel.connect(
    //Uri.parse('wss://ws.coincap.io/trades/binance'),
    Uri.parse('wss://ws.coincap.io/prices?assets=ALL'),
  );
  var _list = <MarketsModel>[];
  bool _isLoading = true;
  int _columns = 2;

  void fetchData() async {
    try {
      var data = await ApiProvider.fetchMarkets(widget.exchangeId);
      if (data != null) {
        _list = data;

        _channel.stream.listen((message) {
          var data = webSocketModelFromJson(message);
          var item = _list.where((element) => element.baseId == data.base);
          if (item.isNotEmpty) {
            _listener.value = num.parse(item.first.priceUsd);
            item.first.priceUsd = data.priceUsd.toString();
            if (!mounted) return;
            setState(() {});
          }
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
        title: Text('Exchanges'),
        actions: [
          IconButton(
              onPressed: () => setState(() {
                    _columns = _columns == 2 ? 1 : 2;
                  }),
              icon: Icon(_columns == 1 ? Icons.dashboard : Icons.view_agenda))
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : bodyWidget(),
    );
  }

  Widget bodyWidget() {
    return StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8.0),
        crossAxisCount: _columns,
        itemCount: _list.length,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        itemBuilder: (context, index) {
          return cardItemExchanges(_list[index]);
        },
        staggeredTileBuilder: (index) => StaggeredTile.fit(1));
  }

  Widget cardItemExchanges(MarketsModel item) {
    return ElevatedButton(
      onPressed: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(item.baseSymbol),
          Text(
              "Volume: " +
                  double.parse(item.priceUsd).toStringAsFixed(2) +
                  " USD",
              style: TextStyle(color: Colors.grey[400], fontSize: 11.0)),
          ValueListenableBuilder(
            valueListenable: _listener,
            builder: (context, value, child) =>
                _listener.value < num.parse(item.priceUsd)
                    ? Icon(
                        Icons.arrow_upward_sharp,
                        color: Colors.greenAccent,
                      )
                    : Icon(
                        Icons.arrow_downward_sharp,
                        color: Colors.redAccent,
                      ),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        primary: Variables.kSecondaryColor,
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        shadowColor: Variables.kThirdColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}
