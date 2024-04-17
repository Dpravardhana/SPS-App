
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/primary_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Landing Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logOut(context);
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Landing page',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  void _logOut(BuildContext context) {
    //clearing the cache
    SharedPreferences.getInstance().then((sp) {
      sp.setBool("LOGGEDINKEY", false);
      sp.setString("NAME", "");
      sp.setString("EMAIL", "");
      sp.setString("TOKEN", "");
    });
    Navigator.pushAndRemoveUntil(
        context ,
        MaterialPageRoute(builder: (context) => const PrimaryScreen()),
            (route) => false);
  }
}
