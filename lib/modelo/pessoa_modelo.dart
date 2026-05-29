class PessoaModelo {
  final String id;
  final String nome;
  final String email;

  const PessoaModelo({
    required this.id,
    required this.nome,
    required this.email,
  });

  factory PessoaModelo.fromJson(Map<String, dynamic> json) {
    return PessoaModelo(
      id: json['id']?.toString() ?? '',
      nome: json['nome'] as String? ?? 'Dono',
      email: json['email'] as String? ?? '',
    );
  }
}
