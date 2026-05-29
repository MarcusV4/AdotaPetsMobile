class PetModelo {
  final String id;
  final String nome;
  final String especie;
  final String raca;
  final String idade;
  final String sexo;
  final String descricao;
  final bool vacinado;
  final bool castrado;
  final List<String> temperamento;
  final String porte;
  final String donoId;
  final String location;
  final String imageUrl;

  const PetModelo({
    required this.id,
    required this.nome,
    required this.especie,
    required this.raca,
    required this.idade,
    required this.sexo,
    required this.descricao,
    required this.vacinado,
    required this.castrado,
    required this.temperamento,
    required this.porte,
    required this.donoId,
    this.location = '',
    this.imageUrl = '',
  });

  factory PetModelo.fromJson(Map<String, dynamic> json) {
    return PetModelo(
      id: json['id'] as String,
      nome: json['nome'] as String,
      especie: _mapEspecie(json['especie'] as String),
      raca: json['raca'] as String,
      idade: '${json['idade']} anos',
      sexo: json['sexo'] as String? ?? '',
      descricao: json['descricao'] as String? ?? '',
      vacinado: json['vacinado'] as bool? ?? false,
      castrado: json['castrado'] as bool? ?? false,
      temperamento: (json['temperamento'] as List<dynamic>? ?? [])
          .map((t) => t.toString())
          .toList(),
      porte: json['porte'] as String? ?? '',
      donoId: json['donoID'] as String,
    );
  }

  // Mapeia "cachorro"/"gato" do backend para "Dog"/"Cat"
  static String _mapEspecie(String especie) {
    switch (especie.toLowerCase()) {
      case 'cachorro':
        return 'Cachorro';
      case 'gato':
        return 'Gato';
      default:
        return especie;
    }
  }

  static String formatarTemperamento(String t) {
    const map = {
      'CALMO': 'Calmo',
      'CARINHOSO': 'Carinhoso',
      'INDEPENDENTE': 'Independente',
      'AMIGAVEL': 'Amigável',
      'BRINCALHAO': 'Brincalhão',
      'GENTIL': 'Gentil',
      'ENERGETICO': 'Energético',
      'LEAL': 'Leal',
      'INTELIGENTE': 'Inteligente',
      'CURIOSO': 'Curioso',
      'QUIETO': 'Quieto',
    };
    return map[t.toUpperCase()] ?? t;
  }

  static String formatarPorte(String t) {
    const map = {'PEQUENO': 'Pequeno', 'MEDIO': 'Médio', 'GRANDE': 'Grande'};
    return map[t.toUpperCase()] ?? t;
  }

  static String formatarSexo(String t) {
    const map = {'MACHO': 'Macho', 'FEMEA': 'Fêmea'};
    return map[t.toUpperCase()] ?? t;
  }
}
