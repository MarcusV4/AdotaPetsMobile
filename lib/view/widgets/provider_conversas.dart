import 'package:adota_pets_mobile/modelo/chat_modelo.dart';
import 'package:adota_pets_mobile/modelo/conversa_modelo.dart';
import 'package:adota_pets_mobile/modelo/pet_modelo.dart';

import 'package:flutter/cupertino.dart';

class ConversasProvider extends ChangeNotifier {
  final List<Conversa> _conversas = [];

  List<Conversa> get conversas => List.unmodifiable(_conversas);

  // Abre ou retorna uma conversa existente para o pet
  Conversa openChat(PetModelo pet) {
    final existing = _conversas
        .where((c) => c.pet.nome == pet.nome)
        .firstOrNull;
    if (existing != null) return existing;

    final nova = Conversa(pet: pet);
    _conversas.add(nova);
    notifyListeners();
    return nova;
  }

  void sendMessage(PetModelo pet, String text) {
    final conversa = _conversas
        .where((c) => c.pet.nome == pet.nome)
        .firstOrNull;
    if (conversa == null || text.trim().isEmpty) return;

    conversa.messages.add(
      ChatModelo(text: text.trim(), time: DateTime.now(), isMe: true),
    );
    notifyListeners();
  }
}
