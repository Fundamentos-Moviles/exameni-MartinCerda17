import 'package:buscaminas_app/screen_buscaminas.dart';
import 'package:flutter/material.dart';
import 'package:buscaminas_app/constants.dart' as consts;

void main() {
  runApp(const Buscaminas());
}

class Buscaminas extends StatelessWidget {
  const Buscaminas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscaminas',
      theme: ThemeData(
        primarySwatch: consts.primary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ScreenBuscaminas(),
      debugShowCheckedModeBanner: false,
    );
  }
}
