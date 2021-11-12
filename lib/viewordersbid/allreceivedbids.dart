import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:thaartransport/addnewload/postmodal.dart';
import 'package:thaartransport/modal/usermodal.dart';
import 'package:thaartransport/screens/market/bidmodal.dart';
import 'package:thaartransport/utils/constants.dart';
import 'package:thaartransport/utils/firebase.dart';
import 'package:thaartransport/widget/indicatiors.dart';

class AllReceivedBids extends StatefulWidget {
  PostModal posts;
  BidModal bidpost;
  AllReceivedBids({required this.posts, required this.bidpost});

  @override
  _AllReceivedBidsState createState() => _AllReceivedBidsState();
}

class _AllReceivedBidsState extends State<AllReceivedBids> {
  bool validate = false;
  bool loading = false;

  TextEditingController Negotiate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getBidResponse(widget.bidpost),
        widget.bidpost.bidresponse == ""
            ? Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: FlatButton(
                    color: Colors.grey,
                    textColor: Colors.white,
                    onPressed: () {
                      _onSeeAll();
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text("See All Bid"),
                    )))
            : Container()
      ],
    );
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
              clipBehavior: Clip.antiAlias,
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
                                            bidpost.negotiateprice == ""
                                                ? Text(bidpost.rate!,
                                                    style:
                                                        TextStyle(fontSize: 25))
                                                : Text(bidpost.negotiateprice!,
                                                    style:
                                                        TextStyle(fontSize: 25))
                                          ],
                                        ),
                                        Text(widget.posts.priceunit == 'tonne'
                                            ? "per  ${widget.posts.priceunit}"
                                            : widget.posts.priceunit!),
                                        bidpost.negotiateprice == ""
                                            ? Container()
                                            : Text(
                                                "Negotiate Price",
                                                style: TextStyle(
                                                    color: Colors.orange[600]),
                                              )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              // Text(bidpost.id!),
                              SizedBox(
                                height: 10,
                              ),
                              bidpost.bidresponse == "Bid Accepted"
                                  ? FlatButton(
                                      color: Constants.cursorColor,
                                      textColor: Colors.white,
                                      onPressed: () async {},
                                      child: Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: Text("Accepted Bid",
                                            style: TextStyle(
                                                color: Constants.white)),
                                      ),
                                    )
                                  : bidpost.negotiateprice == ""
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: FlatButton(
                                              color: Constants.lightbtnBG,
                                              onPressed: () async {
                                                _onRejected(bidpost);
                                              },
                                              child: Container(
                                                  height: 50,
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                      ),
                                                      Text("Negotiate",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                    ],
                                                  )),
                                            )),
                                            Expanded(
                                                child: FlatButton(
                                              color: Constants.btnBG,
                                              onPressed: () async {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return buildAcceptSheet(
                                                          bidpost);
                                                    });
                                              },
                                              child: Container(
                                                  height: 50,
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                      ),
                                                      Text("Accept Bid",
                                                          style: TextStyle(
                                                              color: Constants
                                                                  .white)),
                                                    ],
                                                  )),
                                            )),
                                          ],
                                        )
                                      : FlatButton(
                                          color: Constants.btnBG,
                                          textColor: Constants.white,
                                          onPressed: () {},
                                          child: Container(
                                            height: 50,
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                    Icons.watch_later_outlined),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text("Waiting for Response")
                                              ],
                                            ),
                                          ))
                            ],
                          )),
                    ));
              });
        });
  }

  Widget buildAcceptSheet(BidModal bidpost) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Press confirm to proceed with this transaction",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FlatButton(
                  color: Colors.grey,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Text("Cancel"),
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

                      await postRef.doc(widget.posts.postid).update({
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
                  child: Container(child: Text("Confirm")))
            ],
          )
        ],
      ),
    );
  }

  _onRejected(BidModal bidpost) {
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
                  child: _buildRejectedSheet(bidpost),
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

  Widget _buildRejectedSheet(BidModal bidpost) {
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
          const SizedBox(
            height: 10,
          ),
          const Text("Enter new price"),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: Negotiate,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(hintText: "Price"),
          ),
          const SizedBox(
            height: 20,
          ),
          FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                if (Negotiate.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Please enter your price");
                } else {
                  await bidRef.doc(bidpost.id).update({
                    'negotiateprice': Negotiate.text,
                    'bidtime': Jiffy(DateTime.now()).yMMMMEEEEdjm
                  }).catchError((e) {
                    print(e);
                  });
                  Navigator.pop(context);
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

  _onSeeAll() {
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
                  child: _buildSeeAllSheet(),
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

  Widget _buildSeeAllSheet() {
    return StatefulBuilder(builder: (context, setState) {
      return StreamBuilder<QuerySnapshot>(
          stream: bidRef
              .where('loadid', isEqualTo: widget.posts.postid)
              .orderBy('bidtime', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Somthing went Wrong");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: circularProgress(context));
            } else if (snapshot.data!.docs.isEmpty) {
              return const Center(
                  child: Text("Yet Not received bids",
                      style: TextStyle(fontSize: 18)));
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Bids Received",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close))
                  ],
                ),
                ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      BidModal bidpost = BidModal.fromJson(
                          snapshot.data!.docs[index].data()
                              as Map<String, dynamic>);

                      return getBidResponse(bidpost);
                    })
              ],
            );
          });
    });
  }
}
