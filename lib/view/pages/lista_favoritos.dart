import 'package:adota_pets_mobile/modelo/pet_modelo.dart';
import 'package:adota_pets_mobile/view/pages/tela_detalhe_pet.dart';
import 'package:adota_pets_mobile/view/widgets/card_pet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListaFavoritos extends StatelessWidget {
  final List<PetModelo> pets;
  const ListaFavoritos({required this.pets});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Seus ',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              TextSpan(
                text: 'Favoritos',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE8622A),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Pets que você salvou',
          style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
        ),
        const SizedBox(height: 20),
        ...pets.map(
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
