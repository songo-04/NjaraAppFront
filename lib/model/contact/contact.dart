// ignore_for_file: non_constant_identifier_names, constant_identifier_names

class ContactModel {
  final String contact_name;
  final String contact_number;
  final String contact_email;
  final String contact_note;

  ContactModel({
    required this.contact_name,
    required this.contact_number,
    required this.contact_email,
    required this.contact_note,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      contact_name: json['contact_name'],
      contact_number: json['contact_number'],
      contact_email: json['contact_email'],
      contact_note: json['contact_note'],
    );
  }
}
