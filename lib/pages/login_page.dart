import 'package:chat_app/components/button.dart';
import 'package:chat_app/components/text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  
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
                Text("Welcome back, you have been missed!", style: TextStyle(color: Colors.grey[700]),),
          
                const SizedBox(
                  height: 25,
                ),
          
                // email
                MyTextField(
                    controller: emailTextController,
                    hintText: 'Email',
                    obsecureText: false
                ),

                const SizedBox(
                  height: 10,
                ),
          
                // password
                MyTextField(
                    controller: passwordTextController,
                    hintText: 'Password',
                    obsecureText: true
                ),

                const SizedBox(
                  height: 25,
                ),
          
                // sign in
                MyButton(
                  onTap: (){}, 
                  text: 'Sign In'
                ),

                const SizedBox(
                  height: 25,
                ),
          
                // register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member?", style: TextStyle(color: Colors.grey[700]),),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: (){},
                      child: const Text(
                        "Register Now",
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
