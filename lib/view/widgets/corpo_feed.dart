import 'package:adota_pets_mobile/view/modelo/pet_modelo.dart';
import 'package:adota_pets_mobile/view/pages/tela_detalhe_pet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:adota_pets_mobile/view/widgets/card_pet.dart';
import 'package:adota_pets_mobile/view/widgets/filtro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BodyFeed extends StatefulWidget {
  final List<PetModelo> pets;
  const BodyFeed({required this.pets});

  @override
  State<BodyFeed> createState() => _FeedBodyState();
}

class _FeedBodyState extends State<BodyFeed> {
  String _activeFilter = 'Todos';
  final List<Filtros> _filters = [
    Filtros(label: 'Todos', icon: Icons.pets),
    Filtros(label: 'Cães', icon: Icons.sports),
    Filtros(label: 'Gatos', icon: Icons.catching_pokemon),
  ];

  List<PetModelo> get _filtered {
    if (_activeFilter == 'Todos') return widget.pets;
    if (_activeFilter == 'Cães') {
      return widget.pets.where((p) => p.type == 'Dog').toList();
    }
    return widget.pets.where((p) => p.type == 'Cat').toList();
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
          child: const TextField(
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Buscar por nome, raça ou localização...',
              hintStyle: TextStyle(fontSize: 13, color: Color(0xFFBBB3AA)),
              prefixIcon: Icon(
                Icons.search,
                color: Color(0xFFBBB3AA),
                size: 20,
              ),
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
                      Icon(
                        f.icon,
                        size: 16,
                        color: isActive
                            ? Colors.white
                            : const Color(0xFF888888),
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
        ..._filtered.map(
          (pet) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CardPet(
              pet: pet,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TelaDetalhePet(pet: pet)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
