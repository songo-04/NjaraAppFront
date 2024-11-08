// ignore_for_file: file_names

import 'dart:convert';
import 'package:appfront/controller/api/APIController.dart';
import 'package:appfront/utils/spinkit.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:appfront/model/contact/contact.dart';
import 'package:appfront/view/pages/home/contact/createContactPage.dart';
import 'package:appfront/constant/color.dart';
import 'package:url_launcher/url_launcher.dart';

class AfficheContact extends StatefulWidget {
  const AfficheContact({super.key});

  @override
  State<AfficheContact> createState() => _AfficheContactState();
}

class _AfficheContactState extends State<AfficheContact>
    with AutomaticKeepAliveClientMixin {
  static List<ContactModel> _contactList = [];
  static bool _dataFetched = false;
  Logger log = Logger();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  bool _isLoading = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (!_dataFetched) {
      _fetchContact();
    }
  }

  Future<void> _fetchContact() async {
    if (_dataFetched) return;

    setState(() {
      _isLoading = true;
    });
    try {
      final response = await APIController().getAll('contact');
      log.i(response.body);
      final List<dynamic> datas = json.decode(response.body);
      setState(() {
        _contactList =
            datas.map((data) => ContactModel.fromJson(data)).toList();
        _isLoading = false;
        _dataFetched = true;
      });
    } catch (e) {
      log.e('Error fetching contacts: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> refreshContacts() async {
    setState(() {
      _dataFetched = false;
    });
    await _fetchContact();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return (_isLoading)
        ? Center(child: fadingCircle)
        : _contactList.isEmpty
            ? _emptyContactList()
            : ListView.builder(
                itemCount: _contactList.length,
                itemBuilder: (context, index) {
                  return _contactItem(context, _contactList[index]);
                },
              );
  }

  Widget _emptyContactList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.contact_phone,
            size: 100,
            color: textColorSecondary,
          ),
          const SizedBox(height: 20),
          const Text(
            "Aucun contact trouvé",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColorSecondary,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Ajoutez des contacts pour les voir ici",
            style: TextStyle(
              fontSize: 16,
              color: textColorSecondary,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactCreatePage()));
            },
            icon: const Icon(Icons.add),
            label: const Text("Ajouter un contact"),
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
              foregroundColor: bgColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _contactItem(BuildContext context, ContactModel contact) {
  return Card(
    elevation: 2,
    color: cardColor.withOpacity(0.4),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      contentPadding: const EdgeInsets.all(16),
      onTap: () => _showContactOptions(context, contact),
      leading: const CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(
            'https://th.bing.com/th/id/R.3ca27c4e03d21a9687d35546930bd036?rik=suSQLI%2fHOdZDjw&pid=ImgRaw&r=0'),
      ),
      title: Text(
        contact.contact_name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            contact.contact_number,
            style: const TextStyle(fontSize: 14, color: textColorSecondary),
          ),
          Text(
            contact.contact_email,
            style: const TextStyle(fontSize: 14, color: textColorSecondary),
          ),
          if (contact.contact_note.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              contact.contact_note,
              style: const TextStyle(
                fontSize: 12,
                color: textColorSecondary,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
      trailing: const Icon(Icons.chevron_right, color: textColorSecondary),
    ),
  );
}

void _showContactOptions(BuildContext context, ContactModel contact) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.75,
        expand: false,
        builder: (_, controller) {
          return SingleChildScrollView(
            controller: controller,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://th.bing.com/th/id/R.3ca27c4e03d21a9687d35546930bd036?rik=suSQLI%2fHOdZDjw&pid=ImgRaw&r=0'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      contact.contact_name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _infoTile(Icons.phone, contact.contact_number),
                  _infoTile(Icons.email, contact.contact_email),
                  if (contact.contact_note.isNotEmpty)
                    _infoTile(Icons.note, contact.contact_note),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _actionButton(Icons.call, 'Call', () async {
                        final Uri launchUri = Uri(
                          scheme: 'tel',
                          path: contact.contact_number,
                        );
                        try {
                          await launchUrl(launchUri,
                              mode: LaunchMode.externalApplication);
                        } catch (e) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Impossible de lancer l'appel: $e"),
                            ),
                          );
                        }
                      }),
                      _actionButton(Icons.message, 'Message', () async {
                        await _sendMessage(context, contact.contact_number);
                      }),
                      _actionButton(Icons.edit, 'Edit', () {
                        Navigator.pop(context);
                      }),
                      _actionButton(Icons.delete, 'Delete', () {
                        Navigator.pop(context);
                      }),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _infoTile(IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(icon, color: textColorSecondary),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
  );
}

Widget _actionButton(IconData icon, String label, VoidCallback onPressed) {
  return ElevatedButton.icon(
    icon: Icon(icon),
    label: Text(label),
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: mainColor,
      foregroundColor: bgColor,
    ),
  );
}

Future<void> _sendMessage(BuildContext context, String phoneNumber) async {
  final Uri smsUri = Uri(
    scheme: 'sms',
    path: phoneNumber,
  );
  try {
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw 'Could not launch $smsUri';
    }
  } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Failed to open message: $e"),
      ),
    );
  }
}
