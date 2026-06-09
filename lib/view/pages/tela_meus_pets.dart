import 'package:adota_pets_mobile/view/widgets/botao_flutuante.dart';
import 'package:adota_pets_mobile/view/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaMeusPets extends StatelessWidget {
  const TelaMeusPets({super.key});

  @override
  Widget build(BuildContext context) {
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
          'PawFinder',
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
      drawer: const DrawerApp(activeItem: DrawerItem.meusPets),
      floatingActionButton: const BotaoFlutuante(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Meus ',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  TextSpan(
                    text: 'Pets',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE8622A),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Pets que você cadastrou para adoção',
              style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
            ),
            const Expanded(child: _EmptyState()),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFE8622A).withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.pets, size: 38, color: Color(0xFFE8622A)),
          ),
          const SizedBox(height: 20),
          const Text(
            'Nenhum pet cadastrado',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
              children: [
                TextSpan(text: 'Use o botão '),
                TextSpan(
                  text: '+',
                  style: TextStyle(
                    color: Color(0xFFE8622A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: ' para cadastrar seu primeiro pet'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
