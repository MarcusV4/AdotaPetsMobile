import 'package:adota_pets_mobile/modelo/usuario_logado.dart';
import 'package:adota_pets_mobile/view/widgets/botao_flutuante.dart';
import 'package:adota_pets_mobile/view/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/provider_auth.dart';
import '../widgets/provider_favoritos.dart';

class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    final favCount = context.watch<FavoritesProvider>().favorites.length;
    final auth = context.watch<AuthProvider>(); // ADICIONADO
    final nome = auth.usuarioNome;
    final email = auth.usuarioEmail;
    final inicial = nome.isNotEmpty ? nome[0].toUpperCase() : '?';
    print(auth.usuarioNome);
    print(auth.usuarioEmail);
    print(auth.usuarioId);

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
      drawer: const DrawerApp(activeItem: DrawerItem.perfil),
      floatingActionButton: const BotaoFlutuante(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          const Text(
            'Perfil',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 20),

          // Card principal do perfil
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Banner laranja claro
                Container(
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF3EE),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                ),

                // Avatar + info
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar sobreposto ao banner
                      Transform.translate(
                        offset: const Offset(0, -28),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8622A),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              inicial,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Compensa o espaço do translate
                      const SizedBox(height: 0),

                      Text(
                        nome,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 14,
                            color: Color(0xFF888888),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Estatísticas
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F0EB),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '$favCount',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFE8622A),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Favoritos',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF888888),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F0EB),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Column(
                                children: [
                                  Text(
                                    '0',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFE8622A),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Pedidos',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF888888),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Botão sair
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.read<AuthProvider>().sair();
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          icon: const Icon(
                            Icons.logout_outlined,
                            size: 18,
                            color: Color(0xFF1A1A1A),
                          ),
                          label: const Text(
                            'Sair',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Color(0xFFE0D9D1)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
