// ignore_for_file: non_constant_identifier_names

class DelimitationModel {
  final String userId;
  final String name_topographe;
  final String contact_topographe;
  final String proprietaire;
  final String createdAt;
  final String updatedAt;
  DelimitationModel({
    required this.userId,
    required this.name_topographe,
    required this.contact_topographe,
    required this.proprietaire,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DelimitationModel.fromJson(Map<String, dynamic> json) {
    return DelimitationModel(
        userId: json['userId'],
        name_topographe: json['name_topographe'],
        contact_topographe: json['contact_topographe'],
        proprietaire: json['proprietaire'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt']);
  }
}
