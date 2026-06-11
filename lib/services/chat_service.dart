// lib/services/chat_api_service.dart

import 'dart:convert';

import 'package:adota_pets_mobile/modelo/chat_modelo.dart';

import 'package:adota_pets_mobile/modelo/mensagem_modelo.dart';
import 'package:http/http.dart' as http;

class ChatApiService {
  // Mesma base URL do AuthService
  static const String _urlBase = 'http://192.168.18.26:8080/api';

  final String token;

  ChatApiService({required this.token});

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // ─── CHATS ──────────────────────────────────────────────

  /// Busca todos os chats do usuário logado
  Future<List<ChatModelo>> listarChatsPorUsuario(String pessoaId) async {
    final response = await http.get(
      Uri.parse('$_urlBase/chats/usuario/$pessoaId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> lista = jsonDecode(response.body);
      return lista.map((e) => ChatModelo.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar conversas: ${response.statusCode}');
    }
  }

  /// Cria um novo chat no backend
  Future<ChatModelo> criarChat({
    required String petId,
    required String pessoa1Id,
    required String pessoa2Id,
    required String interessadoId,
  }) async {
    final response = await http.post(
      Uri.parse('$_urlBase/chats'),
      headers: _headers,
      body: jsonEncode({
        'petId': petId,
        'pessoa1Id': pessoa1Id,
        'pessoa2Id': pessoa2Id,
        'interessadoId': interessadoId,
      }),
    );

    if (response.statusCode == 201) {
      return ChatModelo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao criar chat: ${response.statusCode}');
    }
  }

  // ─── MENSAGENS ──────────────────────────────────────────

  /// Busca todas as mensagens de um chat
  Future<List<MensagemModelo>> listarMensagens(String chatId) async {
    final response = await http.get(
      Uri.parse('$_urlBase/mensagens/chat/$chatId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> lista = jsonDecode(response.body);
      return lista.map((e) => MensagemModelo.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar mensagens: ${response.statusCode}');
    }
  }

  /// Envia uma nova mensagem
  Future<MensagemModelo> enviarMensagem({
    required String chatId,
    required String remetenteId,
    required String conteudo,
  }) async {
    final response = await http.post(
      Uri.parse('$_urlBase/mensagens'),
      headers: _headers,
      body: jsonEncode({
        'chatId': chatId,
        'remetenteId': remetenteId,
        'conteudo': conteudo,
      }),
    );

    if (response.statusCode == 201) {
      return MensagemModelo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao enviar mensagem: ${response.statusCode}');
    }
  }
}
