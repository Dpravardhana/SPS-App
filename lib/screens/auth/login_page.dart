import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking_system/screens/auth/register_page.dart';
import '../../constants.dart';
import '../../home.dart';
import '../../utils/helper/helper_function.dart';
import '../../utils/loading_component.dart';
import '../../utils/toast_message.dart';
import 'package:crypto/crypto.dart';

class LoginReg extends StatefulWidget {
  const LoginReg({super.key});

  @override
  State<LoginReg> createState() => _LoginRegState();
}

class _LoginRegState extends State<LoginReg> with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  bool _isPasswordVisible = false;


  late AnimationController _controller;
  late Animation gradientAnimation;

  @override
  void initState() {
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    gradientAnimation = ColorTween(
      begin: const Color(0xFF082c44),
      end: const Color(0xFF3a5e76),
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _scaleAnimation = Tween<double>(begin: 0.75, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(43, 30, 56, 1),
            forceMaterialTransparency: false,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
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
            child: _isLoading == true
                ? const LoadingComponent()
                : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: maxWidth * 0.1,
                        right: maxWidth * 0.1,
                      ),
                      child: Image.asset(
                        'assets/logo.png',
                      ),
                    ),
                    SizedBox(height: maxHeight * 0.02),
                    Text(
                      "Sign In",
                      style: GoogleFonts.habibi(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: maxHeight * 0.04),

                    const SizedBox(
                      height: 16,
                    ),
                    customTextField(
                      false,
                      'Enter your email',
                      'Email',
                      _emailFocusNode,
                      Icons.person,
                      _emailController,
                      TextInputType.emailAddress,
                          (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter email ID";
                        }


                        const pattern =
                            r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                            r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                            r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                            r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                            r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                            r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                            r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                        final regex = RegExp(pattern);

                        return !regex.hasMatch(value)
                            ? 'Enter a valid email address'
                            : null;
                      },
                    ),
                    SizedBox(height: maxHeight * 0.03),
                    customTextField(
                      !_isPasswordVisible,
                      'Enter your password',
                      'Password',
                      _passwordFocusNode,
                      Icons.lock,
                      _passwordController,
                      TextInputType.visiblePassword,
                          (val) {
                        if (val!.length < 6) {
                          return "Password must be at least 6 characters";
                        } else {
                          return null;
                        }
                      },
                      onTogglePasswordVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            login(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: maxHeight * 0.02),
                        ),
                        child: Text(
                          "Login",
                          style: GoogleFonts.quicksand(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF082c44)),
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't Have an Account? ",
                          style:
                          GoogleFonts.quicksand(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const RegisterPage()));
                          },
                          child: Text(
                            "SIGN UP",
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  TextFormField customTextField(
      bool obscureText,
      String hintText,
      String labelText,
      FocusNode focusNode,
      IconData icon,
      TextEditingController? textEditingController,
      TextInputType inputType,
      String? Function(String?)? validator, {
        VoidCallback? onTogglePasswordVisibility,
      } // Added parameter
      ) {
    return TextFormField(
      focusNode: focusNode,
      obscureText: obscureText,
      controller: textEditingController,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.quicksand(color: Colors.white),
        hintText: hintText,
        hintStyle: GoogleFonts.quicksand(color: Colors.white.withOpacity(0.5)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: onTogglePasswordVisibility != null
            ? IconButton(
          icon: Icon(
            // Toggle the icon based on the password visibility state
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.white,
          ),
          onPressed: onTogglePasswordVisibility,
        )
            : null,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
      cursorRadius: const Radius.circular(10),
      cursorColor: Colors.white,
      style: GoogleFonts.quicksand(color: Colors.white),
      validator: validator,
    );
  }

  login(BuildContext context) async {
    var bytes =
    utf8.encode(_passwordController.text.toString()); // data being hashed
    var digest = sha256.convert(bytes);
    var hashedPass = digest.toString();

    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      debugPrint({
        "studentEmail": _emailController.text.toString(),
        // Valid EMAIL. Max 255 chars.
        "studentPassword": _passwordController.text.toString()
        // Min 8 chars. Cannot include '-'(hiphen) and "'"(quotes) as part of the password.
        // Send SHA256 Hashed Version of password.
      }.toString());

      try {
        final response = await Dio().post(
          Constants.login,
          options: Options(
            headers: {
              "Content-Type": "application/json",
            },
            validateStatus: (status) =>
            status! < 1000, // This line is extremely important
          ),
          data: {
            "email": _emailController.text.toString(),
            // Valid EMAIL. Max 255 chars.
            "password": _passwordController.text.toString()
            // Min 8 chars. Cannot include '-'(hiphen) and "'"(quotes) as part of the password.
            // Send SHA256 Hashed Version of password.
          },
        );

        if (kDebugMode) {
          print("[LOGIN]: ${response.data}");
          print("[STATUS]: ${response.statusCode}");
        }

        if (response.statusCode == 200) {
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(
              _emailController.text.toString());

          await HelperFunctions.saveUserTokenSF(response.data["accessToken"]);

          setState(() {
            SharedPreferences.getInstance().then((sp) {
              sp.setString("EMAIL", response.data["email"].toString());
              sp.setString("NAME", response.data["username"].toString());

              sp.setString("TOKEN", response.data["accessToken"].toString());

              debugPrint(response.data["accessToken"].toString());
            });
          });

          // MyDelightToastBar().success(context, "Welcome!");
          showToast("Welcome!");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false);

          return "1";
        } else if (response.statusCode == 400) {
          showToast(response.data['MESSAGE'] ??
              "Invalid credentials");
          return "-1";
        }

        showToast("Invalid credentials");

        return "-1";
      } catch (err) {
        if (kDebugMode) {
          print("[ERROR]: $err");
        }

        showToast("Invalid credentials");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
