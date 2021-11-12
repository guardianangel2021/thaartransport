import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thaartransport/addnewload/postmodal.dart';

import 'package:thaartransport/modal/usermodal.dart';
import 'package:thaartransport/screens/market/bidmodal.dart';
import 'package:thaartransport/utils/constants.dart';
import 'package:thaartransport/utils/firebase.dart';
import 'package:thaartransport/widget/indicatiors.dart';

class RejectedReceivedBids extends StatefulWidget {
  PostModal posts;
  RejectedReceivedBids({required this.posts});

  @override
  _RejectedReceivedBidsState createState() => _RejectedReceivedBidsState();
}

class _RejectedReceivedBidsState extends State<RejectedReceivedBids> {
  bool validate = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: bidRef
            .where('loadid', isEqualTo: widget.posts.postid)
            .where('bidresponse', isEqualTo: 'Bid Rejected')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Somthing went Wrong");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: circularProgress(context));
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text("Yet Not Rejected Bids",
                    style: TextStyle(fontSize: 18)));
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              physics: ScrollPhysics(),
              itemBuilder: (context, index) {
                BidModal bidpost = BidModal.fromJson(
                    snapshot.data!.docs[index].data() as Map<String, dynamic>);

                return getBidResponse(bidpost);
              });
        });
  }

  Widget getBidResponse(
    BidModal bidpost,
  ) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return StreamBuilder(
        stream: usersRef.where('id', isEqualTo: bidpost.biduserid).snapshots(),
        // stream: postRef.doc(widget.posts.id).collection('Bid').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Somthing went Wrong");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center();
          }
          return ListView.builder(
              // clipBehavior: Clip.,
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              physics: ScrollPhysics(),
              itemBuilder: (context, index) {
                UserModel user = UserModel.fromJson(
                    snapshot.data!.docs[index].data() as Map<String, dynamic>);
                return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Card(
                      // color: Colors.red,
                      // elevation: 10,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Constants.darkPrimary)),
                          padding: EdgeInsets.only(),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 10, top: 10),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: user.photourl!,
                                          height: height,
                                          width: width,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.02,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(user.username!),
                                        Text(user.location!),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 10),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/rupee-indian.png',
                                              height: 20,
                                              width: 20,
                                            ),
                                            Text(bidpost.rate!,
                                                style: TextStyle(fontSize: 25)),
                                          ],
                                        ),
                                        Text(widget.posts.priceunit == 'tonne'
                                            ? "per  ${widget.posts.priceunit}"
                                            : widget.posts.priceunit!),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              // Text(bidpost.id!),
                              SizedBox(
                                height: 10,
                              ),
                              FlatButton(
                                color: Constants.alert,
                                textColor: Colors.white,
                                onPressed: () async {},
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Text("Rejected Bid",
                                      style: TextStyle(color: Constants.white)),
                                ),
                              )
                            ],
                          )),
                    ));
              });
        });
  }
}
