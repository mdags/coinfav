import 'package:coinfav/views/home.dart';
import 'package:coinfav/views/variables.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinFav',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
          primaryColor: Variables.kPrimaryColor,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Variables.kPrimaryColor),
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.grey[700]),
    );
  }
}
