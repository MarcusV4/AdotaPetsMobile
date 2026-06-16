import 'package:adota_pets_mobile/modelo/pet_modelo.dart';
import 'package:adota_pets_mobile/view/widgets/botao_flutuante.dart';

import 'package:adota_pets_mobile/view/widgets/corpo_feed.dart';
import 'package:adota_pets_mobile/view/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaFeed extends StatelessWidget {
  const TelaFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        // elevation: 0,
        // titleSpacing: 0,
        // leading: Builder(
        //   builder: (ctx) => IconButton(
        //     icon: const Icon(Icons.menu, color: Color(0xFF1A1A1A)),
        //     onPressed: () => Scaffold.of(ctx).openDrawer(),
        //   ),
        // ),
        title: Text(
          "AdotaPets",
          style: TextStyle(
            // fontSize: 18,
            // fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Theme.of(context).dividerColor),
        ),
      ),
      drawer: const DrawerApp(activeItem: DrawerItem.feed),
      floatingActionButton: const BotaoFlutuante(),
      body: const BodyFeed(),
    );
  }
}
