// lib/view/widgets/provider_mensagens.dart

import 'dart:async';

import 'package:adota_pets_mobile/modelo/mensagem_modelo.dart';
import 'package:adota_pets_mobile/modelo/usuario_logado.dart';

import 'package:flutter/material.dart';

import '../../services/chat_service.dart';

class MensagensProvider extends ChangeNotifier {
  List<MensagemModelo> mensagens = [];
  bool carregando = false;
  String? erro;

  Timer? _pollingTimer;
  String? _chatIdAtual;
  UsuarioLogado? _usuario;

  void iniciarPolling(String chatId, UsuarioLogado usuario) {
    _chatIdAtual = chatId;
    _usuario = usuario;

    _buscarMensagens();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _buscarMensagens();
    });
  }

  void pararPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> _buscarMensagens() async {
    if (_chatIdAtual == null || _usuario == null) return;

    try {
      final service = ChatApiService(token: _usuario!.token);
      final novas = await service.listarMensagens(_chatIdAtual!);
      if (novas.length != mensagens.length) {
        mensagens = novas;
        notifyListeners();
      }
    } catch (e) {
      erro = e.toString();
      notifyListeners();
    }
  }

  Future<void> enviarMensagem({
    required String chatId,
    required String conteudo,
    required UsuarioLogado usuario,
  }) async {
    try {
      final service = ChatApiService(token: usuario.token);
      final nova = await service.enviarMensagem(
        chatId: chatId,
        remetenteId: usuario.id,
        conteudo: conteudo,
      );
      mensagens = [...mensagens, nova];
      notifyListeners();
    } catch (e) {
      erro = 'Erro ao enviar: ${e.toString()}';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    pararPolling();
    super.dispose();
  }
}
