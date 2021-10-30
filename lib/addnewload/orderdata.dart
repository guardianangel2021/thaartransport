// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:thaartransport/addnewload/postmodal.dart';
import 'package:thaartransport/modal/usermodal.dart';
import 'package:thaartransport/screens/bid/bidpage.dart';
import 'package:thaartransport/screens/homepage.dart';
import 'package:thaartransport/services/userservice.dart';
import 'package:thaartransport/utils/constants.dart';
import 'package:thaartransport/utils/firebase.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderData extends StatefulWidget {
  PostModal posts;
  OrderData({required this.posts});
  @override
  _OrderDataState createState() => _OrderDataState();
}

class _OrderDataState extends State<OrderData> {
  bool validate = false;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return LoadPosted(
        widget.posts.material!,
        widget.posts.quantity!,
        widget.posts.paymentmode!,
        widget.posts.expectedprice!,
        widget.posts.priceunit!);
  }

  Widget LoadPosted(String material, String quantity, String PaymentMode,
      String expectedPrice, String priceUnit) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Card(
          elevation: 10,
          child: Container(
            height: 200,
            width: width,
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () => showModalBottomSheet(
                        context: context, builder: (context) => buildSheet()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              LottieBuilder.asset(
                                'assets/79827-circle-fade-loader.json',
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              const Text(
                                "Load Posted",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const InkWell(
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          ),
                        )
                      ],
                    )),
                const Divider(
                  color: Colors.black,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/product.png',
                                width: 20,
                                height: 20,
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Text("Material: $material"),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/quantity.png',
                                width: 20,
                                height: 20,
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Text("Quantity: $quantity Tons"),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/payment.png',
                                width: 20,
                                height: 20,
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Text('Payment Mode: $PaymentMode'),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            expectedPrice,
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            priceUnit,
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: height * 0.02,
        ),
        WhatsAppButton(),
        tabBar()
      ],
    );
  }

  Widget WhatsAppButton() {
    return RaisedButton(
      color: Colors.green,
      onPressed: () {},
      child: Container(
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.share,
                size: 17,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Share on WhatsApp",
                style: TextStyle(color: Colors.white, fontSize: 17),
              )
            ],
          )),
    );
  }

  // Widget getBidresponse() {
  //   return
  // }

  Widget getBidResponse(UserModel user) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return StreamBuilder(
        stream: postRef.doc(widget.posts.id).collection('Bid').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Somthing went Wrong");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading..."));
          }
          return ListView.builder(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              physics: ScrollPhysics(),
              itemBuilder: (context, index) {
                PostModal bidpost = PostModal.fromJson(
                    snapshot.data!.docs[index].data() as Map<String, dynamic>);
                return Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Card(
                      // color: Colors.red,
                      elevation: 10,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
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
                              Row(
                                children: [
                                  Text("Lorry Available"),
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
                                          ? "per+ ${widget.posts.priceunit}"
                                          : widget.posts.priceunit!),
                                    ],
                                  )
                                ],
                              ),
                              bidpost.bidresponse == ""
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FlatButton(
                                          color: Constants.btnBG,
                                          onPressed: () async {
                                            try {
                                              loading = true;
                                              await postRef
                                                  .doc(widget.posts.id)
                                                  .collection('Bid')
                                                  .doc(widget.posts.biduserid)
                                                  .update({
                                                'bidresponse': "Bid Rejected"
                                              }).catchError((e) {
                                                print(e);
                                              });

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BidPage(
                                                            posts: widget.posts,
                                                            users: user,
                                                          )));
                                            } catch (e) {
                                              print(e);
                                              loading = false;
                                            }
                                          },
                                          child: Container(
                                            height: 40,
                                            alignment: Alignment.center,
                                            child: Text("Reject Bid",
                                                style: TextStyle(
                                                    color: Constants.white)),
                                          ),
                                        ),
                                        FlatButton(
                                          color: Constants.btnBG,
                                          onPressed: () async {
                                            try {
                                              loading = true;
                                              await postRef
                                                  .doc(widget.posts.id)
                                                  .collection('Bid')
                                                  .doc(widget.posts.biduserid)
                                                  .update({
                                                'bidresponse': "Bid Accepted"
                                              }).catchError((e) {
                                                print(e);
                                              });

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BidPage(
                                                            posts: widget.posts,
                                                            users: user,
                                                          )));
                                            } catch (e) {
                                              print(e);
                                              loading = false;
                                            }
                                          },
                                          child: Container(
                                            height: 40,
                                            alignment: Alignment.center,
                                            child: Text("Accept Bid",
                                                style: TextStyle(
                                                    color: Constants.white)),
                                          ),
                                        ),
                                      ],
                                    )
                                  : bidpost.bidresponse == "Bid Accepted"
                                      ? FlatButton(
                                          color: Constants.cursorColor,
                                          textColor: Colors.white,
                                          onPressed: () async {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BidPage(
                                                          posts: widget.posts,
                                                          users: user,
                                                        )));
                                          },
                                          child: Container(
                                            height: 40,
                                            alignment: Alignment.center,
                                            child: Text("Accepted Bid",
                                                style: TextStyle(
                                                    color: Constants.white)),
                                          ),
                                        )
                                      : FlatButton(
                                          color: Colors.red,
                                          textColor: Colors.white,
                                          onPressed: () async {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BidPage(
                                                          posts: widget.posts,
                                                          users: user,
                                                        )));
                                          },
                                          child: Container(
                                            height: 40,
                                            alignment: Alignment.center,
                                            child: Text("Rejected Bid",
                                                style: TextStyle(
                                                    color: Constants.white)),
                                          ),
                                        )
                            ],
                          )),
                    ));
              });
        });
  }

  // Column(
  //           children: [
  //             const SizedBox(
  //               height: 20,
  //             ),
  //             Row(
  //               children: [
  //                 Image.asset(
  //                   'assets/images/logo.png',
  //                   scale: 4,
  //                 ),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const Text(
  //                       "You'll receive transporter Bids here!",
  //                       style: TextStyle(fontSize: 15),
  //                     ),
  //                     const SizedBox(
  //                       height: 10,
  //                     ),
  //                     Container(
  //                       alignment: Alignment.center,
  //                       height: 25,
  //                       width: 100,
  //                       decoration: BoxDecoration(border: Border.all()),
  //                       child: const Text('15 - 20 MINS'),
  //                     ),
  //                   ],
  //                 )
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //           ],
  //         );

  Widget tabBar() {
    return DefaultTabController(
        length: 2,
        child: Container(
          child: Column(
            children: [
              const TabBar(tabs: [
                Tab(
                  child: Text(
                    'BID RESPONSE',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    "LIVE LORRIES",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ]),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 500,
                child: TabBarView(children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: usersRef
                          .where('id', isEqualTo: UserService().currentUid())
                          .snapshots(),
                      // stream: postRef.doc(widget.id).collection('Bid').snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Somthing went Wrong");
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: Text("Loading..."));
                        }
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            physics: ScrollPhysics(),
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              UserModel user = UserModel.fromJson(
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>);

                              return getBidResponse(user);
                            });
                      }),
                  Text("data")
                ]),
              )
            ],
          ),
        ));
  }

  Widget buildSheet() {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            "Your Trip Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          TimelineTile(
            indicatorStyle: IndicatorStyle(height: 30, width: 30),
            isFirst: true,
            endChild: Container(
                height: 60,
                width: 80,
                alignment: Alignment.center,
                child: ListTile(
                  title: Text(
                    "Load Posted",
                    // style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text("Your Load is available in Live Market"),
                )),
          ),
          TimelineTile(
            indicatorStyle: IndicatorStyle(height: 30, width: 30),
            isFirst: false,
            endChild: Container(
                height: 60,
                // color: Colors.red,
                width: 80,
                alignment: Alignment.center,
                child: ListTile(
                  title: Text("Load In Progress"),
                  // subtitle: Text(data),
                )),
          ),
          TimelineTile(
            indicatorStyle: IndicatorStyle(height: 30, width: 30),
            isFirst: false,
            endChild: Container(
                height: 60,
                width: 80,
                alignment: Alignment.center,
                child: ListTile(
                  title: Text("Load in Transit"),
                )),
          ),
          TimelineTile(
            indicatorStyle: IndicatorStyle(height: 30, width: 30),
            isFirst: false,
            endChild: Container(
                height: 60,
                width: 80,
                alignment: Alignment.center,
                child: ListTile(
                  title: Text("Trip Completed"),
                )),
          ),
          SizedBox(
            height: 30,
          ),
          RaisedButton(
            color: Colors.blue,
            onPressed: () {},
            child: Container(
              height: 45,
              alignment: Alignment.center,
              child: Text(
                "OKAY, GOT IT",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }
}
