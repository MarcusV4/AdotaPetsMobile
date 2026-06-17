import 'package:flutter/cupertino.dart';

import '../../services/interesse_service.dart';

class InteresseProvider extends ChangeNotifier {
  // petId → interesseId
  final Map<String, String> _interesses = {};

  bool temInteresse(String petId) => _interesses.containsKey(petId);
  String? interesseId(String petId) => _interesses[petId];

  final InteresseService _service = InteresseService();

  Future<void> toggleInteresse({
    required String petId,
    required String interessadoId,
    required String token,
  }) async {
    if (temInteresse(petId)) {
      // Desfavoritar — remove o interesse no backend
      final id = _interesses[petId]!;
      await _service.removerInteresse(interesseId: id, token: token);
      _interesses.remove(petId);
    } else {
      // Favoritar — cria o interesse no backend
      final interesse = await _service.criarInteresse(
        petId: petId,
        interessadoId: interessadoId,
        token: token,
      );
      _interesses[petId] = interesse.interesseId;
    }
    notifyListeners();
  }
}
