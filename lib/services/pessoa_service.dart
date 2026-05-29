import 'dart:convert';

import 'package:adota_pets_mobile/modelo/pessoa_modelo.dart';
import 'package:http/http.dart' as http;

class PessoaService {
  final String urlBase = 'http://192.168.18.26:8080/api';

  Future<PessoaModelo> buscarPorId(String id) async {
    final response = await http.get(Uri.parse('$urlBase/pessoas/$id'));

    if (response.statusCode == 200) {
      return PessoaModelo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao buscar usuário (${response.statusCode})');
    }
  }
}
