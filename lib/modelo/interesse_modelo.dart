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
      interesseId:
          json['interesseId']?.toString() ?? json['id']?.toString() ?? '',
      petId: json['petId']?.toString() ?? '',
      interessadoId: json['interessadoId']?.toString() ?? '',
    );
  }
}
