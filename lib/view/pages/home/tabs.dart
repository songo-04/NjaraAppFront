// ignore_for_file: use_build_context_synchronously

import 'package:appfront/constant/color.dart';
import 'package:appfront/controller/navigation/navigationBuilder.dart';
import 'package:appfront/view/pages/auth/login.dart';
import 'package:appfront/view/pages/home/contact/contact.dart';
import 'package:appfront/view/pages/home/dashboard/dashboard.dart';
import 'package:appfront/view/pages/home/engine/engine.dart';
import 'package:appfront/view/pages/home/profil/profil.dart';
import 'package:appfront/view/pages/home/search/searchPage.dart';
import 'package:appfront/view/pages/home/task/taskHomePage.dart';
import 'package:appfront/view/pages/home/work/work.dart';
import 'package:appfront/view/pages/notification/notificationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  int _index = 0;
  final List<Widget> _screens = [
    const Dashboard(),
    const Engine(),
     Work(),
    const TaskHomePage(),
    const Contact(),
  ];
  bool charge = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                navigation(context, const NotificationPage());
              },
              icon: const Icon(Icons.notifications),
            ),
            IconButton(
              onPressed: () {
                navigation(context, const SearchPage());
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        drawer: _drawer(),
        body: _screens[_index],
        bottomNavigationBar: NavigationBar(
          indicatorColor: mainColor,
          backgroundColor: bgColor,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.gradient), label: 'Appareil'),
            NavigationDestination(icon: Icon(Icons.work_history), label: 'Works'),
            NavigationDestination(icon: Icon(Icons.menu_book), label: 'Taches'),
            NavigationDestination(icon: Icon(Icons.person_search), label: 'Contacts'),
          ],
          selectedIndex: _index,
          onDestinationSelected: (value){
            setState(() {
              _index=value;
            });
          },
        )

        // BottomNavigationBar(
        //   iconSize: 26,
        //   showSelectedLabels: true,
        //   showUnselectedLabels: true,
        //   selectedItemColor: inversColor,
        //   unselectedItemColor: inversColor,
        //   elevation: 0,
        //   unselectedFontSize: 12,
        //   selectedFontSize: 12,
        //   selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        //   unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        //   items: const [
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.home, color: inversColor),
        //         label: 'Home',
        //         backgroundColor: bgColor),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.engineering, color: inversColor),
        //         label: 'Engine',
        //         backgroundColor: bgColor),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.work, color: inversColor),
        //         label: 'Work',
        //         backgroundColor: bgColor),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.task, color: inversColor),
        //         label: 'Task',
        //         backgroundColor: bgColor),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.person, color: inversColor),
        //         label: 'Contact',
        //         backgroundColor: bgColor),
        //   ],
        //   onTap: (value) {
        //     setState(() {
        //       _index = value;
        //     });
        //   },
        // ),
        );
  }

  Widget _drawer() {
    return Drawer(
      backgroundColor: bgColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            charge
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: () {
                        navigation(context, const Profile());
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(radius: 24),
                          SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'user name',
                                style: TextStyle(
                                  color: inversColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Email address',
                                style: TextStyle(
                                  color: inversColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
            Column(
              children: [
                _btn(Icons.safety_check, 'j'),
                _btn(Icons.settings, 'setting'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: _deconnected(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btn(IconData icon, String txt) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(6),
        width: double.infinity,
        decoration: BoxDecoration(
          // color: mainColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 60, child: Icon(icon, size: 26)),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                txt,
                style: const TextStyle(
                  color: inversColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deconnected() {
    return InkWell(
      onTap: () async {
        await _storage.delete(key: 'token');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false);
      },
      child: const SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.power_settings_new, size: 28),
            Text(
              'Disconnected',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
