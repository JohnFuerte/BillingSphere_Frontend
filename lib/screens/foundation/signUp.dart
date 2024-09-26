import 'package:billingsphere/auth/providers/signup_provider.dart';
import 'package:billingsphere/helper/constants.dart';
import 'package:billingsphere/screens/foundation/signInScreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'Login_screen_resposive.dart/loginScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const String routeName = "signup";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignUpProvider>(context, listen: true);
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: white,
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return Row(
                children: [
                  _buildRotatedLottie(size),
                  SizedBox(width: size.width * 0.06),
                  _buildFormColumn(size, provider),
                ],
              );
            } else {
              return _buildMobileViewColumn(size, provider);
            }
          },
        ),
      ),
    );
  }

  Widget _buildRotatedLottie(Size size) {
    return Expanded(
      flex: 4,
      child: RotatedBox(
        quarterTurns: 4,
        child: Lottie.asset(
          'assets/lottie/signUp.json',
          height: size.height * 0.7,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildFormColumn(Size size, SignUpProvider provider) {
    return Expanded(
      flex: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: size.width > 600
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          _buildLottieForMobileView(size),
          SizedBox(height: size.height * 0.03),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('Sign Up', style: kLoginTitleStyle(size)),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('Create Account', style: kLoginSubtitleStyle(size)),
          ),
          SizedBox(height: size.height * 0.03),
          _buildForm(size, provider),
        ],
      ),
    );
  }

  Widget _buildMobileViewColumn(Size size, SignUpProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: size.width > 600
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          _buildLottieForMobileView(size),
          SizedBox(height: size.height * 0.03),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('Sign Up', style: kLoginTitleStyle(size)),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('Create Account', style: kLoginSubtitleStyle(size)),
          ),
          SizedBox(height: size.height * 0.03),
          _buildForm(size, provider),
        ],
      ),
    );
  }

  Widget _buildLottieForMobileView(Size size) {
    return size.width > 600
        ? Container()
        : Lottie.asset(
            'assets/lottie/mobileView.json',
            height: size.height * 0.2,
            width: size.width,
            fit: BoxFit.fill,
          );
  }

  Widget _buildForm(Size size, SignUpProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Form(
        key: provider.formKey,
        child: Column(
          children: [
            _buildTextFormField(
              hintText: 'Full Name',
              prefixIcon: Icons.person,
              controller: provider.nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Full name';
                } else if (value.length < 4) {
                  return 'At least enter 4 characters';
                } else if (value.length > 13) {
                  return 'Maximum character is 13';
                }
                return null;
              },
            ),
            _buildTextFormField(
              hintText: 'Email',
              prefixIcon: Icons.email_rounded,
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
            _buildTextFormField(
              hintText: 'Password',
              prefixIcon: Icons.lock_open,
              controller: provider.passwordController,
              obscureText: provider.myValue,
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
              suffixIcon: IconButton(
                icon: Icon(
                  provider.myValue ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  provider.setMyValue(!provider.myValue);
                },
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              'Creating an account means you\'re okay with our Terms of Services and our Privacy Policy',
              style: kLoginTermsAndPrivacyStyle(size),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.height * 0.02),
            _buildErrorText(provider.error),
            SizedBox(
                height: provider.error.isNotEmpty ? size.height * 0.01 : 0),
            _buildElevatedButton(
              onPressed: () {
                provider.createAccount();
                provider.nameController.clear();
                provider.emailController.clear();
                provider.passwordController.clear();
                _formKey.currentState?.reset();
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
              label: 'SIGN UP',
              isLoading: provider.isLoading,
            ),
            SizedBox(height: size.height * 0.03),
            _buildNavigateToLogin(size, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String hintText,
    required IconData prefixIcon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        TextFormField(
          style: kTextFormFieldStyle(),
          decoration: InputDecoration(
            prefixIcon: Icon(prefixIcon),
            hintText: hintText,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            suffixIcon: suffixIcon,
          ),
          controller: controller,
          obscureText: obscureText,
          validator: validator,
        ),
        SizedBox(height: size.height * 0.02),
      ],
    );
  }

  Widget _buildErrorText(String error) {
    return error.isNotEmpty
        ? Text(
            error,
            style: const TextStyle(
              color: red,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          )
        : const SizedBox();
  }

  Widget _buildElevatedButton({
    required VoidCallback onPressed,
    required String label,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.08,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(purple),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: onPressed,
        child: isLoading
            ? const CircularProgressIndicator(color: white)
            : Text(
                label,
                style: const TextStyle(
                  color: white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildNavigateToLogin(Size size, SignUpProvider provider) {
    return GestureDetector(
      onTap: () {
        provider.nameController.clear();
        provider.emailController.clear();
        provider.passwordController.clear();
        _formKey.currentState?.reset();
        Navigator.pushNamed(context, LoginScreen.routeName);
      },
      child: RichText(
        text: TextSpan(
          text: 'Already have an account?',
          style: kHaveAnAccountStyle(size),
          children: [
            TextSpan(
              text: " Login",
              style: kLoginOrSignUpTextStyle(size),
            ),
          ],
        ),
      ),
    );
  }
}
