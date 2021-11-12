import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:thaartransport/addnewload/postmodal.dart';
import 'package:thaartransport/modal/usermodal.dart';
import 'package:thaartransport/screens/homepage.dart';
import 'package:thaartransport/screens/market/bidmodal.dart';
import 'package:thaartransport/services/userservice.dart';
import 'package:thaartransport/utils/constants.dart';
import 'package:thaartransport/utils/firebase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:thaartransport/widget/indicatiors.dart';

class AllBids extends StatefulWidget {
  const AllBids({Key? key}) : super(key: key);

  @override
  _AllBidsState createState() => _AllBidsState();
}

class _AllBidsState extends State<AllBids> {
  TextEditingController rate = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: bidRef
            .where('biduserid', isEqualTo: UserService().currentUid())
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Somthing went Wrong");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: circularProgress(context));
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text("Yet No Bids", style: TextStyle(fontSize: 18)));
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
                                    Flexible(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(users.username!),
                                        Text(users.companyname!)
                                      ],
                                    )),
                                  ],
                                ),
                              )),
                              bidpost.bidresponse == "Bid Accepted"
                                  ? Flexible(
                                      child: FlatButton(
                                          color: Constants.cursorColor,
                                          textColor: Colors.white,
                                          onPressed: () {},
                                          child: Container(
                                            height: 40,
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Accepted Bid",
                                            ),
                                          )))
                                  : bidpost.negotiateprice == ""
                                      ? Flexible(
                                          child: FlatButton(
                                              color: Colors.orange,
                                              textColor: Colors.white,
                                              onPressed: () {},
                                              child: Container(
                                                height: 40,
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  "Waiting",
                                                ),
                                              )))
                                      : Flexible(
                                          child: FlatButton(
                                              color: Colors.purple[600],
                                              textColor: Colors.white,
                                              onPressed: () {
                                                _onNegotiate(bidpost, posts);
                                              },
                                              child: Container(
                                                height: 40,
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  "Negotiate",
                                                ),
                                              )))
                            ],
                          ))),
                ],
              ));
        });
  }

  _onNegotiate(BidModal bidpost, PostModal posts) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                color: Color(0xFF737373),
                // height: 300,
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: _buildNegotiateSheet(bidpost, posts),
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                ),
              ));
        });
  }

  Widget _buildNegotiateSheet(BidModal bidpost, PostModal posts) {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("There New Price", style: TextStyle(fontSize: 20)),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Image.asset(
                'assets/images/rupee-indian.png',
                height: 20,
                width: 20,
              ),
              Text(bidpost.negotiateprice!,
                  style: GoogleFonts.lato(fontSize: 30)),
              Text(
                  posts.priceunit == 'tonne'
                      ? " /per ${posts.priceunit}"
                      : " /${posts.priceunit!}",
                  style: const TextStyle(fontSize: 18)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              FlatButton(
                  color: Colors.grey,
                  textColor: Colors.white,
                  onPressed: () {
                    _onReBid(bidpost);
                  },
                  child: Container(
                    child: const Text("ReBid"),
                  )),
              SizedBox(
                width: 20,
              ),
              FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () async {
                    try {
                      loading = true;
                      await bidRef.doc(bidpost.id).update({
                        'bidresponse': "Bid Accepted",
                        'bidtime': Jiffy(DateTime.now()).yMMMMEEEEdjm
                      }).catchError((e) {
                        print(e);
                      });

                      await postRef.doc(posts.postid).update({
                        'loadstatus': "Intransit",
                        'loadorderstatus': "Intransit",
                      }).catchError((e) {
                        print(e);
                      });
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                      loading = false;
                    }
                  },
                  child: Container(
                    child: Row(
                      children: [Icon(Icons.check), Text("Accept Bid")],
                    ),
                  )),
            ],
          )
        ],
      );
    });
  }

  _onReBid(BidModal bidpost) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                color: Color(0xFF737373),
                // height: 300,
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: _buildReBidSheet(bidpost),
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                ),
              ));
        });
  }

  Widget _buildReBidSheet(BidModal bidpost) {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Enter your new bid amount",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text("Enter new price"),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: rate,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(hintText: "Price"),
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                if (rate.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Please enter your price");
                } else {
                  await bidRef.doc(bidpost.id).update({
                    'rate': rate.text,
                    'bidtime': Jiffy(DateTime.now()).yMMMMEEEEdjm,
                    'btnvalue': 'response',
                    'negotiateprice': ''
                  }).catchError((e) {
                    print(e);
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(selectedIndex: 3)));
                }
              },
              child: Container(
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                child: Text("Negotiate"),
              ))
        ],
      );
    });
  }
}
