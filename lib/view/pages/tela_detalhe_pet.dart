import 'package:adota_pets_mobile/modelo/pet_modelo.dart';
import 'package:adota_pets_mobile/view/pages/tela_chat.dart';
import 'package:adota_pets_mobile/view/widgets/drawer.dart';
import 'package:adota_pets_mobile/view/widgets/infos_pet.dart';
import 'package:adota_pets_mobile/view/widgets/provider_conversas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/provider_favoritos.dart';

class TelaDetalhePet extends StatelessWidget {
  final PetModelo pet;

  const TelaDetalhePet({super.key, required this.pet});

  // Dados extras fixos por enquanto (podem virar campos do PetModel futuramente)
  String get _species => pet.especie == 'Dog' ? 'Cão' : 'Gato';
  String get _size => pet.especie == 'Dog' ? 'Grande' : 'Pequeno';
  String get _sex => 'Fêmea';
  String get _about =>
      '${pet.nome} é uma ${pet.raca} brincalhona e carinhosa que adora todo mundo que conhece. '
      'Ela gosta de longas caminhadas no parque, jogar bola e se aconchegar no sofá. '
      '${pet.nome} se dá bem com crianças e outros cachorros, tornando-a a companheira familiar perfeita.';

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favs, _) {
        final isFav = favs.isFavorite(pet);

        return Scaffold(
          backgroundColor: const Color(0xFFF5F0EB),
          drawer: DrawerApp(activeItem: DrawerItem.feed),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF5F0EB),
            elevation: 0,
            titleSpacing: 0,
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu, color: Color(0xFF1A1A1A)),
                onPressed: () =>
                    Scaffold.of(ctx).openDrawer(), // ALTERADO: era () {}
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
          body: Column(
            children: [
              // Conteúdo rolável
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Botão voltar
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: 18,
                            color: Color(0xFF1A1A1A),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Voltar',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Imagem hero
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            pet.imageUrl,
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 220,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAE4DD),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.pets,
                                  size: 48,
                                  color: Color(0xFFBBB3AA),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Gradiente + info sobre a imagem
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(16),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.65),
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pet.nome,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${pet.raca} • ${pet.idade} • $_sex',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Botão favorito
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: GestureDetector(
                            onTap: () => favs.toggle(pet),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                size: 20,
                                color: isFav
                                    ? const Color(0xFFE8622A)
                                    : const Color(0xFF888888),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Grid de info
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.4,
                      children: [
                        CardInfo(label: 'Espécie', value: _species),
                        CardInfo(label: 'Porte', value: _size),
                        CardInfo(label: 'Sexo', value: _sex),
                        CardInfo(label: 'Idade', value: pet.idade),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Sobre
                    CardSobre(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Sobre ${pet.nome}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text('🐾', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _about,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF555555),
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Temperamento
                    CardSobre(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Temperamento',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: pet.tags
                                .map(
                                  (tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF3EE),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(
                                          0xFFE8622A,
                                        ).withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      tag,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFFE8622A),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Saúde
                    CardSobre(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Saúde',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 12),
                          CardSaude(
                            icon: Icons.shield_outlined,
                            color: const Color(0xFF4CAF50),
                            label: 'Vacinado',
                          ),
                          const SizedBox(height: 8),
                          CardSaude(
                            icon: Icons.content_cut,
                            color: const Color(0xFF2196F3),
                            label: 'Castrado',
                          ),
                          const SizedBox(height: 8),
                          CardSaude(
                            icon: Icons.location_on_outlined,
                            color: const Color(0xFFE8622A),
                            label: pet.location,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Publicado por
                    CardSobre(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Publicado por',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF888888),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAE4DD),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    'M',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF888888),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Abrigo / Tutor',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.email_outlined,
                                        size: 12,
                                        color: Color(0xFF888888),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'mvc7730@gmail.com',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF888888),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Botão fixo no rodapé
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                color: const Color(0xFFF5F0EB),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: isFav
                            ? () {
                                context.read<ConversasProvider>().openChat(pet);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TelaChat(pet: pet),
                                  ),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.chat_bubble_outline, size: 18),
                        label: Text('Adotar ${pet.nome}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8622A),
                          disabledBackgroundColor: const Color(
                            0xFFE8622A,
                          ).withOpacity(0.4),
                          foregroundColor: Colors.white,
                          disabledForegroundColor: Colors.white70,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          size: 14,
                          color: isFav
                              ? const Color(0xFFE8622A)
                              : const Color(0xFF888888),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isFav
                              ? 'Pet favoritado! Botão de adoção liberado.'
                              : 'Favorite este pet para iniciar o chat',
                          style: TextStyle(
                            fontSize: 12,
                            color: isFav
                                ? const Color(0xFFE8622A)
                                : const Color(0xFF888888),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
