import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import '../../constants.dart';
import '../../utils/alert_dialog.dart';
import '../../utils/helper/helper_function.dart';
import '../../utils/loading_component.dart';
import '../../utils/toast_message.dart';
import '../auth/primary_page.dart';
import 'package:crypto/crypto.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final GlobalKey<FormState> _editProfileFormKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _college = TextEditingController();
  final TextEditingController _city = TextEditingController();
  bool isLoading = false;
  String email = "",
      name = "",
      phone = "",
      college = "",
      city = "",
      studentId = "",
      qrText = "",
      needPassport = "",
      accountStatus = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      getDetails();
    });
  }
  getDetails() async {
    setState(() {
      isLoading = true;
    });
    final sp = await SharedPreferences.getInstance();
    if (sp.getString("TOKEN")!.isEmpty) {
      showToast("Session expired");
      _logOut();
      return;
    }
    try {
      final dio = Dio();
      debugPrint(  {"Authorization": "Bearer ${sp.getString("TOKEN")}"}.toString());
      final response = await dio.get(Constants.current,
          options: Options(
              contentType: Headers.jsonContentType,
              headers: {"Authorization": "Bearer ${sp.getString("TOKEN")}"}));

      debugPrint("${response.data["message"]}");
      debugPrint("${response.statusCode}");

      if (response.statusCode == 200) {
        setState(() {
          email=response.data["email"];
          name=response.data["username"];
          city="Coimbatore";
        });
      } else if (response.statusCode == 404) {
        _logOut();
      } else if (response.statusCode == 400) {
        showToast(response.data["MESSAGE"] ??
            "Token Expired");
        showToast("Session expired");
        _logOut();
      } else {
        showToast("Token Expired");
      }
    } catch (e) {
      debugPrint(e.toString());
      _logOut();
    } finally {
      setState(() {
        isLoading = false;
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 8, 44, 68),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
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
                                side: const BorderSide(color: Colors.white)),
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
              Icons.logout_rounded,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: const Color.fromARGB(255, 8, 44, 68),
        title: Text(
          "Profile",
          style: GoogleFonts.nunito(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading == true
          ? const LoadingComponent()
          : SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 128,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 8, 44, 68),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.height * 0.12,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.network(
                              "https://www.gravatar.com/avatar/${genSHA256Hash(email)}.jpg?s=200&d=robohash"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            name.toString(),
                            style: GoogleFonts.nunito(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 20,
                            right: 20,
                          ),
                          child: Container(
                            height:
                            MediaQuery.of(context).size.height * 0.300,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade500,
                                    offset: const Offset(5, 5),
                                    blurRadius: 15,
                                    spreadRadius: 1,
                                  ),
                                  const BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(-5, -5),
                                    blurRadius: 15,
                                    spreadRadius: 1,
                                  ),
                                ]),
                            child: Column(
                              children: [

                                SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20),
                                            child: Text(
                                              "Name",
                                              style: GoogleFonts.nunito(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20),
                                          child: Text(
                                            name,
                                            textAlign: TextAlign.right,
                                            style: GoogleFonts.nunito(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[700]),
                                          ),
                                        )
                                      ],
                                    )),
                                Divider(
                                    color: Colors.grey[400],
                                    indent: 20,
                                    endIndent: 20,
                                    thickness: 1,
                                    height: 0),

                                SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.20,
                                            child: Text(
                                              "Email",
                                              style: GoogleFonts.nunito(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.56,
                                            child: Text(
                                              email,
                                              textAlign: TextAlign.right,
                                              style: GoogleFonts.nunito(
                                                  fontSize: 14.0,
                                                  fontWeight:
                                                  FontWeight.w600,
                                                  color: Colors.grey[700]),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                                Divider(
                                    color: Colors.grey[400],
                                    indent: 20,
                                    endIndent: 20,
                                    thickness: 1,
                                    height: 0),
                                SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20),
                                            child: Text(
                                              "City",
                                              style: GoogleFonts.nunito(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20),
                                          child: Text(
                                            city,
                                            textAlign: TextAlign.right,
                                            style: GoogleFonts.nunito(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[700]),
                                          ),
                                        )
                                      ],
                                    )),

                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25, left: 20, right: 20),
                          child: SizedBox(
                            height:  MediaQuery.of(context).size.height *0.075,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade500,
                                      offset: const Offset(5, 5),
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                    ),
                                    const BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(-5, -5),
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                    ),
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return LayoutBuilder(builder:
                                                (context, constraints) {
                                              double width =
                                                  constraints.maxWidth;
                                              double height =
                                                  constraints.maxHeight;
                                              return CustomAlertDialog(
                                                width: width,
                                                height: height,
                                                title: "Logout",
                                                content:
                                                "Do you want to Logout?",
                                                actions: [
                                                  MaterialButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: const Text('No',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)),
                                                  ),
                                                  MaterialButton(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(20),
                                                        side:
                                                        const BorderSide(
                                                            color: Colors
                                                                .white)),
                                                    onPressed: () {
                                                      _logOut();
                                                      showToast(
                                                          "Logout successful");
                                                    },
                                                    child: const Text('Yes',
                                                        style: TextStyle(
                                                            color: Color
                                                                .fromRGBO(
                                                                11,
                                                                38,
                                                                59,
                                                                1))),
                                                  ),
                                                ],
                                              );
                                            });
                                          });
                                    },
                                    child: SizedBox(
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.0575,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.red[100],
                                                    borderRadius:
                                                    const BorderRadius
                                                        .all(
                                                        Radius.circular(
                                                            7))),
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(3),
                                                  child: Icon(
                                                    Icons.logout_rounded,
                                                    color: Colors.red,
                                                    size:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.03,
                                                  ),
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20),
                                            child: Text(
                                              "Logout",
                                              style: GoogleFonts.nunito(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          const Padding(
                                            padding:
                                            EdgeInsets.only(right: 20),
                                            child: Icon(
                                                Icons.arrow_forward_ios_sharp,
                                                size: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }





  void _logOut() {
    //clearing the cache
    SharedPreferences.getInstance().then((sp) {
      sp.setBool("LOGGEDINKEY", false);
      sp.setString("email", "");
      sp.setString("username", "");
      sp.setString("accessToken", "");
    });
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PrimaryScreen()),
            (route) => false);
  }

  genSHA256Hash(String email) {
      // debugPrint(sha256.convert(utf8.encode(message)).toString());
      return sha256.convert(utf8.encode(email)).toString();
  }
}
