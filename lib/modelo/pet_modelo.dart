class PetModelo {
  final String id;
  final String nome;
  final String especie;
  final String raca;
  final String idade;
  final String donoId;
  final String location;
  final List<String> tags;
  final String imageUrl;

  const PetModelo({
    required this.id,
    required this.nome,
    required this.especie,
    required this.raca,
    required this.idade,
    required this.donoId,
    this.location = '',
    this.tags = const [],
    this.imageUrl = '',
  });

  factory PetModelo.fromJson(Map<String, dynamic> json) {
    return PetModelo(
      id: json['id'] as String,
      nome: json['nome'] as String,
      especie: _mapEspecie(json['especie'] as String),
      raca: json['raca'] as String,
      idade: '${json['idade']} anos',
      donoId: json['donoID'] as String,
    );
  }

  // Mapeia "cachorro"/"gato" do backend para "Dog"/"Cat"
  static String _mapEspecie(String especie) {
    switch (especie.toLowerCase()) {
      case 'cachorro':
        return 'Dog';
      case 'gato':
        return 'Cat';
      default:
        return especie;
    }
  }
}
