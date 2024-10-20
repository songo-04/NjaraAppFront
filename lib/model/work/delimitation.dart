// ignore_for_file: non_constant_identifier_names

class DelimitationModel {
  final String userId;
  final String contact_proprietaire;
  final String proprietaire;
  final String numero_parcelle;
  final String section;
  final String canton;
  final String titre_foncier;
  final String propriete_dite;
  final String createdAt;
  final String updatedAt;
  DelimitationModel({
    required this.userId,
    required this.contact_proprietaire,
    required this.proprietaire,
    required this.numero_parcelle,
    required this.section,
    required this.canton,
    required this.titre_foncier,
    required this.propriete_dite,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DelimitationModel.fromJson(Map<String, dynamic> json) {
    return DelimitationModel(
        userId: json['userId'],
        contact_proprietaire: json['contact_proprietaire'],
        proprietaire: json['proprietaire'],
        numero_parcelle: json['numero_parcelle'],
        section: json['section'],
        canton: json['canton'],
        titre_foncier: json['titre_foncier'],
        propriete_dite: json['propriete_dite'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt']);
  }
}
