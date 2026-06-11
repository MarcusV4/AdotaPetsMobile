import 'dart:convert';

import 'package:adota_pets_mobile/modelo/pet_modelo.dart';
import 'package:http/http.dart' as http;

class PetService {
  final String urlBase = 'http://192.168.18.26:8080/api';

  Future<List<PetModelo>> buscarPets() async {
    final response = await http.get(Uri.parse('$urlBase/pets/disponiveis'));

    if (response.statusCode == 200) {
      final List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((pet) => PetModelo.fromJson(pet)).toList();
    } else {
      throw Exception('Erro ao buscar pets (${response.statusCode})');
    }
  }

  Future<List<PetModelo>> buscarMeusPets(String donoId) async {
    final response = await http.get(
      Uri.parse('http://192.168.18.26:8080/api/pessoas/$donoId'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final List petsJson = json['pet'] ?? [];

      return petsJson.map((pet) => PetModelo.fromJson(pet)).toList();
    }

    throw Exception('Erro ao carregar meus pets');
  }

  Future<void> alterarDisponibilidade(String petId) async {
    final response = await http.put(Uri.parse('$urlBase/pets/adocao/$petId'));

    if (response.statusCode != 200) {
      throw Exception('Erro ao alterar disponibilidade');
    }
  }

  Future<List<PetModelo>> buscarPetsPorEspecie(String especie) async {
    final response = await http.get(
      Uri.parse('$urlBase/pets/especie/$especie'),
    );

    if (response.statusCode == 200) {
      final List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((pet) => PetModelo.fromJson(pet)).toList();
    } else {
      throw Exception(
        'Erro ao buscar pets por espécie (${response.statusCode})',
      );
    }
  }
}
