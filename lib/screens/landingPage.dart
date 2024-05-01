import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/alert_dialog.dart';
import '../utils/toast_message.dart';
import 'auth/primary_page.dart';

class Countdown extends StatefulWidget {
  const Countdown({super.key});

  @override
  CountdownPageState createState() => CountdownPageState();
}

class CountdownPageState extends State<Countdown>
    with TickerProviderStateMixin {
  late ScrollController scrollController;
  List<dynamic> events = [];
  List<Map<String, dynamic>> pastEvents = [];
  List<Map<String, dynamic>> todaysEvents = [];
  List<Map<String, dynamic>> upcomingEvents = [];
  String email = "",
      name = "",
      phone = "",
      college = "",
      city = "",
      studentId = "",
      qrText = "",
      needPassport = "";
  bool isLoading = true;
  bool showRegisteredEventsButton = true;

  List<dynamic>  nearbyLots=[];

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }





  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(43, 30, 56, 1),
              Color.fromRGBO(11, 38, 59, 1),
              Color.fromRGBO(15, 21, 39, 1),
            ],
          ),
        ),
        child: Scaffold(
          appBar:AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return LayoutBuilder(builder: (context, constraints) {
                          double width = constraints.maxWidth;
                          double height = constraints.maxHeight;
                          return CustomAlertDialog(
                            width: width,
                            height: height,
                            title: "Logout",
                            content: "Do you want to Logout?",
                            actions: [
                              MaterialButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('No',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              MaterialButton(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side:
                                    const BorderSide(color: Colors.white)),
                                onPressed: () {
                                  _logOut();
                                  showToast("Logout successful");
                                },
                                child: const Text('Yes',
                                    style: TextStyle(
                                        color: Color.fromRGBO(11, 38, 59, 1))),
                              ),
                            ],
                          );
                        });
                      });
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              )
            ],
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/logo.png',
                            width: constraints.maxWidth * 0.8,
                          ),
                        ),
                         Center(
                          child: Chip(
                            label: Text(
                              "Smart Parking System",
                              style:GoogleFonts.quicksand(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white,width: 2)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Welcome to our Smart Parking System! Say goodbye to the hassle of finding a parking spot. With our app, discover nearby parking lots tailored to your location. Easily navigate to your chosen lot and enjoy a seamless experience. Simply scan a QR code upon entry to secure your spot, and again at exit for hassle-free payment. Your parking made simple, your journey effortless.",
                              style: GoogleFonts.quicksand(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }


  void _logOut() {
    SharedPreferences.getInstance().then((sp) {
      sp.setBool("LOGGEDINKEY", false);
      sp.setString("NAME", "");
      // sp.setString("EMAIL", "");
      sp.setString("PHONE", "");
      sp.setString("COLLEGE", "");
      sp.setString("CITY", "");
      sp.setString("TOKEN", "");
    });
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PrimaryScreen()),
            (route) => false);
  }
}

//