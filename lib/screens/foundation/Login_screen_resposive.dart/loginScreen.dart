import 'package:billingsphere/auth/providers/login_provider.dart';
import 'package:billingsphere/helper/constants.dart';
import 'package:billingsphere/logic/cubits/user_cubit/user_cubit.dart';
import 'package:billingsphere/logic/cubits/user_cubit/user_state.dart';
import 'package:billingsphere/screens/foundation/signUp.dart';
import 'package:billingsphere/screens/splash/splashScreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'login_widgets.dart/hidden_password.dart';
import 'login_widgets.dart/login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context, listen: true);
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserLoggedInState) {
            Navigator.pushReplacementNamed(context, SplashScreen.routeName);
          }
        },
        child: Scaffold(
          backgroundColor: white,
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1200) {
                return _buildWideScreen(size, provider);
              } else {
                return _buildSmallScreen(size, provider);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWideScreen(Size size, LoginProvider provider) {
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Form(
        key: provider.formKey,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: w * 0.5,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 216, 151, 253),
                  ),
                  child: Image.asset(
                    "images/animated_image.png",
                    width: w * 0.25,
                    height: 200,
                  ),
                ),
                Container(
                  width: w * 0.5,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 232, 234, 252),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Hello Again!",
                        style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "Welcome back you've been missed!",
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 30.0),
                      SizedBox(
                        width: 250,
                        // height: 50,
                        child: TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 216, 151, 253),
                                    width: 2),
                              ),
                              labelText: 'Email',
                              filled: true,
                              fillColor: Colors.white),
                          controller: provider.emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!EmailValidator.validate(value.trim())) {
                              return "Invalid email address";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      HiddenPassword(
                        controller: provider.passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 6) {
                            return 'Please provide a password with a minimum of six characters.';
                          } else if (value.length > 13) {
                            return 'Your password does not exceed a maximum of 13 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30.0),
                      (provider.error != "")
                          ? Text(
                              provider.error,
                              style: const TextStyle(
                                color: red,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const SizedBox(),
                      (provider.error != "")
                          ? SizedBox(
                              height: size.height * 0.01,
                            )
                          : const SizedBox(),
                      (provider.isLoading)
                          ? const CircularProgressIndicator(
                              color: Color.fromARGB(255, 216, 151, 253),
                            )
                          : LogInButton(
                              text: 'Sign In',
                              onPressed: () {
                                provider.logIn();
                              },
                            ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSmallScreen(Size size, LoginProvider provider) {
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: provider.formKey,
          child: Container(
            color: Color.fromARGB(255, 232, 234, 252),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: w,
                    height: MediaQuery.of(context).size.height * 0.38,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 216, 151, 253),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Image.asset("images/animated_image.png"),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.048),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hello Again!',
                      style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.020),
                    SizedBox(
                      width: w * 0.6,
                      child: Text(
                        "Welcome back you've been missed!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 20, color: Colors.grey.shade700),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.048),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 216, 151, 253),
                                width: 2),
                          ),
                          labelText: 'Enter username',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        controller: provider.emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!EmailValidator.validate(value.trim())) {
                            return "Invalid email address";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.020),
                    HiddenPassword(
                      controller: provider.passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Please provide a password with a minimum of six characters.';
                        } else if (value.length > 13) {
                          return 'Your password does not exceed a maximum of 13 characters.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.020),
                    LogInButton(
                      text: 'Sign In',
                      onPressed: () {
                        provider.logIn();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
