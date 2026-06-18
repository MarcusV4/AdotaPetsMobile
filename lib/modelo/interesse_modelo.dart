class InteresseModelo {
  final String interesseId;
  final String petId;
  final String interessadoId;

  const InteresseModelo({
    required this.interesseId,
    required this.petId,
    required this.interessadoId,
  });

  factory InteresseModelo.fromJson(Map<String, dynamic> json) {
    return InteresseModelo(
      interesseId: json['idInteresse']?.toString() ?? '',
      petId: json['idPet']?.toString() ?? '',
      interessadoId: json['idInteressado']?.toString() ?? '',
    );
  }
}
