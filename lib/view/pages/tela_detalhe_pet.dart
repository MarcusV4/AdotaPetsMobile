// lib/view/pages/tela_detalhe_pet.dart

import 'dart:ui';

import 'package:adota_pets_mobile/modelo/chat_modelo.dart';
import 'package:adota_pets_mobile/modelo/pessoa_modelo.dart';
import 'package:adota_pets_mobile/modelo/pet_modelo.dart';
import 'package:adota_pets_mobile/modelo/usuario_logado.dart';

import 'package:adota_pets_mobile/services/pessoa_service.dart';
import 'package:adota_pets_mobile/services/pet_service.dart';
import 'package:adota_pets_mobile/view/pages/tela_chat.dart';
import 'package:adota_pets_mobile/view/widgets/drawer.dart';
import 'package:adota_pets_mobile/view/widgets/infos_pet.dart';
import 'package:adota_pets_mobile/view/widgets/modal_interessados.dart';
import 'package:adota_pets_mobile/view/widgets/provider_auth.dart';
import 'package:adota_pets_mobile/view/widgets/provider_favoritos.dart';
import 'package:adota_pets_mobile/view/widgets/provider_mensagem.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../services/chat_service.dart';
import '../widgets/provider_conversas.dart';
import '../widgets/provider_interesse.dart';

class TelaDetalhePet extends StatefulWidget {
  final PetModelo pet;
  const TelaDetalhePet({super.key, required this.pet});

  @override
  State<TelaDetalhePet> createState() => _TelaDetalhePetState();
}

class _TelaDetalhePetState extends State<TelaDetalhePet> {
  late Future<PessoaModelo?> _futureDonoAtual;

  @override
  void initState() {
    super.initState();
    _futureDonoAtual = PessoaService().buscarPorId(widget.pet.donoId);
  }

  PetModelo get pet => widget.pet;
  String get _species => pet.especie;

  //   State<TelaDetalhePet> createState() => _TelaDetalhePetState();
  // }

  // class _TelaDetalhePetState extends State<TelaDetalhePet>{

  // String get _species => pet.especie;

  Future<void> _abrirChat(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final token = auth.token;
    final usuarioId = auth.usuarioId;
    final usuario = auth.usuario;

    if (usuario == null) return;

    try {
      final service = ChatApiService(token: token);

      // Verifica se já existe chat para este pet
      final chats = await service.listarChatsPorUsuario(usuarioId);
      ChatModelo? chatExistente;
      try {
        chatExistente = chats.firstWhere((c) => c.pet?.id == pet.id.toString());
      } catch (_) {
        chatExistente = null;
      }

      ChatModelo chat;
      if (chatExistente != null) {
        chat = chatExistente;
      } else {
        chat = await service.criarChat(
          petId: pet.id.toString(),
          pessoa1Id: usuarioId,
          pessoa2Id: pet.donoId,
          interessadoId: usuarioId,
        );
      }

      if (!context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => MensagensProvider(),
            child: TelaChat(chat: chat),
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao abrir chat: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth2 = context.watch<AuthProvider>();
    final usuarioId = context.read<AuthProvider>().usuarioId;
    final meuPet = pet.donoId == usuarioId;
    final interesses = context.watch<InteresseProvider>();

    return Consumer<FavoritesProvider>(
      builder: (context, favs, _) {
        final isFav = interesses.temInteresse(pet.id);

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          drawer: const DrawerApp(activeItem: DrawerItem.feed),
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
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: 18,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Voltar',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface,
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
                            pet.imagemUrl,
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 220,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.pets,
                                  size: 48,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ),
                          ),
                        ),
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
                                  '${pet.raca} • ${pet.idade} • ${PetModelo.formatarSexo(pet.sexo)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (!meuPet)
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: GestureDetector(
                              onTap: () =>
                                  _toggleFavorito(context, auth2, interesses),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
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
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.4,
                      children: [
                        CardInfo(label: 'Espécie', value: _species),
                        CardInfo(
                          label: 'Porte',
                          value: PetModelo.formatarPorte(pet.porte),
                        ),
                        CardInfo(
                          label: 'Sexo',
                          value: PetModelo.formatarSexo(pet.sexo),
                        ),
                        CardInfo(label: 'Idade', value: pet.idade),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (pet.descricao.isNotEmpty)
                      CardSobre(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Sobre ${pet.nome}',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  '🐾',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              pet.descricao,
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (pet.temperamento.isNotEmpty)
                      CardSobre(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Temperamento',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: pet.temperamento
                                  .map(
                                    (t) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                      child: Text(
                                        PetModelo.formatarTemperamento(t),
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
                    CardSobre(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Saúde',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (pet.vacinado)
                            CardSaude(
                              icon: Icons.shield_outlined,
                              color: Theme.of(context).colorScheme.onSurface,
                              label: 'Vacinado',
                            ),
                          if (pet.vacinado) const SizedBox(height: 8),
                          if (pet.castrado)
                            CardSaude(
                              icon: Icons.content_cut,
                              color: Theme.of(context).colorScheme.onSurface,
                              label: 'Castrado',
                            ),
                          if (!pet.vacinado && !pet.castrado)
                            Text(
                              'Sem informações de saúde',
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    CardSobre(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Publicado por',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 12),
                          FutureBuilder<PessoaModelo?>(
                            future: _futureDonoAtual,
                            builder: (context, snapshot) {
                              final nome =
                                  snapshot.data?.nome ?? 'Carregando...';
                              final email = snapshot.data?.email ?? '';
                              final inicial = nome.isNotEmpty
                                  ? nome[0].toUpperCase()
                                  : '?';
                              return Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        inicial,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        nome,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                      ),
                                      if (email.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.email_outlined,
                                              size: 12,
                                              color: Theme.of(
                                                context,
                                              ).iconTheme.color,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              email,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(
                                                  context,
                                                ).hintColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              );
                            },
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
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    if (meuPet)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () => _abrirInteressados(context, auth2),
                            icon: Icon(
                              Icons.people_outline,
                              size: 18,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            label: Text(
                              'Ver Interessados',
                              style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ),

                    if (meuPet)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () => _colocarParaAdocao(context, auth2),
                            icon: const Icon(
                              Icons.volunteer_activism_outlined,
                              size: 18,
                            ),
                            label: Text("Colocar ${pet.nome} para Adoção"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE8622A),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Botão "Adotar" — só para quem NÃO é dono, e só após favoritar
                    if (!meuPet)
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: isFav ? () => _abrirChat(context) : null,
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
                    if (!meuPet)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            size: 14,
                            color: isFav
                                ? const Color(0xFFE8622A)
                                : Theme.of(context).hintColor,
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
                                  : Theme.of(context).hintColor,
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

  Future<void> _toggleFavorito(
    BuildContext context,
    AuthProvider auth,
    InteresseProvider interesses,
  ) async {
    try {
      await interesses.toggleInteresse(
        pet: pet,
        interessadoId: auth.usuarioId,
        token: auth.token,
      );

      if (context.mounted) {
        context.read<FavoritesProvider>().toggle(pet);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _abrirInteressados(BuildContext context, AuthProvider auth) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ModalInteressados(pet: pet, auth: auth),
    );
  }

  Widget _imagePlaceholder() => Container(
    height: 220,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Center(
      child: Icon(Icons.pets, size: 48, color: Theme.of(context).hintColor),
    ),
  );

  Future<void> _colocarParaAdocao(
    BuildContext context,
    AuthProvider auth,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.18.26:8080/api/pets/adocao/${pet.id}'),
        headers: {'Authorization': 'Bearer ${auth.token}'},
      );

      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${pet.nome} está disponível para adoção! 🐾'),
              backgroundColor: const Color(0xFFE8622A),
            ),
          );
        }
      } else {
        throw Exception('Erro ${response.statusCode}');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
