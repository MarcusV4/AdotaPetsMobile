import 'package:adota_pets_mobile/view/modelo/pet_modelo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardConversas extends StatelessWidget {
  final PetModelo pet;
  const CardConversas({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Foto do pet
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              pet.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 64,
                height: 64,
                color: const Color(0xFFEAE4DD),
                child: const Icon(Icons.pets, color: Color(0xFFBBB3AA)),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'mvc7731',
                  style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3EE),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE8622A).withOpacity(0.3),
                    ),
                  ),
                  child: const Text(
                    'Dono',
                    style: TextStyle(fontSize: 11, color: Color(0xFFE8622A)),
                  ),
                ),
              ],
            ),
          ),

          // Tempo
          const Text(
            'agora',
            style: TextStyle(fontSize: 11, color: Color(0xFF888888)),
          ),
        ],
      ),
    );
  }
}
