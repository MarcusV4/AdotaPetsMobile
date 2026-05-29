import 'package:adota_pets_mobile/modelo/pet_modelo.dart';

import 'package:flutter/cupertino.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<PetModelo> _favorites = [];

  List<PetModelo> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(PetModelo pet) => _favorites.any((p) => p.nome == pet.nome);

  void toggle(PetModelo pet) {
    if (isFavorite(pet)) {
      _favorites.removeWhere((p) => p.nome == pet.nome);
    } else {
      _favorites.add(pet);
    }
    notifyListeners();
  }
}
