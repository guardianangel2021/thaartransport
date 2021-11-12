import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thaartransport/addnewload/postmodal.dart';
import 'package:thaartransport/modal/usermodal.dart';
import 'package:thaartransport/screens/market/bidmodal.dart';
import 'package:thaartransport/services/userservice.dart';
import 'package:thaartransport/utils/constants.dart';
import 'package:thaartransport/utils/firebase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:thaartransport/widget/indicatiors.dart';

class AcceptedBids extends StatefulWidget {
  const AcceptedBids({Key? key}) : super(key: key);

  @override
  _AcceptedBidsState createState() => _AcceptedBidsState();
}

class _AcceptedBidsState extends State<AcceptedBids> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: bidRef
            .where('biduserid', isEqualTo: UserService().currentUid())
            .where('bidresponse', isEqualTo: "Bid Accepted")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Somthing went Wrong");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: circularProgress(context));
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text("Yet No Accepted Bids",
                    style: TextStyle(fontSize: 18)));
          }
          return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                BidModal bidpost = BidModal.fromJson(
                    snapshot.data!.docs[index].data() as Map<String, dynamic>);
                return getloadid(bidpost);
              });
        });
  }

  Widget getloadid(BidModal bidpost) {
    return StreamBuilder(
        stream: postRef.where('postid', isEqualTo: bidpost.loadid).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Somthing went Wrong");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: circularProgress(context));
          }
          return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, int index) {
                PostModal posts = PostModal.fromJson(
                    snapshot.data!.docs[index].data() as Map<String, dynamic>);

                return buidUser(posts, bidpost);
              });
        });
  }

  Widget buidUser(PostModal posts, BidModal bidpost) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return StreamBuilder(
        stream: usersRef.doc(posts.ownerId).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Somthing went Wrong");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          UserModel users =
              UserModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
          return Card(
              // color: Colors.red,

              elevation: 8,
              child: Column(
                children: [
                  Container(
                    // height: 20,
                    padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(posts.loadposttime!.split(',')[1] +
                                posts.loadposttime!.split(',')[2])
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Text(
                                  posts.sourcelocation!.split(',')[0],
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(posts.sourcelocation!.split(',')[1]),
                              ],
                            ),
                            const Icon(Icons.arrow_right_alt_outlined),
                            Column(
                              children: [
                                Text(
                                  posts.destinationlocation!.split(',')[0],
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(posts.destinationlocation!.split(',')[1]),
                              ],
                            )
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/product.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: width * 0.05,
                                  ),
                                  Text(
                                    posts.material!,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/quantity.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: width * 0.05,
                                  ),
                                  Text(
                                    "${posts.quantity} Tons",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text("Original Amount",
                                    style: const TextStyle(fontSize: 18)),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/rupee-indian.png',
                                      height: 20,
                                      width: 20,
                                    ),
                                    Text(posts.expectedprice!,
                                        style: GoogleFonts.lato(fontSize: 30)),
                                  ],
                                ),
                                Text(
                                    posts.priceunit == 'tonne'
                                        ? "per ${posts.priceunit}"
                                        : posts.priceunit!,
                                    style: const TextStyle(fontSize: 18)),
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Bid Amount",
                                    style: const TextStyle(fontSize: 18)),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/rupee-indian.png',
                                      height: 20,
                                      width: 20,
                                    ),
                                    Text(bidpost.rate!,
                                        style: GoogleFonts.lato(fontSize: 30)),
                                  ],
                                ),
                                Text(
                                    posts.priceunit == 'tonne'
                                        ? "per ${posts.priceunit}"
                                        : posts.priceunit!,
                                    style: const TextStyle(fontSize: 18)),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Card(
                          elevation: 0,
                          // color: Colors.pink,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  child: Flexible(
                                child: Row(
                                  children: [
                                    users.photourl!.isNotEmpty
                                        ? CircleAvatar(
                                            radius: 20,
                                            backgroundColor:
                                                const Color(0xff4D4D4D),
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    users.photourl ?? ""),
                                          )
                                        : const CircleAvatar(
                                            radius: 20.0,
                                            backgroundColor: Color(0xff4D4D4D),
                                          ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(users.username!),
                                        Text(users.companyname!)
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                              FlatButton(
                                  color: Constants.cursorColor,
                                  textColor: Colors.white,
                                  onPressed: () {},
                                  child: Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Accepted Bid",
                                    ),
                                  ))
                            ],
                          )))
                ],
              ));
        });
  }
}
