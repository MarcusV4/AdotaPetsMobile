import 'package:flutter/cupertino.dart';

import '../../modelo/pet_modelo.dart';
import '../../services/interesse_service.dart';

class InteresseProvider extends ChangeNotifier {
  // petId → interesseId
  final Map<String, String> _interesses = {};
  // petId → PetModelo (para exibir na tela de favoritos)
  final Map<String, PetModelo> _petsFavoritados = {};

  bool temInteresse(String petId) => _interesses.containsKey(petId);
  String? interesseId(String petId) => _interesses[petId];

  List<PetModelo> get petsFavoritados => _petsFavoritados.values.toList();

  final InteresseService _service = InteresseService();

  Future<void> toggleInteresse({
    // required String petId,
    required PetModelo pet,
    required String interessadoId,
    required String token,
  }) async {
    final petId = pet.id;
    final jaTemInteresse = temInteresse(petId);
    final idAnterior = _interesses[petId];

    if (jaTemInteresse) {
      _interesses.remove(petId);
      _petsFavoritados.remove(petId);
    } else {
      _interesses[petId] = 'pending';
      _petsFavoritados[petId] = pet;
    }
    notifyListeners();

    try {
      if (jaTemInteresse) {
        // Remove o interesse no backend
        await _service.removerInteresse(interesseId: idAnterior!, token: token);
      } else {
        // Cria o interesse e substitui o placeholder pelo id real
        final interesse = await _service.criarInteresse(
          petId: petId,
          interessadoId: interessadoId,
          token: token,
        );
        _interesses[petId] = interesse.interesseId;
        notifyListeners();
      }
    } catch (e) {
      // Se der erro, reverte o estado para o que era antes
      if (jaTemInteresse) {
        _interesses[petId] = idAnterior!; // restaura
        _petsFavoritados[petId] = pet;
      } else {
        _interesses.remove(petId); // desfaz
        _petsFavoritados.remove(petId);
      }
      notifyListeners();
      rethrow; // propaga o erro para a tela exibir o snackbar
    }
  }
}
