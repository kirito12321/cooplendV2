// ignore_for_file: use_build_context_synchronously

import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_view.dart';
import 'package:ascoop/services/auth/auth_exception.dart';
import 'package:ascoop/services/auth/auth_service.dart';
import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/utilities/show_alert_dialog.dart';
import 'package:ascoop/utilities/show_error_dialog.dart';
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/inputstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/web_ui/utils/alertdialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
// import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _obscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.teal[500]
            // image: DecorationImage(
            //     // image: AssetImage('assets/images/loginwallpapersecondx.jpg'),
            //     fit: BoxFit.cover)
            ),
        child: Center(
          child: Container(
            height: 500.0,
            width: 350.0,
            padding: const EdgeInsets.all(15.0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 174, 171, 171),
                      spreadRadius: 0,
                      blurStyle: BlurStyle.normal,
                      blurRadius: 20.0)
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                  child: Container(
                    height: 120.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/cooplendlogo.png'),
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                TextFormField(
                  style: inputTextStyle,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintStyle: inputHintTxtStyle,
                    focusedBorder: focusOutlineBorder,
                    border: OutlineBorder,
                    hintText: 'Email Address',
                    prefixIcon: Icon(
                      Icons.mail_outlined,
                      size: 20,
                      color: Colors.teal[800],
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                TextFormField(
                  style: inputTextStyle,
                  controller: _password,
                  autocorrect: false,
                  enableSuggestions: false,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    hintStyle: inputHintTxtStyle,
                    focusedBorder: focusOutlineBorder,
                    border: OutlineBorder,

                    // ignore: prefer_const_constructors
                    hintText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      size: 20,
                      color: Colors.teal[800],
                    ),
                    suffixIcon: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                        child: Icon(
                          _obscure ? Feather.eye : Feather.eye_off,
                          size: 20,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      // '/coop/loanview/',
                      //  '/coop/loantenureview',
                      '/user/sendverifCode/',
                    );
                  },
                  child: Text(
                    'Forgot Password',
                    style: btnForgotTxtStyle,
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                Center(
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ForTealButton,
                      onPressed: () async {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              content: onWait),
                        );
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          await AuthService.firebase().login(
                            email: email,
                            password: password,
                          );
                          final data =
                              await DataService.database().readUserData();

                          if (data == null) {
                            okDialog(context, 'Invalid User', 'User not found.')
                                .whenComplete(() => AuthService.firebase()
                                    .logOut()
                                    .then((value) => Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            '/login/', (route) => false)));

                            return;
                          }

                          final user = AuthService.firebase().currentUser;
                          if (user?.isEmailVerified ?? false) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/dashboard/', (route) => false);
                          } else {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/user/sendemailverif/', (route) => false);
                          }
                        } on UserNotFoundAuthException {
                          await okDialog(
                                  context, 'Invalid User', 'User not found.')
                              .whenComplete(() => Navigator.pop(context));
                        } on WrongPasswordAuthException {
                          await okDialog(context, 'Invalid Credintials',
                                  'Wrong password or email.')
                              .whenComplete(() => Navigator.pop(context));
                        } on GenericAuthException {
                          await okDialog(context, 'Invalid Credintials',
                                  "You inputed invalid credintials.")
                              .whenComplete(() => Navigator.pop(context));
                        }
                      },
                      child: Text(
                        'Login'.toUpperCase(),
                        style: btnLoginTxtStyle,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/register/');
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Dont have an account? ",
                          style: btnForgotTxtStyle,
                          children: [
                            TextSpan(
                              text: 'SIGN UP.'.toUpperCase(),
                              style: const TextStyle(
                                fontFamily: FontNameDefault,
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                letterSpacing: .8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
