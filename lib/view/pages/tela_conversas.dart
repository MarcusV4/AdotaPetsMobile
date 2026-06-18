// lib/view/pages/tela_conversas.dart
//
// Substitua o conteúdo atual do seu tela_conversas.dart por este.

import 'package:adota_pets_mobile/modelo/usuario_logado.dart';
import 'package:adota_pets_mobile/view/pages/conversas_vazia.dart';
import 'package:adota_pets_mobile/view/widgets/botao_flutuante.dart';
import 'package:adota_pets_mobile/view/widgets/drawer.dart';
import 'package:adota_pets_mobile/view/widgets/lista_conversas.dart';
import 'package:adota_pets_mobile/view/widgets/provider_auth.dart';
import 'package:adota_pets_mobile/view/widgets/provider_conversas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaConversas extends StatefulWidget {
  const TelaConversas({super.key});

  @override
  State<TelaConversas> createState() => _TelaConversasState();
}

class _TelaConversasState extends State<TelaConversas> {
  @override
  void initState() {
    super.initState();
    // Carrega as conversas assim que a tela abre
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final usuario = context.read<AuthProvider>().usuario;
      if (usuario != null) {
        context.read<ConversasProvider>().carregarConversas(usuario);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConversasProvider>();

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
          'AdotaPets',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          // Botão de recarregar manual
          IconButton(
            icon: Icon(Icons.refresh, color: Theme.of(context).iconTheme.color),
            onPressed: () {
              final usuario = context.read<AuthProvider>().usuario;
              if (usuario != null) {
                provider.carregarConversas(usuario);
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Theme.of(context).dividerColor),
        ),
      ),
      drawer: const DrawerApp(activeItem: DrawerItem.conversas),
      floatingActionButton: const BotaoFlutuante(),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(ConversasProvider provider) {
    switch (provider.status) {
      case ConversasStatus.carregando:
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF6B4226)),
        );

      case ConversasStatus.erro:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFF6B4226),
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                provider.erroMensagem ?? 'Erro ao carregar conversas',
                style: const TextStyle(color: Color(0xFF6B4226)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B4226),
                ),
                onPressed: () {
                  final usuario = context.read<AuthProvider>().usuario;
                  if (usuario != null) {
                    provider.carregarConversas(usuario);
                  }
                },
                child: const Text(
                  'Tentar novamente',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );

      case ConversasStatus.sucesso:
        return provider.conversas.isEmpty
            ? const ConversasVazia()
            : ListaConversas(conversas: provider.conversas);

      case ConversasStatus.inicial:
      default:
        return const SizedBox.shrink();
    }
  }
}
