import 'package:flutter/material.dart';
import 'package:flutter_qr/home_page.dart';

void main(){
  runApp(FlutterQRApp());
}


class FlutterQRApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FlutterQR",
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}
