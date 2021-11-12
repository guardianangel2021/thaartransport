// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
import 'package:thaartransport/addnewload/PostLoad.dart';
import 'package:thaartransport/addnewload/postmodal.dart';
import 'package:thaartransport/screens/market/userdata.dart';
import 'package:thaartransport/screens/market/userposts.dart';
import 'package:thaartransport/utils/constants.dart';
import 'package:thaartransport/utils/firebase.dart';
import 'package:thaartransport/widget/indicatiors.dart';

class Market extends StatefulWidget {
  final profileId;
  Market({required this.profileId});

  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> {
  List<DocumentSnapshot> post = [];

  bool isLoading = false;

  ScrollController scrollController = ScrollController();

  bool hasMore = true;
  void setFeeds() {}

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 8,
            bottom: TabBar(
                indicatorColor: Constants.cursorColor,
                unselectedLabelColor: Color(0xffb8b0b8),
                labelStyle: TextStyle(fontSize: 18),
                labelColor: Constants.white,
                tabs: const [
                  Tab(
                    child: Text(
                      'LOADS',
                    ),
                  ),
                  Tab(
                    child: Text(
                      "TRUCKS",
                    ),
                  )
                ]),
          ),
          body: TabBarView(children: [
            StreamBuilder(
                stream: postRef
                    .where('ownerId', isNotEqualTo: widget.profileId)
                    .where('loadstatus', isEqualTo: 'Active')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Somthing went Wrong");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: circularProgress(context));
                  } else if (snapshot.hasData) {
                    return ScrollWrapper(
                        scrollController: scrollController,
                        scrollToTopCurve: Curves.easeInOut,
                        promptAlignment: Alignment.bottomRight,
                        child: ListView(
                          controller: scrollController,
                          shrinkWrap: true,
                          children: [
                            // Container(
                            //   height: 45,
                            //   margin: EdgeInsets.all(10),
                            //   alignment: Alignment.center,
                            //   child: TextFormField(
                            //     cursorColor: Constants.cursorColor,
                            //     decoration: InputDecoration(
                            //       border: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(20)),
                            //       focusedBorder: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(20)),
                            //     ),
                            //   ),
                            // ),
                            ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.all(0),
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, int index) {
                                  PostModal posts = PostModal.fromJson(
                                      snapshot.data!.docs[index].data()
                                          as Map<String, dynamic>);

                                  return UserData(posts: posts);
                                }),
                            SizedBox(height: 30),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Can't Fond Your Specific Load?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                      'Tell us your requirement, we will get back to you in sometime?',
                                      style: TextStyle(fontSize: 15)),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  FlatButton(
                                      color: Constants.btnBG,
                                      textColor: Constants.white,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PostLoad()));
                                      },
                                      child: Container(
                                        child: Text("Post Your Load"),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ));
                  }
                  return circularProgress(context);
                }),
            Text("data")
          ]),
        ));
  }
}
