import 'package:adota_pets_mobile/modelo/pet_modelo.dart';

import 'package:flutter/cupertino.dart';

import '../../services/pet_service.dart';

class FavoritesProvider extends ChangeNotifier {
  List<PetModelo> _favorites = [];

  List<PetModelo> get favorites => _favorites;

  bool isFavorite(PetModelo pet) => _favorites.any((p) => p.id == pet.id);

  void toggle(PetModelo pet) {
    if (isFavorite(pet)) {
      _favorites.removeWhere((p) => p.id == pet.id);
    } else {
      _favorites.add(pet);
    }
    notifyListeners();
  }

  Future<void> atualizarFavoritos() async {
    final petsAtualizados = await PetService().buscarPets();

    _favorites = _favorites
        .map((favorito) {
          try {
            return petsAtualizados.firstWhere((p) => p.id == favorito.id);
          } catch (_) {
            return null;
          }
        })
        .whereType<PetModelo>()
        .toList();

    notifyListeners();
  }
}
