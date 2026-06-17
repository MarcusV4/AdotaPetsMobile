import 'dart:convert';

import 'package:http/http.dart' as http;

import '../modelo/interessado_modelo.dart';
import '../modelo/interesse_modelo.dart';

class InteresseService {
  final String urlBase = 'http://192.168.18.26:8080/api';

  // Cria um interesse (favoritar)
  Future<InteresseModelo> criarInteresse({
    required String petId,
    required String interessadoId,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('$urlBase/interesses'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'petId': petId, 'interessadoId': interessadoId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return InteresseModelo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao criar interesse (${response.statusCode})');
    }
  }

  // Remove um interesse (desfavoritar)
  Future<void> removerInteresse({
    required String interesseId,
    required String token,
  }) async {
    final response = await http.delete(
      Uri.parse('$urlBase/interesses/remover/$interesseId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro ao remover interesse (${response.statusCode})');
    }
  }

  // Lista todos os interessados em um pet
  Future<List<InteressadoModelo>> listarInteressados({
    required String petId,
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$urlBase/interesses/$petId/usinteressados'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List json = jsonDecode(response.body);
      return json.map((e) => InteressadoModelo.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao listar interessados (${response.statusCode})');
    }
  }

  // Aprova adoção — transfere o pet para o novo dono
  Future<void> aprovarAdocao({
    required String petId,
    required String novoDonoId,
    required String token,
  }) async {
    final response = await http.put(
      Uri.parse('$urlBase/pets/$petId/adotar/$novoDonoId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao aprovar adoção (${response.statusCode})');
    }
  }
}
