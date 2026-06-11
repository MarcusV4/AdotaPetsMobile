import 'dart:convert';

import 'package:adota_pets_mobile/modelo/usuario_logado.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String urlBase = 'http://192.168.18.26:8080/api/auth';

  Future<UsuarioLogado> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$urlBase/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      print(response.body);
      final json = jsonDecode(response.body);
      return UsuarioLogado(
        id: json['id'],
        nome: json['nome'],
        email: json['email'],
        token: json['token'],
      );
    } else if (response.statusCode == 401) {
      throw Exception('Email ou senha inválidos');
    } else {
      throw Exception('Email ou senha inválidos');
    }
  }

  Future<UsuarioLogado> registrar(
    String nome,
    String email,
    String senha,
  ) async {
    final response = await http.post(
      Uri.parse('$urlBase/registro'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nome': nome, 'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return await login(email, senha);
    } else if (response.statusCode == 400) {
      final json = jsonDecode(response.body);
      throw Exception(json['message']);
    } else {
      throw Exception('Erro ao cadastrar (${response.statusCode})');
    }
  }

  // Decodifica o payload do JWT para ler os dados sem requisição extra
  Map<String, dynamic> _decodificarJwt(String token) {
    try {
      final partes = token.split('.');
      if (partes.length != 3) return {};
      String payload = partes[1];
      while (payload.length % 4 != 0) {
        payload += '=';
      }
      final decodificado = utf8.decode(base64Url.decode(payload));
      return jsonDecode(decodificado) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }
}
