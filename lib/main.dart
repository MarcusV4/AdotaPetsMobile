import 'package:adota_pets_mobile/view/pages/favoritos_vazia.dart';
import 'package:adota_pets_mobile/view/pages/tela_config.dart';
import 'package:adota_pets_mobile/view/pages/tela_conversas.dart';
import 'package:adota_pets_mobile/view/pages/tela_favoritos.dart';
import 'package:adota_pets_mobile/view/pages/tela_feed.dart';
import 'package:adota_pets_mobile/view/pages/tela_login.dart';
import 'package:adota_pets_mobile/view/pages/tela_meus_pets.dart';
import 'package:adota_pets_mobile/view/pages/tela_perfil.dart';
import 'package:adota_pets_mobile/view/widgets/provider_auth.dart';
import 'package:adota_pets_mobile/view/widgets/provider_conversas.dart';
import 'package:adota_pets_mobile/view/widgets/provider_favoritos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => ConversasProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: TelaLogin(),
      routes: {
        '/login': (_) => const TelaLogin(),
        '/feed': (_) => const TelaFeed(),
        '/favoritos': (_) => const TelaFavoritos(),
        '/meusPets': (_) => const TelaMeusPets(),
        '/config': (_) => const TelaConfig(),
        '/perfil': (_) => const TelaPerfil(),
        '/conversas': (_) => const TelaConversas(),
      },
    );
  }
}
