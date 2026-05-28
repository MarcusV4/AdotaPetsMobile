import 'package:adota_pets_mobile/view/modelo/chat_modelo.dart';
import 'package:adota_pets_mobile/view/modelo/pet_modelo.dart';

class Conversa {
  final PetModelo pet;
  final List<ChatModelo> messages;

  Conversa({required this.pet}) : messages = [];
}
