import 'package:coinfav/models/exchanges_model.dart';
import 'package:coinfav/providers/api_provider.dart';
import 'package:coinfav/views/markets.dart';
import 'package:coinfav/views/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ExchangesPage extends StatefulWidget {
  @override
  _ExchangesPageState createState() => _ExchangesPageState();
}

class _ExchangesPageState extends State<ExchangesPage> {
  var _list = <ExchangesModel>[];
  bool _isLoading = true;
  int _columns = 2;

  void fetchData() async {
    try {
      var data = await ApiProvider.fetchExchanges();
      if (data != null) {
        _list = data;
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

  Widget cardItemExchanges(ExchangesModel item) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
          builder: (context) => MarketsPage(
                exchangeId: item.exchangeId,
                name: item.name,
              ))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.name),
          Text(
              "Volume: " +
                  double.parse(item.volumeUsd).toStringAsFixed(2) +
                  " USD",
              style: TextStyle(color: Colors.grey[400], fontSize: 11.0)),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
                "% " + double.parse(item.percentTotalVolume).toStringAsFixed(2),
                style: TextStyle(color: Colors.grey[400])),
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
