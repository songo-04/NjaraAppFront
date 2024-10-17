// ignore_for_file: non_constant_identifier_names

class Morcellement {

final String userId;
final String name_topographe;
final String contact_topographe;
final String proprietaire;
final String date_reception;
final String date_livraison;

Morcellement({
  required this.userId,
  required this.name_topographe,
  required this.contact_topographe,
  required this.proprietaire,
  required this.date_reception,
  required this.date_livraison,
});

factory Morcellement.fromJson(Map<String, dynamic> json) {
  return Morcellement(
    userId: json['userId'],
    name_topographe: json['name_topographe'],
    contact_topographe: json['contact_topographe'],
    proprietaire: json['proprietaire'],
    date_reception: json['date_reception'],
    date_livraison: json['date_livraison'],
  );
}
}