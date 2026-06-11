// lib/view/widgets/lista_conversas.dart

import 'package:adota_pets_mobile/modelo/chat_modelo.dart';
import 'package:adota_pets_mobile/view/widgets/card_conversas.dart';
import 'package:flutter/material.dart';

class ListaConversas extends StatelessWidget {
  final List<ChatModelo> conversas;

  const ListaConversas({super.key, required this.conversas});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: conversas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return CardConversas(conversa: conversas[index]);
      },
    );
  }
}
