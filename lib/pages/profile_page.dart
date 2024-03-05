// import 'dart:html';

import 'package:chat_app/components/text_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  // all users
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  // edit field
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text(
                "Edit $field",
                style: const TextStyle(color: Colors.white),
              ),
              content: TextField(
                autocorrect: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Enter new $field",
                    hintStyle: TextStyle(color: Colors.grey)),
                onChanged: (value) {
                  newValue = value;
                },
              ),
              actions: [
                // cancel button
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    )),

                // save button
                TextButton(
                    onPressed: () => Navigator.of(context).pop(newValue),
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ));

    // update data in firestore
    if (newValue.trim().length > 0) {
      // only update if the textfield has data
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          title: Text('My Profile'),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser.email)
              .snapshots(),
          builder: (context, snapshot) {
            // get user data
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
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

                  const SizedBox(
                    height: 50,
                  ),

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
                    text: userData['username'],
                    sectionName: 'username',
                    onPressed: () => editField('username'),
                  ),

                  // bio
                  MyTextBox(
                    text: userData['bio'],
                    sectionName: 'bio',
                    onPressed: () => editField('bio'),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  // user posts
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'My posts',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error${snapshot.error}'),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
