import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_parking_system/screens/auth/login_page.dart';
import 'package:smart_parking_system/screens/auth/primary_page.dart';
import 'package:smart_parking_system/utils/helper/helper_function.dart';

import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      debugPrint(value.toString());
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserLoggedInStatus();
    });
    debugPrint("Hi  --- ${_isSignedIn.toString()}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anokha 2024',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      routes: {
        '/': (context) =>
        _isSignedIn ? const HomePage() : const PrimaryScreen(),

        // '/': (context) => CrewPage(),

        '/events': (context) => const HomePage() ,//dummy
        '/home': (context) => const HomePage(),
        '/logreg': (context) => const LoginReg(),
      },
    );
  }
}
