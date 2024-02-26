import 'dart:developer';

import 'package:chat_app/components/drawer.dart';
import 'package:chat_app/components/text_field.dart';
import 'package:chat_app/components/wall_post.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // current user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // text controller
  final textController = TextEditingController();

  // message control
  void postMessage() {
    // only posts is textfield contains data
    if (textController.text.isNotEmpty) {
      // store in firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        "UserEmail": currentUser.email,
        "Message": textController.text,
        "TimeStamp": Timestamp.now(),
        "Likes": [],
      });
    }

    // clear the textfield
    setState(() {
      textController.clear();
    });
  }

  // sign user out
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  // nav to profile page
  void goToProfilePage() {
    // pop drawer
    Navigator.pop(context);

    // route to new page
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => const ProfilePage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text("The wall"),
          backgroundColor: Colors.grey[800],
        ),
        // drawer: MyDrawer(),
        body: Center(
          child: Column(
            children: [
              // the wall
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("User Posts")
                      .orderBy(
                        "TimeStamp",
                        descending: false,
                      )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            // get message
                            final post = snapshot.data!.docs[index];
                            return WallPost(
                              message: post["Message"],
                              user: post["UserEmail"],
                              postId: post.id,
                              likes: List<String>.from(post['Likes'] ?? []),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error:${snapshot.error}'),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),

              // message post
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    //expand textfield
                    Expanded(
                      child: MyTextField(
                        controller: textController,
                        hintText: "Wite something on here... ",
                        obsecureText: false,
                      ),
                    ),

                    IconButton(
                        onPressed: postMessage,
                        icon: const Icon(Icons.arrow_circle_up))
                  ],
                ),
              ),

              // logged in as "user name"
              Text(
                "Logged in as: " + currentUser.email!,
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
        drawer: MyDrawer(
          onProfile: goToProfilePage,
          onSignOut: signOut,
        ));
  }
}
