import 'package:chat_app/components/button.dart';
import 'package:chat_app/components/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextFieldController = TextEditingController();

  // user sign up setup
  void signUp() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    // make sure passwords match
    if (passwordTextController.text !=
        confirmPasswordTextFieldController.text) {
      // remove loading circle
      Navigator.pop(context);
      // shoe error
      messageDisplay("Passwords do not match");
      return;
    }

    // creating the user
    try {
      // user create
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailTextController.text,
              password: passwordTextController.text);

      // create in cloud for user
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'username' : emailTextController.text.split('@')[0], // initial split
        'bio' : 'Empty bio...' // initial empty bio
      });

      // remove loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // remove loading circle
      Navigator.pop(context);
      // show error message
      messageDisplay(e.code);
    }
  }

  // display message
  void messageDisplay(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(
                  height: 50,
                ),

                // welcome
                Text(
                  "Let's create an account for you  ",
                  style: TextStyle(color: Colors.grey[700]),
                ),

                const SizedBox(
                  height: 25,
                ),

                // email
                MyTextField(
                    controller: emailTextController,
                    hintText: 'Email',
                    obsecureText: false),

                const SizedBox(
                  height: 10,
                ),

                // password
                MyTextField(
                    controller: passwordTextController,
                    hintText: 'Password',
                    obsecureText: true),

                const SizedBox(
                  height: 10,
                ),

                // confirm password
                MyTextField(
                    controller: confirmPasswordTextFieldController,
                    hintText: 'Confirm Password',
                    obsecureText: true),

                const SizedBox(
                  height: 25,
                ),

                // sign up button
                MyButton(onTap: signUp, text: 'Sign Up'),

                const SizedBox(
                  height: 25,
                ),

                // register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
