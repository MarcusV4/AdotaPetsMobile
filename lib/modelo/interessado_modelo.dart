class InteressadoModelo {
  final String id;
  final String nome;
  final String email;

  const InteressadoModelo({
    required this.id,
    required this.nome,
    required this.email,
  });

  factory InteressadoModelo.fromJson(Map<String, dynamic> json) {
    return InteressadoModelo(
      id: json['id']?.toString() ?? '',
      nome: json['nome'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }
}
