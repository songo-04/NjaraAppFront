// ignore_for_file: non_constant_identifier_names

class Morcellement {
  final String userId;
  final String contact_proprietaire;
  final String proprietaire;
  final String numero_parcelle;
  final String section;
  final String canton;
  final String titre_foncier;
  final String propriete_dite;

  final String date_reception;
  final String date_livraison;

  Morcellement({
    required this.userId,
    required this.contact_proprietaire,
    required this.proprietaire,
    required this.numero_parcelle,
    required this.section,
    required this.canton,
    required this.titre_foncier,
    required this.propriete_dite,
    required this.date_reception,
    required this.date_livraison,
  });

  factory Morcellement.fromJson(Map<String, dynamic> json) {
    return Morcellement(
      userId: json['userId'],
      contact_proprietaire: json['contact_proprietaire'],
      proprietaire: json['proprietaire'],
      numero_parcelle: json['numero_parcelle'],
      section: json['section'],
      canton: json['canton'],
      titre_foncier: json['titre_foncier'],
      propriete_dite: json['propriete_dite'],
      date_reception: json['date_reception'],
      date_livraison: json['date_livraison'],
    );
  }
}
