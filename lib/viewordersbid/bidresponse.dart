import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thaartransport/viewordersbid/acceptedreceivedbids.dart';
import 'package:thaartransport/viewordersbid/allreceivedbids.dart';
import 'package:thaartransport/addnewload/postmodal.dart';
import 'package:thaartransport/viewordersbid/rejectedreceivedbids.dart';
import 'package:thaartransport/screens/market/bidmodal.dart';
import 'package:thaartransport/utils/constants.dart';
import 'package:thaartransport/utils/firebase.dart';
import 'package:thaartransport/widget/indicatiors.dart';

class BidResponse extends StatefulWidget {
  PostModal posts;
  BidResponse({required this.posts});

  @override
  _BidResponseState createState() => _BidResponseState();
}

class _BidResponseState extends State<BidResponse> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
          child: Column(
        children: [
          TabBar(
              indicatorWeight: 0,
              labelColor: Constants.btnBG,
              unselectedLabelColor: Color(0xfff183850),
              indicator: BoxDecoration(
                  shape: BoxShape.rectangle,

                  // boxShadow: ,
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(25)),
              tabs: const [
                Tab(
                  text: "All",
                ),
                Tab(
                  text: "Accepted",
                ),
                Tab(
                  text: "Rejected",
                )
              ]),
          Expanded(
            child: TabBarView(children: [
              StreamBuilder<QuerySnapshot>(
                  stream: bidRef
                      .where('loadid', isEqualTo: widget.posts.postid)
                      .orderBy('bidtime', descending: true)
                      .limit(1)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Somthing went Wrong");
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: circularProgress(context));
                    } else if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text("Yet Not received bids",
                              style: TextStyle(fontSize: 18)));
                    }
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0),
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          BidModal bidpost = BidModal.fromJson(
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>);

                          return AllReceivedBids(
                              posts: widget.posts, bidpost: bidpost);
                        });
                  }),
              AcceptedReceivedBids(posts: widget.posts),
              RejectedReceivedBids(posts: widget.posts)
            ]),
          )
        ],
      )),
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      toolbarHeight: 0,
      bottom: TabBar(
          indicatorWeight: 0,
          labelColor: Constants.btnBG,
          unselectedLabelColor: Color(0xfff183850),
          indicator: BoxDecoration(
              shape: BoxShape.rectangle,

              // boxShadow: ,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(25)),
          tabs: const [
            Tab(
              text: "All",
            ),
            Tab(
              text: "Accepted",
            ),
            Tab(
              text: "Rejected",
            )
          ]),
    );
  }
}
