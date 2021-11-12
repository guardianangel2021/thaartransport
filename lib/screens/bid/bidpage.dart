// // ignore_for_file: unnecessary_new

// import 'dart:async';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:thaartransport/addnewload/postmodal.dart';
// import 'package:thaartransport/modal/usermodal.dart';
// import 'package:thaartransport/screens/homepage.dart';
// import 'package:thaartransport/screens/market/bidmodal.dart';
// import 'package:thaartransport/services/userservice.dart';
// import 'package:fluttericon/typicons_icons.dart';
// import 'package:thaartransport/utils/constants.dart';
// import 'package:thaartransport/utils/controllers.dart';
// import 'package:thaartransport/utils/firebase.dart';

// class BidPage extends StatefulWidget {
//   PostModal posts;
//   UserModel users;
//   BidPage({required this.posts, required this.users});

//   @override
//   _BidPageState createState() => _BidPageState();
// }

// class _BidPageState extends State<BidPage> {
//   bool _buttonVisibility = false;
//   DateTime? lastClicked;
//   void initState() {
//     if (lastClicked == null) {
//       setState(() => _buttonVisibility = true);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // bool isMe = widget.posts.bidresponse == UserService().currentUid();
//     return WillPopScope(
//         onWillPop: () async {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => HomePage()));

//           return true;
//         },
//         child: Scaffold(
//           body: SafeArea(
//               child: SingleChildScrollView(
//                   child: Column(
//             children: [
//               Heading(),
//               CurrentuserBidData(),
//               AnotheruserBidData(),
//               SizedBox(
//                 height: 20,
//               ),
//               // response()
//             ],
//           ))),
//         ));
//   }

//   Widget Heading() {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return Container(
//         child: Row(
//       children: [
//         InkWell(
//           onTap: () {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => HomePage()));
//           },
//           child: const Icon(Icons.arrow_back),
//         ),
//         SizedBox(
//           width: width * 0.03,
//         ),
//         CircleAvatar(
//           child: ClipOval(
//             child: CachedNetworkImage(
//               imageUrl: widget.users.photourl!,
//               fit: BoxFit.cover,
//               height: height,
//               width: width,
//             ),
//           ),
//         ),
//         SizedBox(
//           width: width * 0.02,
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(widget.users.username!),
//             Text(widget.users.location!),
//           ],
//         ),
//         Spacer(),
//         Container(
//           child: Icon(Icons.refresh),
//         ),
//         const SizedBox(
//           width: 20,
//         ),
//         Container(
//           width: 40,
//           height: 30,
//           margin: const EdgeInsets.only(right: 10),
//           decoration: BoxDecoration(border: Border.all()),
//           child: const Icon(Icons.call),
//         )
//       ],
//     ));
//   }

//   Widget CurrentuserBidData() {
//     return Padding(
//         padding: const EdgeInsets.only(top: 20, left: 10, right: 50),
//         child: Card(
//             elevation: 8,
//             child: Container(
//               padding: const EdgeInsets.only(left: 10),
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       height: 25,
//                       width: 150,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           border: Border.all(),
//                           borderRadius: BorderRadius.circular(20)),
//                       margin: EdgeInsets.only(left: 20),
//                       child: Text(widget.posts.paymentmode!),
//                     ),
//                     const SizedBox(
//                       height: 40,
//                     ),
//                     Row(
//                       children: [
//                         Image.asset(
//                           'assets/images/rupee-indian.png',
//                           height: 15,
//                           width: 15,
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Text(
//                           widget.posts.expectedprice!,
//                           style: TextStyle(
//                               fontSize: 22, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(
//                           width: 5,
//                         ),
//                         Text(widget.posts.priceunit == 'tonne'
//                             ? "(Per ${widget.posts.priceunit})"
//                             : "(" + widget.posts.priceunit! + ")")
//                       ],
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Wrap(
//                       // mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           widget.posts.sourcelocation!.split(',')[0],
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                         Text(
//                           widget.posts.sourcelocation!.split(',')[1],
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                         const Icon(Icons.arrow_right_alt),
//                         Text(
//                           widget.posts.destinationlocation!.split(',')[0],
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                         Text(
//                           widget.posts.destinationlocation!.split(',')[1],
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                   ]),
//             )));
//   }

//   Widget AnotheruserBidData() {
//     return StreamBuilder(
//         stream: bidRef
//             .where('biduserid', isEqualTo: UserService().currentUid())
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return const Text("Somthing went Wrong");
//           } else if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: Text("Loading..."));
//           }

//           return ListView.builder(
//               shrinkWrap: true,
//               physics: BouncingScrollPhysics(),
//               scrollDirection: Axis.vertical,
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, int index) {
//                 BidModal bidpost = BidModal.fromJson(
//                     snapshot.data!.docs[index].data() as Map<String, dynamic>);

//                 return AnotheruserBid(bidpost);
//               });
//         });
//   }

//   Widget AnotheruserBid(BidModal bidpost) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 50, right: 10, top: 20),
//       child: Card(
//         elevation: 8,
//         child: Container(
//           padding: EdgeInsets.only(left: 10, top: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 // mainAxisAlignment: post.bidresponse == ""
//                 //     ? MainAxisAlignment.start
//                 //     : MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/images/rupee-indian.png',
//                     height: 15,
//                     width: 15,
//                   ),
//                   const SizedBox(
//                     width: 5,
//                   ),
//                   Text(
//                     bidpost.rate!,
//                     style: const TextStyle(
//                         fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(
//                     width: 5,
//                   ),
//                   Text(widget.posts.priceunit == 'tonne'
//                       ? "(Per ${widget.posts.priceunit})"
//                       : "(" + widget.posts.priceunit! + ")")
//                 ],
//               ),
//               bidpost.bidresponse == ""
//                   ? const SizedBox(
//                       height: 30,
//                     )
//                   : const SizedBox(
//                       height: 10,
//                     ),

//               bidpost.bidresponse == ""
//                   ? Row(
//                       children: const [
//                         Icon(Typicons.clock),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         Text("Waiting for Acceptance"),
//                       ],
//                     )
//                   : Text(
//                       bidpost.bidresponse!,
//                       style: TextStyle(),
//                     ),

//               const SizedBox(
//                 height: 20,
//               )

//               // Visibility(
//               //     visible: _buttonVisibility,
//               //     child: InkWell(
//               //       onTap: () {
//               //         setState(() {
//               //           lastClicked = DateTime.now();
//               //           _buttonVisibility = false;
//               //           // change this seconds with `hours:1`
//               //           new Timer(Duration(seconds: 2),
//               //               () => setState(() => _buttonVisibility = true));
//               //         });
//               //         bidSheet(
//               //           context,
//               //         );
//               //       },
//               //       child: Container(
//               //           height: 40,
//               //           width: 120,
//               //           alignment: Alignment.center,
//               //           decoration: BoxDecoration(
//               //               border: Border.all(color: Colors.blue),
//               //               borderRadius: BorderRadius.circular(25)),
//               //           child: const Text(
//               //             "Update Bid",
//               //             style: TextStyle(color: Colors.blue),
//               //           )),
//               //     )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget response() {
//   //   return StreamBuilder(
//   //       stream: postRef.doc(widget.posts.id).collection('Bid').snapshots(),
//   //       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//   //         if (snapshot.hasError) {
//   //           return const Text("Somthing went Wrong");
//   //         } else if (snapshot.connectionState == ConnectionState.waiting) {
//   //           return const Center(child: Text("Loading..."));
//   //         }

//   //         return ListView.builder(
//   //             shrinkWrap: true,
//   //             physics: BouncingScrollPhysics(),
//   //             scrollDirection: Axis.vertical,
//   //             itemCount: snapshot.data!.docs.length,
//   //             itemBuilder: (context, int index) {
//   //               PostModal post = PostModal.fromJson(
//   //                   snapshot.data!.docs[index].data() as Map<String, dynamic>);

//   //               return Padding(
//   //                   padding: const EdgeInsets.only(left: 20, right: 20),
//   //                   child: Container(
//   //                     alignment: Alignment.center,
//   //                     decoration: BoxDecoration(border: Border.all()),
//   //                     height: 40,
//   //                     width: 100,
//   //                     child: Row(
//   //                       mainAxisAlignment: MainAxisAlignment.center,
//   //                       children: [
//   //                         Icon(
//   //                           post.bidresponse == "Bid Accepted"
//   //                               ? Icons.check_circle_outline
//   //                               : Icons.warning_rounded,
//   //                           color: post.bidresponse == "Bid Accepted"
//   //                               ? Constants.cursorColor
//   //                               : Constants.alert,
//   //                         ),
//   //                         const SizedBox(
//   //                           width: 20,
//   //                         ),
//   //                         Text(
//   //                           post.bidresponse!,
//   //                           style: TextStyle(
//   //                             color: post.bidresponse == "Bid Accepted"
//   //                                 ? Constants.cursorColor
//   //                                 : Constants.alert,
//   //                           ),
//   //                         )
//   //                       ],
//   //                     ),
//   //                   ));
//   //             });
//   //       });
//   // }

//   bidSheet(
//     BuildContext context,
//   ) {
//     showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (
//           context,
//         ) {
//           return Padding(
//               padding: EdgeInsets.only(
//                   left: 15,
//                   right: 15,
//                   top: 20,
//                   bottom: MediaQuery.of(context).viewInsets.bottom),
//               child: Container(
//                 child: Container(
//                   child: _buildBidSheet(
//                     context,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).canvasColor,
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(10),
//                       topRight: Radius.circular(10),
//                     ),
//                   ),
//                 ),
//               ));
//         });
//   }

//   Widget _buildBidSheet(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return StatefulBuilder(builder: (context, setState) {
//       return Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 "Enter your new bid amount",
//                 style: TextStyle(fontSize: 20),
//               ),
//               InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Icon(Icons.close_rounded))
//             ],
//           ),
//           SizedBox(
//             height: height * 0.03,
//           ),
//           const Text("Enter new price", style: TextStyle(fontSize: 18)),
//           TextFormField(
//             controller: bidAmountcontroller,
//             decoration: InputDecoration(
//                 suffix: Container(
//               margin: EdgeInsets.only(right: 10),
//               child: Text(widget.posts.priceunit!,
//                   style: TextStyle(color: Constants.alert)),
//             )),
//           ),
//           SizedBox(
//             height: height * 0.03,
//           ),
//           RaisedButton(
//             color: Constants.btnBG,
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Container(
//               height: 45,
//               width: width,
//               alignment: Alignment.center,
//               child: Text(
//                 "Update Bid",
//                 style: TextStyle(color: Constants.white, fontSize: 20),
//               ),
//             ),
//           )
//         ],
//       );
//     });
//   }
// }
