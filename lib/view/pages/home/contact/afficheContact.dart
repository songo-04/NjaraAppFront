// ignore_for_file: file_names

import 'dart:convert';
import 'package:appfront/view/pages/home/contact/contactDetail.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:appfront/constant/link.dart';
import 'package:appfront/model/contact/contact.dart';

class AfficheContact extends StatefulWidget {
  const AfficheContact({super.key});

  @override
  State<AfficheContact> createState() => _AfficheContactState();
}

class _AfficheContactState extends State<AfficheContact> {
  List<ContactModel> _contactList = [];
  Logger log = Logger();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  bool charge = false;
  @override
  void initState() {
    super.initState();
    _fetchContact();
  }

  Future<void> _fetchContact() async {
    setState(() {
      charge = true;
    });
    try {
      final token = await storage.read(key: 'token');
      final response = await http.get(
        Uri.parse('${urlApi}contact'),
        headers: {"Authorization": token ?? ''},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log.i(response.body);
        final List<dynamic> datas = json.decode(response.body);
        setState(() {
          _contactList = datas.map((data) => ContactModel.fromJson(data)).toList();
          charge = false;
        });
      } else {
        throw Exception('Failed to load contacts: ${response.statusCode}');
      }
    } catch (e) {
      log.e('Error fetching contacts: $e');
      setState(() {
        charge = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: (charge)?const Center(child: CircularProgressIndicator()):
          ListView.builder(
            itemCount: _contactList.length,
            itemBuilder: (context, index) {
              return _contactItem(context,_contactList[index]);
            },
      ),
    );
  }
}

Widget _contactItem(BuildContext context,ContactModel contact){
  return 
  InkWell(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const ContactDetail()));
    },
    child: Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
    color: Colors.grey[200],
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
       _avatar('https://th.bing.com/th/id/R.3ca27c4e03d21a9687d35546930bd036?rik=suSQLI%2fHOdZDjw&pid=ImgRaw&r=0'),
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(contact.contact_name),
          Text(contact.contact_number),
          Text(contact.contact_email),
          Text(contact.contact_note),
        ],
       )
       ],
    ),)
  );
}

Widget _avatar(String avatar){
  return  Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      image: DecorationImage(image: NetworkImage(avatar)),
    ),

  );
}
