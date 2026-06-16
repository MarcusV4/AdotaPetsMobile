import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _modoEscuro = false;

  bool get modoEscuro => _modoEscuro;

  void alternar() {
    _modoEscuro = !_modoEscuro;
    notifyListeners();
  }

  void definir(bool valor) {
    _modoEscuro = valor;
    notifyListeners();
  }
}
