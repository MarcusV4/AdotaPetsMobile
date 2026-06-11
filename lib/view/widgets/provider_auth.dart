import 'package:flutter/cupertino.dart';

import '../../modelo/usuario_logado.dart';

class AuthProvider extends ChangeNotifier {
  UsuarioLogado? _usuario;

  UsuarioLogado? get usuario => _usuario;
  bool get estaLogado => _usuario != null;
  String get token => _usuario?.token ?? '';
  String get usuarioId => _usuario?.id ?? '';
  String get usuarioNome => _usuario?.nome ?? '';
  String get usuarioEmail => _usuario?.email ?? '';

  void salvar(UsuarioLogado usuario) {
    _usuario = usuario;
    notifyListeners();
  }

  void sair() {
    _usuario = null;
    notifyListeners();
  }
}
