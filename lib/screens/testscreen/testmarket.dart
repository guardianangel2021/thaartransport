import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thaartransport/addnewload/postmodal.dart';
import 'package:thaartransport/screens/market/userposts.dart';
import 'package:thaartransport/utils/firebase.dart';

class TestMarket extends StatefulWidget {
  final profileId;
  TestMarket({required this.profileId});

  @override
  _TestMarketState createState() => _TestMarketState();
}

class _TestMarketState extends State<TestMarket> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: StreamBuilder(
            stream: postRef
                // .where('ownerId', isEqualTo: widget.profileId)
                .where('loadstatus', isEqualTo: 'Active')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Scaffold(body: Text("Somthing went Wrong"));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: Text("Loading...")));
              }
              return ListView(
                children: [
                  DefaultTabController(
                      length: 2,
                      child: Container(
                        height: height,
                        child: ListView(
                          children: [
                            const TabBar(tabs: [
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
                                    }),
                                Text("")
                              ]),
                            )
                          ],
                        ),
                      ))
                ],
              );
            }));
  }
}
