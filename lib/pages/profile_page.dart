import 'package:chat_app/components/text_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // edit field
  Future<void> editField(String field) async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text('My Profile'),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),

          // profle pic
          const Icon(
            Icons.person_2,
            size: 70,
          ),

          const SizedBox(
            height: 10,
          ),

          // user email
          Text(
            currentUser.email!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700]),
          ),

          const SizedBox(height: 50,),

          // user details
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'My details',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),

          // username
          MyTextBox(
            text: 'full', 
            sectionName: 'username',
            onPressed: () => editField('username'),
          ),

          // bio
          MyTextBox(
            text: 'empty', 
            sectionName: 'bio',
            onPressed: () => editField('bio'),
          ),

          const SizedBox(height: 50,),

          // user posts
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'My posts',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
