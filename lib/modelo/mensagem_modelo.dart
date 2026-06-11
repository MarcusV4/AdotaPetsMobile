// lib/modelo/mensagem.dart

class MensagemModelo {
  final String idMensagem;
  final String chatId;
  final String remetenteId;
  final String conteudo;
  final DateTime dataEnvio;
  final bool visualizacao;

  MensagemModelo({
    required this.idMensagem,
    required this.chatId,
    required this.remetenteId,
    required this.conteudo,
    required this.dataEnvio,
    required this.visualizacao,
  });

  factory MensagemModelo.fromJson(Map<String, dynamic> json) {
    return MensagemModelo(
      idMensagem: json['idMensagem']?.toString() ?? '',
      chatId: json['idChat']?['idChat']?.toString() ?? '',
      // Backend retorna "pessoaId" dentro de "idPessoa"
      remetenteId: json['idPessoa']?['pessoaId']?.toString() ?? '',
      conteudo: json['conteudo'] ?? '',
      dataEnvio: json['dataEnvio'] != null
          ? DateTime.parse(json['dataEnvio'])
          : DateTime.now(),
      visualizacao: json['visualizacao'] ?? false,
    );
  }
}
