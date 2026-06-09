import 'package:adota_pets_mobile/view/pages/conversas_vazia.dart';
import 'package:adota_pets_mobile/view/widgets/botao_flutuante.dart';
import 'package:adota_pets_mobile/view/widgets/drawer.dart';
import 'package:adota_pets_mobile/view/widgets/lista_conversas.dart';
import 'package:adota_pets_mobile/view/widgets/provider_conversas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/provider_favoritos.dart';

class TelaConversas extends StatelessWidget {
  const TelaConversas({super.key});

  @override
  Widget build(BuildContext context) {
    final conversas = context.watch<ConversasProvider>().conversas;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F0EB),
        elevation: 0,
        titleSpacing: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF1A1A1A)),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text(
          'AdotaPets',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE0D9D1)),
        ),
      ),
      drawer: const DrawerApp(activeItem: DrawerItem.conversas),
      floatingActionButton: const BotaoFlutuante(),
      body: conversas.isEmpty
          ? const ConversasVazia()
          : ListaConversas(conversas: conversas),
    );
  }
}
