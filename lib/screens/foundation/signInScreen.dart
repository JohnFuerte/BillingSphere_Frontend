// import 'package:billingsphere/auth/providers/login_provider.dart';
// import 'package:billingsphere/helper/constants.dart';
// import 'package:billingsphere/logic/cubits/user_cubit/user_cubit.dart';
// import 'package:billingsphere/logic/cubits/user_cubit/user_state.dart';
// import 'package:billingsphere/screens/foundation/signUp.dart';
// import 'package:billingsphere/screens/splash/splashScreen.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';

// class SignInScreen extends StatefulWidget {
//   const SignInScreen({Key? key}) : super(key: key);
//   static const String routeName = "login";

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<LoginProvider>(context, listen: true);
//     var size = MediaQuery.of(context).size;

//     return GestureDetector(
//       onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//       child: BlocListener<UserCubit, UserState>(
//         listener: (context, state) {
//           if (state is UserLoggedInState) {
//             Navigator.pushReplacementNamed(context, SplashScreen.routeName);
//           }
//         },
//         child: Scaffold(
//           backgroundColor: white,
//           resizeToAvoidBottomInset: false,
//           body: LayoutBuilder(
//             builder: (context, constraints) {
//               if (constraints.maxWidth > 600) {
//                 return _buildWideScreen(size, provider);
//               } else {
//                 return _buildSmallScreen(size, provider);
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildWideScreen(Size size, LoginProvider provider) {
//     return Row(
//       children: [
//         Expanded(
//           flex: 4,
//           child: RotatedBox(
//             quarterTurns: 4,
//             child: Lottie.asset(
//               'assets/lottie/signIn.json',
//               height: size.height * 0.5,
//               width: double.infinity,
//               fit: BoxFit.fill,
//             ),
//           ),
//         ),
//         SizedBox(width: size.width * 0.06),
//         Expanded(
//           flex: 5,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: size.width > 600
//                 ? MainAxisAlignment.center
//                 : MainAxisAlignment.start,
//             children: [
//               size.width > 600
//                   ? Container()
//                   : Lottie.asset(
//                       'assets/lottie/mobileView.json',
//                       height: size.height * 0.2,
//                       width: size.width,
//                       fit: BoxFit.fill,
//                     ),
//               SizedBox(
//                 height: size.height * 0.03,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20.0),
//                 child: Text(
//                   'Login',
//                   style: kLoginTitleStyle(size),
//                 ),
//               ),
//               SizedBox(
//                 height: size.height * 0.01,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20.0),
//                 child: Text(
//                   'Welcome Back!',
//                   style: kLoginSubtitleStyle(size),
//                 ),
//               ),
//               SizedBox(
//                 height: size.height * 0.03,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20.0, right: 20),
//                 child: Form(
//                   key: provider.formKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         style: kTextFormFieldStyle(),
//                         decoration: const InputDecoration(
//                           prefixIcon: Icon(Icons.email_rounded),
//                           hintText: 'Email',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(15)),
//                           ),
//                         ),
//                         controller: provider.emailController,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your email';
//                           }
//                           if (!EmailValidator.validate(value.trim())) {
//                             return "Invalid email address";
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(
//                         height: size.height * 0.02,
//                       ),
//                       TextFormField(
//                         style: kTextFormFieldStyle(),
//                         controller: provider.passwordController,
//                         obscureText: provider.myValue,
//                         decoration: InputDecoration(
//                           prefixIcon: const Icon(Icons.lock_open),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               provider.myValue
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                             ),
//                             onPressed: () {
//                               provider.setMyValue(!provider.myValue);
//                             },
//                           ),
//                           hintText: 'Password',
//                           border: const OutlineInputBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(15)),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your password';
//                           } else if (value.length < 6) {
//                             return 'Please provide a password with a minimum of six characters.';
//                           } else if (value.length > 13) {
//                             return 'Your password does not exceed a maximum of 13 characters.';
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(
//                         height: size.height * 0.01,
//                       ),
//                       Text(
//                         'Login into the account means you\'re okay with our Terms of Services and our Privacy Policy',
//                         style: kLoginTermsAndPrivacyStyle(size),
//                         textAlign: TextAlign.center,
//                       ),
//                       SizedBox(
//                         height: size.height * 0.02,
//                       ),
//                       (provider.error != "")
//                           ? Text(
//                               provider.error,
//                               style: const TextStyle(
//                                   color: red,
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.bold),
//                             )
//                           : const SizedBox(),
//                       (provider.error != "")
//                           ? SizedBox(
//                               height: size.height * 0.01,
//                             )
//                           : const SizedBox(),
//                       SizedBox(
//                         width: double.infinity,
//                         height: size.height * 0.08,
//                         child: ElevatedButton(
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all(purple),
//                             shape: MaterialStateProperty.all(
//                               RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                             ),
//                           ),
//                           onPressed: () {
//                             provider.logIn();
//                           },
//                           child: (provider.isLoading)
//                               ? const CircularProgressIndicator(
//                                   color: white,
//                                 )
//                               : const Text(
//                                   "SIGN IN",
//                                   style: TextStyle(
//                                     color: white,
//                                     fontSize: 17,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: size.height * 0.03,
//                       ),

//                       // GestureDetector(
//                       //   onTap: () {
//                       //     Navigator.pop(context);
//                       //     provider.nameController.clear();
//                       //     provider.emailController.clear();
//                       //     provider.passwordController.clear();
//                       //     _formKey.currentState?.reset();
//                       //     Navigator.pushNamed(context, SignUpScreen.routeName);
//                       //   },
//                       //   child: RichText(
//                       //     text: TextSpan(
//                       //       text: 'Don\'t have an account?',
//                       //       style: kHaveAnAccountStyle(size),
//                       //       children: [
//                       //         TextSpan(
//                       //           text: " Sign up",
//                       //           style: kLoginOrSignUpTextStyle(
//                       //             size,
//                       //           ),
//                       //         ),
//                       //       ],
//                       //     ),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSmallScreen(Size size, LoginProvider provider) {
//     return Center(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: size.width > 600
//             ? MainAxisAlignment.center
//             : MainAxisAlignment.start,
//         children: [
//           size.width > 600
//               ? Container()
//               : Lottie.asset(
//                   'assets/lottie/mobileView.json',
//                   height: size.height * 0.2,
//                   width: size.width,
//                   fit: BoxFit.fill,
//                 ),
//           SizedBox(
//             height: size.height * 0.03,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 20.0),
//             child: Text(
//               'Login',
//               style: kLoginTitleStyle(size),
//             ),
//           ),
//           SizedBox(
//             height: size.height * 0.01,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 20.0),
//             child: Text(
//               'Welcome Back!',
//               style: kLoginSubtitleStyle(size),
//             ),
//           ),
//           SizedBox(
//             height: size.height * 0.03,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 20.0, right: 20),
//             child: Form(
//               key: provider.formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     style: kTextFormFieldStyle(),
//                     decoration: const InputDecoration(
//                       prefixIcon: Icon(Icons.email_rounded),
//                       hintText: 'Email',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(15)),
//                       ),
//                     ),
//                     controller: provider.emailController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!EmailValidator.validate(value.trim())) {
//                         return "Invalid email address";
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(
//                     height: size.height * 0.02,
//                   ),
//                   TextFormField(
//                     style: kTextFormFieldStyle(),
//                     controller: provider.passwordController,
//                     obscureText: provider.myValue,
//                     decoration: InputDecoration(
//                       prefixIcon: const Icon(Icons.lock_open),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           provider.myValue
//                               ? Icons.visibility
//                               : Icons.visibility_off,
//                         ),
//                         onPressed: () {
//                           provider.setMyValue(!provider.myValue);
//                         },
//                       ),
//                       hintText: 'Password',
//                       border: const OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(15)),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       } else if (value.length < 6) {
//                         return 'Please provide a password with a minimum of six characters.';
//                       } else if (value.length > 13) {
//                         return 'Your password does not exceed a maximum of 13 characters.';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(
//                     height: size.height * 0.01,
//                   ),
//                   Text(
//                     'Login into the account means you\'re okay with our Terms of Services and our Privacy Policy',
//                     style: kLoginTermsAndPrivacyStyle(size),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(
//                     height: size.height * 0.02,
//                   ),
//                   (provider.error != "")
//                       ? Text(
//                           provider.error,
//                           style: const TextStyle(
//                               color: red,
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold),
//                         )
//                       : const SizedBox(),
//                   (provider.error != "")
//                       ? SizedBox(
//                           height: size.height * 0.01,
//                         )
//                       : const SizedBox(),
//                   SizedBox(
//                     width: double.infinity,
//                     // height: 55,
//                     height: size.height * 0.08,
//                     child: ElevatedButton(
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all(purple),
//                         shape: MaterialStateProperty.all(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                       ),
//                       onPressed: () {
//                         provider.logIn();
//                       },
//                       child: Text(
//                         (provider.isLoading) ? "..." : "SIGN IN",
//                         style: const TextStyle(
//                             color: white,
//                             fontSize: 17,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: size.height * 0.03,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                       provider.nameController.clear();
//                       provider.emailController.clear();
//                       provider.passwordController.clear();
//                       _formKey.currentState?.reset();
//                       Navigator.pushNamed(context, SignUpScreen.routeName);
//                     },
//                     child: RichText(
//                       text: TextSpan(
//                         text: 'Don\'t have an account?',
//                         style: kHaveAnAccountStyle(size),
//                         children: [
//                           TextSpan(
//                             text: " Sign up",
//                             style: kLoginOrSignUpTextStyle(
//                               size,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
