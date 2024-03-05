import 'package:chat_app/components/like_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  // current user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  // comment text controller
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  // toggle likes
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    // access document in firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      // if liked, add user email to the likes field
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      /// if unliked, remove user
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser])
      });
    }
  }

  // add a comment
  void addComment(String commentText) {
    //write the comment to firestore under the commetns collection for this post
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentedTime": Timestamp.now(),
    });
  }

  // add dialog box for showing comment
  void showCommentDialog() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(hintText: "Add a Comment..."),
        ),
        actions: [
          // post button
          TextButton(
           onPressed: () => addComment(_commentTextController.text), 
           child: Text('Post')
          ),

          // calcel button
          TextButton(
           onPressed: () => Navigator.pop(context), 
           child: Text('Cancel')
          ),
        ],  
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // message and email
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[500]),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(widget.message),
            ],
          ),

          // buttons
          Row(
            children: [
              // LIKE
              Column(
                children: [
                  // like button
                  LikeButton(isLiked: isLiked, onTap: toggleLike),
              
                  const SizedBox(
                    height: 5,
                  ),
              
                  // like counter
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: Colors.lightBlue),
                  ),
                ],
              ),

              // COMMENT
              Column(
                children: [
                  // like button
                  LikeButton(isLiked: isLiked, onTap: toggleLike),
              
                  const SizedBox(
                    height: 5,
                  ),
              
                  // like counter
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: Colors.lightBlue),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
