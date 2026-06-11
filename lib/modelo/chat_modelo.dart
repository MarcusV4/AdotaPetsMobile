// lib/modelo/chat.dart

class PessoaResumo {
  final String id;
  final String nome;
  final String? email;

  PessoaResumo({required this.id, required this.nome, this.email});

  factory PessoaResumo.fromJson(Map<String, dynamic> json) {
    return PessoaResumo(
      // Backend retorna "pessoaId", não "id"
      id: json['pessoaId']?.toString() ?? '',
      nome: json['nome'] ?? '',
      email: json['email'],
    );
  }
}

class PetResumo {
  final String id;
  final String nome;
  final String? foto;

  PetResumo({required this.id, required this.nome, this.foto});

  factory PetResumo.fromJson(Map<String, dynamic> json) {
    return PetResumo(
      // Backend retorna "petId", não "id"
      id: json['petId']?.toString() ?? '',
      nome: json['nome'] ?? '',
      foto: json['imagemUrl'],
    );
  }
}

class ChatModelo {
  final String idChat;
  final PetResumo? pet;
  final PessoaResumo? pessoa1;
  final PessoaResumo? pessoa2;
  final PessoaResumo? idInteressado;

  ChatModelo({
    required this.idChat,
    this.pet,
    this.pessoa1,
    this.pessoa2,
    this.idInteressado,
  });

  factory ChatModelo.fromJson(Map<String, dynamic> json) {
    return ChatModelo(
      idChat: json['idChat']?.toString() ?? '',
      pet: json['pet'] != null ? PetResumo.fromJson(json['pet']) : null,
      pessoa1: json['pessoa1'] != null
          ? PessoaResumo.fromJson(json['pessoa1'])
          : null,
      pessoa2: json['pessoa2'] != null
          ? PessoaResumo.fromJson(json['pessoa2'])
          : null,
      idInteressado: json['idInteressado'] != null
          ? PessoaResumo.fromJson(json['idInteressado'])
          : null,
    );
  }

  /// Retorna o nome do outro participante (não o usuário logado)
  String nomeOutraPessoa(String meuId) {
    if (pessoa1?.id == meuId) return pessoa2?.nome ?? 'Desconhecido';
    return pessoa1?.nome ?? 'Desconhecido';
  }
}
