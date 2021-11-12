// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thaartransport/addnewload/orderdata.dart';
import 'package:thaartransport/addnewload/postmodal.dart';
import 'package:thaartransport/screens/homepage.dart';
import 'package:thaartransport/utils/constants.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
import 'package:thaartransport/utils/firebase.dart';
import 'package:thaartransport/widget/indicatiors.dart';

class OrderPostConfirmed extends StatefulWidget {
  String id;
  OrderPostConfirmed(this.id);

  @override
  _OrderPostConfirmedState createState() => _OrderPostConfirmedState();
}

class _OrderPostConfirmedState extends State<OrderPostConfirmed> {
  bool _showBackToTopButton = false;

  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController!.offset >= 400) {
            _showBackToTopButton = true; // show the back-to-top button
          } else {
            _showBackToTopButton = false; // hide the back-to-top button
          }
        });
      });
  }

  @override
  void dispose() {
    _scrollController!.dispose(); // dispose the controller
    super.dispose();
  }

  // This function is triggered when the user presses the back-to-top button
  void _scrollToTop() {
    _scrollController!
        .animateTo(0, duration: Duration(seconds: 3), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: postRef.doc(widget.id).snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Scaffold(body: Text("Somthing went Wrong"));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: circularProgress(context));
            }
            final PostModal posts = PostModal.fromJson(
                snapshot.data!.data() as Map<String, dynamic>);

            return WillPopScope(
                onWillPop: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                selectedIndex: 0,
                              )));
                  return true;
                },
                child: Scaffold(
                  body: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        expandedHeight: 200,
                        titleSpacing: 3,
                        title: Text(
                            "Posted at ${posts.loadposttime!.split(',')[1]}${posts.loadposttime!.split(',')[2]}",
                            style: TextStyle(fontSize: 13)),
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                                margin: EdgeInsets.only(top: 130),
                                child: Column(
                                  children: [
                                    Text(posts.sourcelocation!,
                                        style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                fontSize: 25,
                                                color: Colors.white))),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Icon(
                                      Icons.arrow_downward,
                                      color: Constants.white,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(posts.destinationlocation!,
                                        style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                fontSize: 25,
                                                color: Colors.white)))
                                  ],
                                ))),
                        actions: [
                          posts.loadorderstatus == "Expired" &&
                                  posts.loadstatus == "Expired"
                              ? Container()
                              : PopupMenuButton(
                                  icon: const Icon(
                                    Icons.more_vert,
                                  ),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value: 1,
                                        enabled: true,
                                        child: Text(
                                          "Close",
                                          style:
                                              TextStyle(color: Constants.alert),
                                        )),
                                    PopupMenuItem(
                                        child: Text(
                                      "Edit",
                                      style: TextStyle(
                                          color: Constants.cursorColor),
                                    ))
                                  ],
                                  onSelected: (menu) {
                                    if (menu == 1) {
                                    } else if (menu == 2) {}
                                  },
                                )
                        ],
                      ),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        OrderData(
                          posts: posts,
                        )
                      ]))
                    ],
                  ),
                ));
          }),
    );
  }
}
