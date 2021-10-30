import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:thaartransport/addnewload/PostLoad.dart';
import 'package:thaartransport/addnewload/orderdata.dart';
import 'package:thaartransport/addnewload/orderdata.dart';
import 'package:thaartransport/addnewload/orderpostconfirmed.dart';
import 'package:thaartransport/addnewload/postmodal.dart';
import 'package:thaartransport/services/userservice.dart';
import 'package:thaartransport/utils/constants.dart';
import 'package:thaartransport/utils/firebase.dart';

class MyLoadPage extends StatefulWidget {
  final currentuser;
  MyLoadPage({required this.currentuser});

  @override
  _MyLoadPageState createState() => _MyLoadPageState();
}

class _MyLoadPageState extends State<MyLoadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: postRef
              .where('ownerId', isEqualTo: widget.currentuser)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Scaffold(body: Text("Somthing went Wrong"));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: Text("Loading...")));
            } else if (snapshot.data!.docs.isEmpty) {
              return Column(
                children: [
                  loadbutton(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "You have not active loads at the moment",
                      ))
                ],
              );
            }
            return ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(),
                children: [
                  loadbutton(),

                  // filter(),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, int index) {
                        PostModal posts = PostModal.fromJson(
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>);

                        return LoadPosts(
                            posts.loadstatus!,
                            posts.loadposttime!,
                            posts.sourcelocation!,
                            posts.destinationlocation!,
                            posts.material!,
                            posts.quantity!,
                            posts.expectedprice!,
                            posts,
                            posts.priceunit!);
                      })
                ]);
          }),
    );
  }

  Widget LoadPosts(
      String status,
      String postTime,
      String source,
      String destination,
      String material,
      String quantity,
      String expectedPrice,
      PostModal posts,
      String priceunit) {
    var ref = posts.postid;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OrderPostConfirmed(ref!)));
      },
      child: Card(
          // color: Colors.red,
          child: Container(
        // height: 20,
        padding: EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(25)),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: status == "Active"
                          ? Constants.cursorColor
                          : Constants.alert,
                    ),
                  ),
                ),
                Text(postTime.split(',')[1] + postTime.split(',')[2])
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
                      source.split(',')[0],
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(source.split(',')[1]),
                  ],
                ),
                const Icon(Icons.arrow_right_alt_outlined),
                Column(
                  children: [
                    Text(
                      destination.split(',')[0],
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(destination.split(',')[1]),
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
                        material,
                        style: TextStyle(fontWeight: FontWeight.bold),
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
                        "$quantity Tons",
                        style: TextStyle(fontWeight: FontWeight.bold),
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
              children: [
                Image.asset(
                  'assets/images/rupee-indian.png',
                  height: 20,
                  width: 20,
                ),
                Text(expectedPrice, style: GoogleFonts.lato(fontSize: 18)),
                Text(priceunit == 'tonne' ? " per" : '',
                    style: TextStyle(fontSize: 18)),
                SizedBox(
                  width: width * 0.02,
                ),
                Text(priceunit, style: GoogleFonts.lato(fontSize: 18)),
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      )),
    );
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
}
