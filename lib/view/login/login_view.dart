import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_project/view/login/components/background_component.dart';
import 'package:test_project/view/login/components/circular_component.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final GoogleSignIn googleSignIn;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
    googleSignIn = GoogleSignIn();
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      // Use the user object for further operations or navigate to a new screen.
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              const BackgroundComponent(),
              const CircularComponent(),
              const Positioned(
                  top: -620,
                  right: 50,
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Color.fromRGBO(255, 250, 250, 0.93125),
                        height: 31,
                        fontWeight: FontWeight.bold,
                        fontSize: 50),
                  )),
              Positioned(
                  top: 400,
                  left: 100,
                  child: Align(
                      alignment: Alignment.center,
                      child: SignInButton(
                        Buttons.Google,
                        onPressed: () {
                          signInWithGoogle();
                        },
                      )))
            ],
          ),
        ),
      ),
    );

    // return Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Login Page'),
    //     ),
    //     body: Column(children: [
    //       TextField(
    //         controller: _email,
    //         decoration: const InputDecoration(hintText: "Email"),
    //       ),
    //       TextField(
    //         controller: _password,
    //         decoration: const InputDecoration(hintText: "Password"),
    //       ),
    //       TextButton(
    //           onPressed: () async {
    //             final email = _email.text;
    //             final password = _password.text;
    //             try {
    //               await FirebaseAuth.instance.signInWithEmailAndPassword(
    //                   email: email, password: password);
    //               Navigator.of(context).pushNamedAndRemoveUntil(
    //                   '/create_profile_view_user/', (route) => false);
    //             } on FirebaseAuthException catch (error) {
    //               if (error.code == " user-not-found") {
    //                 print(error.runtimeType);
    //               }
    //             }
    //           },
    //           child: const Text("SignIn")),
    //       ElevatedButton(
    //           onPressed: () {
    //             Navigator.of(context)
    //                 .pushNamedAndRemoveUntil('/register/', (route) => false);
    //           },
    //           child: const Text("Not registered yet? Register here!"))
    //     ]));
  }
}
