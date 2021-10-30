// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thaartransport/addnewload/postmodal.dart';
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

  bool hasMore = true;

  int documentLimit = 10;

  DocumentSnapshot? lastDocument;

  ScrollController? _scrollController;

  getPosts() async {
    if (!hasMore) {
      print('No New Posts');
    }
    if (isLoading) {
      return CircularProgressIndicator();
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await postRef
          .orderBy('timestamp', descending: false)
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await postRef
          .orderBy('timestamp', descending: false)
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    // lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    // post.addAll(querySnapshot.docs);
    // setState(() {
    //   isLoading = false;
    // });
  }

  @override
  void initState() {
    super.initState();
    // getPosts();
    // _scrollController?.addListener(() {
    //   double maxScroll = _scrollController!.position.maxScrollExtent;
    //   double currentScroll = _scrollController!.position.pixels;
    //   double delta = MediaQuery.of(context).size.height * 0.25;
    //   if (maxScroll - currentScroll <= delta) {
    //     getPosts();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            body: SingleChildScrollView(
                child: Column(
          // scrollDirection: Axis.vertical,
          // shrinkWrap: true,
          children: [
            TabBar(tabs: const [
              Tab(
                child: Text(
                  'LOADS',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  "TRUCKS",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ]),
            Container(
              height: height,
              child: TabBarView(children: [
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
                        return const Center(child: Text("Loading..."));
                      }
                      return Wrap(
                        // shrinkWrap: true,
                        children: [
                          Container(
                            height: 45,
                            margin: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: TextFormField(
                              cursorColor: Constants.cursorColor,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, int index) {
                                PostModal posts = PostModal.fromJson(
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>);

                                return UserPost(posts: posts);
                              })
                        ],
                      );
                    }),
                Text("data")
              ]),
            )
          ],
        ))));
  }
}
