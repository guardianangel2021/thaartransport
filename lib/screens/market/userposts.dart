// ignore_for_file: unrelated_type_equality_checks, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:jiffy/jiffy.dart';
import 'package:thaartransport/addnewload/postmodal.dart';
import 'package:thaartransport/modal/usermodal.dart';
import 'package:thaartransport/screens/homepage.dart';
import 'package:thaartransport/services/userservice.dart';
import 'package:thaartransport/utils/constants.dart';
import 'package:thaartransport/utils/controllers.dart';
import 'package:thaartransport/utils/firebase.dart';
import 'package:thaartransport/widget/cached_image.dart';
import 'package:thaartransport/widget/indicatiors.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserPost extends StatelessWidget {
  final PostModal posts;
  final UserModel users;

  UserPost({required this.posts, required this.users});
  final DateTime timestamp = DateTime.now();

  currentUserId() {
    return firebaseAuth.currentUser!.uid;
  }

  final _formKey = GlobalKey<FormState>();
  bool validate = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return LoadPosts(
        context,
        posts.loadstatus!,
        posts.loadposttime!,
        posts.sourcelocation!,
        posts.destinationlocation!,
        posts.material!,
        posts.quantity!,
        posts.expectedprice!,
        posts,
        posts.priceunit!);
  }

  Widget LoadPosts(
      BuildContext context,
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
    return StreamBuilder(
        //  stream: usersRef.doc(widget.posts.ownerId).snapshots(),
        stream: bidRef
            .where('biduserid', isEqualTo: UserService().currentUid())
            .where('loadid', isEqualTo: posts.id)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Somthing went Wrong");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center();
          } else if (snapshot.hasData) {
            List<QueryDocumentSnapshot> docs = snapshot.data?.docs ?? [];
            return InkWell(
              onTap: () {
                docs.isEmpty
                    ? bidSheet(context, posts, users)
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(selectedIndex: 3)));
              },
              child: Card(
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
                                Text(postTime.split(',')[1] +
                                    postTime.split(',')[2])
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
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
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
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
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
                                Text(expectedPrice,
                                    style: GoogleFonts.lato(fontSize: 18)),
                                Text(priceunit == 'tonne' ? " per" : '',
                                    style: const TextStyle(fontSize: 18)),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Text(priceunit,
                                    style: GoogleFonts.lato(fontSize: 18)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Card(
                              elevation: 0,
                              child: Container(
                                  width: width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                          child: Container(
                                        child: Row(
                                          children: [
                                            users.photourl!.isNotEmpty
                                                ? CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor:
                                                        const Color(0xff4D4D4D),
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                            users.photourl ??
                                                                ""),
                                                  )
                                                : const CircleAvatar(
                                                    radius: 20.0,
                                                    backgroundColor:
                                                        Color(0xff4D4D4D),
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
                                      Flexible(
                                          child: Container(
                                        child: docs.isEmpty
                                            ? FlatButton(
                                                color: Colors.black,
                                                onPressed: () {
                                                  bidSheet(
                                                      context, posts, users);
                                                },
                                                child: Container(
                                                    width: 120,
                                                    alignment: Alignment.center,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Icon(
                                                          Icons.call,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          "Bid",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20),
                                                        )
                                                      ],
                                                    )))
                                            : FlatButton(
                                                color: Colors.orange,
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              HomePage(
                                                                  selectedIndex:
                                                                      3)));
                                                },
                                                child: Container(
                                                    width: 120,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Waiting",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ))),
                                      ))
                                    ],
                                  ))))
                    ],
                  )),
            );
          } else {
            return circularProgress(context);
          }
        });
  }

  // buildBidsButton() {
  //   return StreamBuilder<QuerySnapshot>(
  //       stream: bidRef
  //           .where('biduserid', isEqualTo: UserService().currentUid())
  //           .where('loadid', isEqualTo: posts.id)
  //           .snapshots(),
  //       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //         if (snapshot.hasData) {}
  //         // var isMe = snapshot.data!.docs.length;
  //         List<QueryDocumentSnapshot> docs = snapshot.data?.docs ?? [];
  //         return docs.isEmpty
  //             ? FlatButton(
  //                 color: Colors.black,
  //                 onPressed: () {},
  //                 child: Text(
  //                   "Bid",
  //                   style: TextStyle(color: Colors.white),
  //                 ))
  //             : FlatButton(
  //                 color: Colors.orange,
  //                 onPressed: () {},
  //                 child: Text(
  //                   "waiting",
  //                   style: TextStyle(color: Colors.white),
  //                 ));
  //       });
  // }

  ////Bid
  bidSheet(BuildContext context, PostModal post, UserModel user) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (
          context,
        ) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                color: Color(0xFF737373),
                child: Container(
                  child: _buildBidSheet(context, post, user),
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

  _buildBidSheet(BuildContext context, PostModal posts, UserModel users) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return StatefulBuilder(builder: (context, setState) {
      return Form(
          key: _formKey,
          child: Wrap(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(users.companyname!),
                    subtitle: Text(posts.sourcelocation!),
                    trailing: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close_rounded),
                    ),
                    leading: CircleAvatar(
                      child: ClipOval(
                        child: cachedNetworkImage(users.photourl!),
                      ),
                    ),
                  ),
                  Container(
                    color: Constants.h2lhbg,
                    child: ListTile(
                      title: Wrap(
                        children: [
                          Text(
                            posts.sourcelocation!,
                            // posts.sourcelocation!.split(',')[0] +
                            //     posts.sourcelocation!.split(',')[1],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(' - '),
                          Text(
                            posts.destinationlocation!,
                            // posts.destinationlocation!.split(',')[0] +
                            //     posts.destinationlocation!.split(',')[1],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      leading: const Icon(Icons.location_city),
                      subtitle: Row(
                        children: [
                          Text("Materials : ${posts.material}"),
                          Text("Quantity : ${posts.quantity} Tons")
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    height: 30,
                    alignment: Alignment.center,
                    width: 100,
                    color: Colors.grey[300],
                    child: Text(posts.loadposttime!.split(',')[1]),
                  ),
                  SizedBox(height: height * 0.02),
                  Card(
                      elevation: 8,
                      child: Container(
                        margin: EdgeInsets.all(15),
                        padding: EdgeInsets.only(bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Send Response to ${users.companyname}",
                              style: GoogleFonts.robotoSlab(fontSize: 16),
                            ),
                            TextFormField(
                              cursorColor: Constants.cursorColor,
                              controller: rateController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: "INR 800",
                                  labelStyle:
                                      GoogleFonts.kanit(color: Colors.black),
                                  labelText: "Please enter your rate",
                                  suffix: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Text(posts.priceunit!,
                                        style:
                                            TextStyle(color: Constants.alert)),
                                  )),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your rate';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            TextFormField(
                              controller: remakrsController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                  hintText: "Enter your remarks",
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder()),
                            )
                          ],
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: RaisedButton(
                        color: Constants.btnBG,
                        onPressed: () async {
                          FormState? form = _formKey.currentState;
                          form!.save();
                          if (!form.validate()) {
                            validate = true;
                          } else {
                            try {
                              loading = true;
                              var id = bidRef.doc().id;
                              await bidRef.doc(id).set({
                                'rate': rateController.text,
                                'remarks': remakrsController.text,
                                'bidtime': Jiffy(DateTime.now()).yMMMMEEEEdjm,
                                'biduserid': UserService().currentUid(),
                                'bidresponse': "",
                                'loadid': posts.postid,
                                'negotiateprice': "",
                                'btnvalue': "",
                                'id': id
                              }).catchError((e) {
                                print(e);
                              });

                              await postRef.doc(posts.id).update({
                                'loadorderstatus': 'Loadinprogress',
                                // 'biduserid': UserService().currentUid()
                              });

                              loading = false;
                              await CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.loading,
                                  text:
                                      'Your bid has been placed successfully, Please wait for the transporter to respond',
                                  lottieAsset: 'assets/1708-success.json',
                                  autoCloseDuration: Duration(seconds: 2),
                                  animType: CoolAlertAnimType.slideInUp,
                                  title: 'Bidding Successfully');

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage(selectedIndex: 3)));
                            } catch (e) {
                              print(e);
                              loading = false;
                            }
                          }
                        },
                        child: Container(
                            alignment: Alignment.center,
                            height: 45,
                            width: width,
                            child: const Text(
                              "Bid Now",
                              style: TextStyle(color: Colors.white),
                            ))),
                  )
                ],
              )
            ],
          ));
    });
  }
}
