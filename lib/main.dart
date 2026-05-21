import 'package:adota_pets_mobile/view/pages/favoritos.dart';
import 'package:adota_pets_mobile/view/pages/tela_login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: TelaLogin(),
    );
  }
}
