// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:thaartransport/Utils/constants.dart';
import 'package:thaartransport/Utils/firebase.dart';
import 'package:thaartransport/addnewload/PostLoad.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thaartransport/addnewload/postmodal.dart';
import 'package:thaartransport/services/userservice.dart';
import 'package:thaartransport/widget/indicatiors.dart';

late bool? active = false;
late bool progress;
late bool completed;
late bool expired;

class MyLoadPage extends StatefulWidget {
  const MyLoadPage({Key? key}) : super(key: key);

  @override
  _MyLoadPageState createState() => _MyLoadPageState();
}

class _MyLoadPageState extends State<MyLoadPage> {
  void initState() {
    getCount();
    print(getCount());
  }

  String id = user!.phoneNumber.toString();
  var countNumber = 0;
  bool checkbox1 = false;
  bool checkbox2 = false;
  bool checkbox3 = false;
  bool checkbox4 = false;

  Future getCount({String? id}) async => postRef
          .where('CurrentUserNo', isEqualTo: user!.phoneNumber)
          .get()
          .then((value) {
        countNumber = value.docs.length;

        return countNumber;
      });

  Future getColor() async {
    postRef.where('Status', isEqualTo: "IsActive").snapshots();
  }

  RefreshController refreshController = RefreshController();
  Future<Null> _onLoading() async {
    await Future.delayed(
      Duration(seconds: 1),
    );
    setState(() {
      var refreshController =
          postRef.where('CurrentUserNo', isEqualTo: id).snapshots().length;
    });
    refreshController.refreshCompleted();
  }

  Future _onRefersh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      var refreshController =
          postRef.where('CurrentUserNo', isEqualTo: id).snapshots().length;
    });

    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SmartRefresher(
          onRefresh: _onRefersh,
          controller: refreshController,
          onLoading: _onLoading,
          enablePullDown: true,
          enablePullUp: true,

          // header: WaterDropHeader(),
          child: StreamBuilder<QuerySnapshot>(
            stream: postRef
                .where('ownerId', isEqualTo: UserService().currentUid())
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Scaffold(body: Text("Somthing went Wrong"));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(body: Center(child: circularProgress(context)));
              }
              final PostModal posts  = PostModal.fromJson(json)(
                  snapshot.data;
              return ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(),
                children: [
                  loadbutton(),
                  filter(),
                  ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return post(
                            snapshot.data?.docs[index]['material'],
                            // posts.material!,
                            snapshot.data?.docs[index]['quantity'],
                            snapshot.data?.docs[index]['paymentmode'],
                            snapshot.data?.docs[index]['sourcelocation'],
                            snapshot.data?.docs[index]['sourcelocation'],
                            snapshot.data?.docs[index]['destinationlocation'],
                            snapshot.data?.docs[index]['destinationlocation'],
                            'postTime',
                            'expiretime',
                            snapshot.data?.docs[index]['expectedprice'],
                            snapshot.data?.docs[index]['id'],
                            snapshot.data?.docs[index]['usernumber']);
                      })
                ],
              );
            },
          ),
        ));
  }

  Widget loadbutton() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 20),
      child: RaisedButton(
          color: Constants.btnBG,
          onPressed: () async {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PostLoad()));
          },
          child: Shimmer(
              duration: Duration(seconds: 3), //Default value
              interval:
                  Duration(seconds: 3), //Default value: Duration(seconds: 0)
              color: Colors.white, //Default value
              colorOpacity: 0, //Default value
              enabled: true, //Default value
              direction: ShimmerDirection.fromLTRB(), //Default Value
              child: Container(
                  height: 45,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Post a new load",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 18, color: Colors.white)
                    ],
                  )))),
    );
  }

  _showModalSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Container(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        'Filter Loads By',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close_rounded)),
                    ),
                    CheckboxListTile(
                        title: Text(
                          "Active",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        value: checkbox1,
                        onChanged: (val) {
                          setState(() {
                            checkbox1 = val!;
                            active = checkbox1;
                          });
                        }),
                    CheckboxListTile(
                        title: Text(
                          "In Progress",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        value: checkbox2,
                        onChanged: (val) {
                          setState(() {
                            checkbox2 = val!;
                          });
                        }),
                    CheckboxListTile(
                        title: Text(
                          "Completed",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        value: checkbox3,
                        onChanged: (val) {
                          setState(() {
                            checkbox3 = val!;
                          });
                        }),
                    CheckboxListTile(
                        title: Text(
                          "Expired",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        value: checkbox4,
                        onChanged: (val) {
                          setState(() {
                            checkbox4 = val!;
                            // print(checkbox4);
                          });
                        }),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: RaisedButton(
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.pop(
                              context,
                            );
                          },
                          child: Container(
                            height: 45,
                            alignment: Alignment.center,
                            child: Text(
                              "Apply Filter",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        )),
                    if (checkbox1 && checkbox2) Text("1")
                  ],
                ),
              ),
            );
          });
        });
  }

  Widget filter() {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Loads($countNumber)",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
              InkWell(
                  onTap: () {
                    _showModalSheet(context);
                  },
                  child: const Icon(
                    Icons.filter_list,
                  ))
            ],
          )
        ]));
  }

  Widget post(
    String material,
    String quantity,
    String payment,
    String source,
    String sourceState,
    String destination,
    String destinationState,
    String postTime,
    String expiretime,
    String rate,
    String PaymentOption,
    String status,
  ) {
    return Padding(
        padding: const EdgeInsets.only(
          top: 15,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Card(
                  elevation: 10,
                  child: Container(
                    padding: EdgeInsets.only(top: 15, left: 5, right: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/truck_load.png',
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.circle,
                              size: 15,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              source + sourceState,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            PopupMenuButton(
                              icon: Icon(
                                Icons.more_vert,
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 1,
                                    enabled: true,
                                    child: Text(
                                      "Update Post",
                                    )),
                                PopupMenuItem(
                                    value: 1,
                                    enabled: true,
                                    child: Text(
                                      "disable",
                                    )),
                                PopupMenuItem(
                                    value: 1,
                                    enabled: true,
                                    child: Text(
                                      "Share on WhatsApp",
                                    )),
                              ],
                              onSelected: (menu) {
                                if (menu == 1) {}
                                if (menu == 2) {}
                                if (menu == 2) {}
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/truck_load.png',
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.circle,
                              size: 15,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              destination + destinationState,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/product.png',
                                      height: 20,
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Product'),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(material,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        )),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/quantity.png',
                                      height: 20,
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Quantity"),
                                    Text(quantity,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ))
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/payment.png',
                                      height: 20,
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Payment Terms'),
                                    Text(payment,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ))
                                  ],
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Expected Price'),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/rupee-indian.png',
                                      height: 25,
                                    ),
                                    Text(
                                      rate,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(PaymentOption)
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ExpansionTileCard(
                            baseColor: Colors.blue[50],
                            expandedColor: Colors.blue[50],
                            elevation: 0,
                            title: Text(
                              'View Live Lorries',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.blue),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              alignment: Alignment.center,
              width: 80,
              margin: EdgeInsets.only(left: 30),
              child: Text(status),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey)),
            )
          ],
        ));
  }
}
