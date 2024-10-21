// ignore_for_file: use_build_context_synchronously

import 'package:appfront/constant/color.dart';
import 'package:appfront/controller/navigation/navigationBuilder.dart';
import 'package:appfront/view/pages/auth/login.dart';
import 'package:appfront/view/pages/home/contact/contact.dart';
import 'package:appfront/utils/spinkit.dart';
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
  static const List<Widget> _screens = [
    Dashboard(),
    Engine(),
    Work(),
    TaskHomePage(),
    Contact(),
  ];
  bool charge = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            color: bgColor,
            boxShadow: [
              BoxShadow(
                color: Colors.transparent,
                spreadRadius: 0,
                blurRadius: 0,
              ),
            ],
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leadingWidth: 60,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: textColor, size: 28),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            title: const Text(
              'AppName',
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: textColor, size: 26),
                onPressed: () => navigation(context, const NotificationPage()),
                tooltip: 'Notifications',
              ),
              IconButton(
                icon: const Icon(Icons.search, color: textColor, size: 26),
                onPressed: () => navigation(context, const SearchPage()),
                tooltip: 'Search',
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      drawer: _buildDrawer(),
      body: _screens[_index],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
              _buildNavItem(
                  Icons.gradient_outlined, Icons.gradient, 'Appareil', 1),
              _buildNavItem(
                  Icons.work_history_outlined, Icons.work_history, 'Works', 2),
              _buildNavItem(
                  Icons.menu_book_outlined, Icons.menu_book, 'Taches', 3),
              _buildNavItem(Icons.person_search_outlined, Icons.person_search,
                  'Contacts', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, IconData activeIcon, String label, int index) {
    bool isSelected = _index == index;
    return GestureDetector(
      onTap: () => setState(() => _index = index),
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(isSelected ? -0.2 : 0.0),
        alignment: Alignment.center,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(
              horizontal: 12, vertical: isSelected ? 8 : 12),
          decoration: BoxDecoration(
            color: isSelected ? mainColor.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: mainColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? mainColor : textColorSecondary,
                size: 28,
              ),
              if (isSelected) ...[
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: mainColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: mainColor.withOpacity(0.3),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: bgColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildUserInfo(),
            Column(
              children: [
                _buildDrawerButton(Icons.safety_check, 'j', () {}),
                _buildDrawerButton(Icons.settings, 'setting', () {}),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: _buildDisconnectButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return FutureBuilder<Map<String, String>>(
      future: _getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return fadingCircle;
        }
        if (snapshot.hasError) {
          return const Text('Error loading user info');
        }
        final userInfo =
            snapshot.data ?? {'name': 'User', 'email': 'email@example.com'};

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: GestureDetector(
            onTap: () => navigation(context, const Profile()),
            child: Row(
              children: [
                const CircleAvatar(radius: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userInfo['name']!,
                        style: const TextStyle(
                          color: inversColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        userInfo['email']!,
                        style: const TextStyle(
                          color: inversColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, String>> _getUserInfo() async {
    // Implement this method to fetch user info from storage or API
    // For example:
    // final name = await _storage.read(key: 'userName') ?? 'User';
    // final email = await _storage.read(key: 'userEmail') ?? 'email@example.com';
    // return {'name': name, 'email': email};

    // Simulated delay for demonstration
    await Future.delayed(const Duration(seconds: 1));
    return {'name': 'John Doe', 'email': 'john.doe@example.com'};
  }

  Widget _buildDrawerButton(IconData icon, String txt, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white.withOpacity(0.05),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: mainColor.withOpacity(0.8)),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                txt,
                style: const TextStyle(
                  color: inversColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right,
                size: 20, color: mainColor.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildDisconnectButton() {
    return InkWell(
      onTap: _handleDisconnect,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.power_settings_new, size: 24, color: Colors.red),
            SizedBox(width: 12),
            Text(
              'Disconnect',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDisconnect() async {
    await _storage.delete(key: 'token');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false,
    );
  }
}
