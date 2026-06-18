import 'package:adota_pets_mobile/modelo/pet_modelo.dart';
import 'package:adota_pets_mobile/services/pet_service.dart';
import 'package:adota_pets_mobile/view/pages/tela_detalhe_pet.dart';
import 'package:adota_pets_mobile/view/widgets/botao_flutuante.dart';
import 'package:adota_pets_mobile/view/widgets/card_pet.dart';
import 'package:adota_pets_mobile/view/widgets/drawer.dart';
import 'package:adota_pets_mobile/view/widgets/provider_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaMeusPets extends StatefulWidget {
  const TelaMeusPets({super.key});

  @override
  State<TelaMeusPets> createState() => _TelaMeusPetsState();
}

class _TelaMeusPetsState extends State<TelaMeusPets> {
  late Future<List<PetModelo>> _petsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final usuarioId = context.read<AuthProvider>().usuarioId;
    // print(usuarioId);

    _petsFuture = PetService().buscarMeusPets(usuarioId);
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
        //   builder: (ctx) => IconButton(
        //     icon: const Icon(Icons.menu, color: Color(0xFF1A1A1A)),
        //     onPressed: () => Scaffold.of(ctx).openDrawer(),
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
      drawer: const DrawerApp(activeItem: DrawerItem.meusPets),
      floatingActionButton: const BotaoFlutuante(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Meus ',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
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
            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<List<PetModelo>>(
                future: _petsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFE8622A),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 40,
                            color: Color(0xFF888888),
                          ),
                          const SizedBox(height: 12),
                          const Text('Erro ao carregar seus pets'),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                final usuarioId = context
                                    .read<AuthProvider>()
                                    .usuarioId;

                                _petsFuture = PetService().buscarMeusPets(
                                  usuarioId,
                                );
                              });
                            },
                            child: const Text(
                              'Tentar novamente',
                              style: TextStyle(color: Color(0xFFE8622A)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final pets = snapshot.data ?? [];

                  if (pets.isEmpty) {
                    return const _EmptyState();
                  }

                  return ListView.builder(
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      final pet = pets[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: CardPet(
                          pet: pet,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TelaDetalhePet(pet: pet),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
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
