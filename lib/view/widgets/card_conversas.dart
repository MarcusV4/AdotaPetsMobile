import 'package:adota_pets_mobile/view/modelo/pet_modelo.dart';
import 'package:adota_pets_mobile/view/pages/tela_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../modelo/conversa_modelo.dart';

class CardConversas extends StatelessWidget {
  final Conversa conversa;
  const CardConversas({required this.conversa});

  @override
  Widget build(BuildContext context) {
    final pet = conversa.pet;
    final lastMsg = conversa.messages.isNotEmpty
        ? conversa.messages.last
        : null;

    return GestureDetector(
      // ADICIONADO: tap no card abre o chat do pet
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TelaChat(pet: pet)),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
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
                  // ADICIONADO: mostra última mensagem ou nome do dono
                  Text(
                    lastMsg != null ? lastMsg.text : 'mvc7731',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF888888),
                    ),
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
            // ADICIONADO: horário da última mensagem
            Text(
              lastMsg != null
                  ? '${lastMsg.time.hour.toString().padLeft(2, '0')}:${lastMsg.time.minute.toString().padLeft(2, '0')}'
                  : 'agora',
              style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
            ),
          ],
        ),
      ),
    );
  }
}
