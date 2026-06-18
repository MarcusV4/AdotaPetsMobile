import 'package:adota_pets_mobile/view/pages/favoritos_vazia.dart';
import 'package:adota_pets_mobile/view/pages/lista_favoritos.dart';
import 'package:adota_pets_mobile/view/widgets/botao_flutuante.dart';
import 'package:adota_pets_mobile/view/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/provider_favoritos.dart';

class TelaFavoritos extends StatefulWidget {
  const TelaFavoritos({super.key});

  State<TelaFavoritos> createState() => _TelaFavoritosState();
}

class _TelaFavoritosState extends State<TelaFavoritos> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesProvider>().atualizarFavoritos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        // elevation: 0,
        // titleSpacing: 0,
        // leading: Builder(
        //   builder: (context) => IconButton(
        //     icon: const Icon(Icons.menu, color: Color(0xFF1A1A1A)),
        //     onPressed: () => Scaffold.of(context).openDrawer(),
        //   ),
        // ),
        title: Text(
          'AdotaPets',
          style: TextStyle(
            // fontSize: 18,
            // fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Theme.of(context).dividerColor),
        ),
      ),
      drawer: const DrawerApp(activeItem: DrawerItem.favoritos),
      floatingActionButton: const BotaoFlutuante(),
      body: Consumer<FavoritesProvider>(
        builder: (context, favs, _) {
          final petsDisponiveis = favs.favorites
              .where((pet) => pet.disponivelParaAdocao)
              .toList();

          if (petsDisponiveis.isEmpty) {
            return const FavoritosVazia();
          }
          return ListaFavoritos(pets: petsDisponiveis);
        },
      ),
    );
  }
}
