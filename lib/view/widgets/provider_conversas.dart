// lib/view/widgets/provider_conversas.dart

import 'package:adota_pets_mobile/modelo/chat_modelo.dart';
import 'package:adota_pets_mobile/modelo/usuario_logado.dart';

import 'package:flutter/material.dart';

import '../../services/chat_service.dart';

enum ConversasStatus { inicial, carregando, sucesso, erro }

class ConversasProvider extends ChangeNotifier {
  List<ChatModelo> conversas = [];
  ConversasStatus status = ConversasStatus.inicial;
  String? erroMensagem;

  Future<void> carregarConversas(UsuarioLogado usuario) async {
    status = ConversasStatus.carregando;
    erroMensagem = null;
    notifyListeners();

    try {
      final service = ChatApiService(token: usuario.token);
      conversas = await service.listarChatsPorUsuario(usuario.id);
      status = ConversasStatus.sucesso;
    } catch (e) {
      erroMensagem = e.toString();
      status = ConversasStatus.erro;
    }

    notifyListeners();
  }
}
