import 'package:adota_pets_mobile/modelo/pet_modelo.dart';
import 'package:adota_pets_mobile/services/pet_service.dart';

import 'package:adota_pets_mobile/view/pages/tela_detalhe_pet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:adota_pets_mobile/view/widgets/card_pet.dart';
import 'package:adota_pets_mobile/view/widgets/filtro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BodyFeed extends StatefulWidget {
  const BodyFeed();

  @override
  State<BodyFeed> createState() => _FeedBodyState();
}

class _FeedBodyState extends State<BodyFeed> {
  final PetService petService = PetService();
  late Future<List<PetModelo>> PetsFuture;

  String _activeFilter = 'Todos';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  static final List<Filtros> _filters = [
    Filtros(label: 'Todos', icon: const FaIcon(FontAwesomeIcons.paw)),
    Filtros(label: 'Cães', icon: const FaIcon(FontAwesomeIcons.dog)),
    Filtros(label: 'Gatos', icon: const FaIcon(FontAwesomeIcons.cat)),
  ];

  void initState() {
    super.initState();
    PetsFuture = PetService().buscarPets();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PetModelo> _applyFilter(List<PetModelo> pets) {
    var resultado = pets;

    if (_activeFilter == 'Cães')
      resultado = resultado.where((p) => p.especie == 'Dog').toList();
    if (_activeFilter == 'Gatos')
      resultado = resultado.where((p) => p.especie == 'Cat').toList();

    final query = _searchQuery.toLowerCase().trim();

    if (query.isEmpty) return resultado;

    return resultado.where((p) {
      final nomeMatch = p.nome.toLowerCase().contains(query);

      final racaMatch = p.raca.toLowerCase().contains(query);

      final temperamentoMatch = p.temperamento.any(
        (t) =>
            t.toLowerCase().contains(query) ||
            PetModelo.formatarTemperamento(t).toLowerCase().contains(query),
      );

      return nomeMatch || racaMatch || temperamentoMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        // Título
        const Text(
          'Encontre Seu Novo',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const Text(
          'Melhor Amigo',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE8622A),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Conheça pets adoráveis que buscam um lar para sempre',
          style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
        ),
        const SizedBox(height: 20),

        // Busca
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0D9D1)),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _searchQuery = v),
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Buscar por nome, raça ou temperamento...',
              hintStyle: TextStyle(fontSize: 13, color: Color(0xFFBBB3AA)),
              prefixIcon: Icon(
                Icons.search,
                color: Color(0xFFBBB3AA),
                size: 20,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Color(0xFF888888),
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Filtros
        Row(
          children: _filters.map((f) {
            final isActive = _activeFilter == f.label;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => setState(() => _activeFilter = f.label),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFFE8622A) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isActive
                          ? const Color(0xFFE8622A)
                          : const Color(0xFFE0D9D1),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconTheme(
                        data: IconThemeData(
                          color: isActive
                              ? Colors.white
                              : const Color(0xFF888888),
                          size: 14,
                        ),
                        child: f.icon,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        f.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? Colors.white
                              : const Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Cards
        FutureBuilder<List<PetModelo>>(
          future: PetsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: CircularProgressIndicator(color: Color(0xFFE8622A)),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 40,
                        color: Color(0xFF888888),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Erro ao carregar pets',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => setState(() {
                          PetsFuture = PetService().buscarPets();
                        }),
                        child: const Text(
                          'Tentar novamente',
                          style: TextStyle(color: Color(0xFFE8622A)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final pets = _applyFilter(snapshot.data ?? []);

            if (pets.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.search_off,
                        size: 40,
                        color: Color(0xFF888888),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _searchQuery.isNotEmpty
                            ? 'Nenhum pet encontrado para "$_searchQuery"'
                            : 'Nenhum pet encontrado',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: pets
                  .map(
                    (pet) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CardPet(
                        pet: pet,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TelaDetalhePet(pet: pet),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}
