import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thaartransport/addnewload/postmodal.dart';
import 'package:thaartransport/modal/usermodal.dart';
import 'package:thaartransport/screens/market/bidmodal.dart';
import 'package:thaartransport/screens/market/userposts.dart';
import 'package:thaartransport/services/userservice.dart';
import 'package:thaartransport/utils/firebase.dart';
import 'package:thaartransport/widget/indicatiors.dart';

class UserData extends StatefulWidget {
  final PostModal posts;
  UserData({required this.posts});

  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: usersRef.doc(widget.posts.ownerId).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Somthing went Wrong");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center();
          } else if (snapshot.hasData) {
            UserModel users = UserModel.fromJson(
                snapshot.data!.data() as Map<String, dynamic>);
            return UserPost(
              posts: widget.posts,
              users: users,
            );
          } else {
            return circularProgress(context);
          }
        });
  }
}
