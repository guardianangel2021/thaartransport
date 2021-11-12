// // ignore_for_file: unrelated_type_equality_checks

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cool_alert/cool_alert.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shimmer_animation/shimmer_animation.dart';

// import 'package:jiffy/jiffy.dart';
// import 'package:thaartransport/addnewload/PostLoad.dart';
// import 'package:thaartransport/addnewload/orderdata.dart';
// import 'package:thaartransport/addnewload/postmodal.dart';
// import 'package:thaartransport/modal/usermodal.dart';
// import 'package:thaartransport/screens/bid/bidpage.dart';
// import 'package:thaartransport/services/userservice.dart';
// import 'package:thaartransport/utils/constants.dart';
// import 'package:thaartransport/utils/controllers.dart';
// import 'package:thaartransport/utils/firebase.dart';
// import 'package:thaartransport/widget/cached_image.dart';
// //import 'package:flutter_icons/flutter_icons.dart';
// import 'package:timeago/timeago.dart' as timeago;

// class UserPost extends StatelessWidget {
//   final PostModal posts;

//   UserPost({
//     required this.posts,
//   });
//   final DateTime timestamp = DateTime.now();

//   currentUserId() {
//     return firebaseAuth.currentUser!.uid;
//   }

//   final _formKey = GlobalKey<FormState>();
//   bool validate = false;
//   bool loading = false;
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: postRef.doc(posts.id).collection('Bid').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return const Text("Somthing went Wrong");
//           } else if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: Text("Loading..."));
//           }
//           return ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               physics: ScrollPhysics(),
//               padding: EdgeInsets.all(0),
//               shrinkWrap: true,
//               itemBuilder: (context, index) {
//                 PostModal bidpost = PostModal.fromJson(
//                     snapshot.data!.docs[index].data() as Map<String, dynamic>);

//                 return LoadPosts(context, bidpost);
//               });
//         });
//   }

//   Widget LoadPosts(BuildContext context, PostModal bidpost) {
//     var ref = posts.postid;
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return StreamBuilder(
//         stream: usersRef.doc(posts.ownerId).snapshots(),
//         builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return const Text("Somthing went Wrong");
//           } else if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: Text("Loading..."));
//           }
//           UserModel users =
//               UserModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
//           bool isMe = UserService().currentUid == posts.ownerId;
//           // bool isStatus = posts.loadstatus as bool;
//           return InkWell(
//             onTap: () {
//               posts.loadorderstatus == "Loadinprogress" &&
//                       bidpost.biduserid == currentUserId()
//                   ? Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => BidPage(
//                                 posts: posts,
//                                 users: users,
//                               )))
//                   : bidSheet(context, posts, users);
//             },
//             child: Card(
//                 // color: Colors.red,

//                 elevation: 8,
//                 child: Column(
//                   children: [
//                     Container(
//                       // height: 20,
//                       padding: EdgeInsets.only(top: 20, left: 10, right: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               // Container(
//                               //   width: 80,
//                               //   height: 22,
//                               //   alignment: Alignment.center,
//                               //   decoration: BoxDecoration(
//                               //       border: Border.all(),
//                               //       borderRadius: BorderRadius.circular(25)),
//                               //   child: Text(
//                               //     status.toUpperCase(),
//                               //     style: TextStyle(
//                               //       fontStyle: FontStyle.italic,
//                               //       fontWeight: FontWeight.bold,
//                               //       color: status == "Active"
//                               //           ? Constants.cursorColor
//                               //           : Constants.alert,
//                               //     ),
//                               //   ),
//                               // ),
//                               Text(posts.loadposttime!.split(',')[1] +
//                                   posts.loadposttime!.split(',')[2])
//                             ],
//                           ),
//                           SizedBox(height: height * 0.02),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Column(
//                                 children: [
//                                   Text(
//                                     posts.sourcelocation!.split(',')[0],
//                                     style: GoogleFonts.lato(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16),
//                                   ),
//                                   Text(posts.sourcelocation!.split(',')[1]),
//                                 ],
//                               ),
//                               const Icon(Icons.arrow_right_alt_outlined),
//                               Column(
//                                 children: [
//                                   Text(
//                                     posts.destinationlocation!.split(',')[0],
//                                     style: GoogleFonts.lato(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16),
//                                   ),
//                                   Text(
//                                       posts.destinationlocation!.split(',')[1]),
//                                 ],
//                               )
//                             ],
//                           ),
//                           Divider(),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image.asset(
//                                       'assets/images/product.png',
//                                       height: 20,
//                                       width: 20,
//                                     ),
//                                     SizedBox(
//                                       width: width * 0.05,
//                                     ),
//                                     Text(
//                                       posts.material!,
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image.asset(
//                                       'assets/images/quantity.png',
//                                       height: 20,
//                                       width: 20,
//                                     ),
//                                     SizedBox(
//                                       width: width * 0.05,
//                                     ),
//                                     Text(
//                                       "${posts.quantity} Tons",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold),
//                                     )
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                           Divider(),
//                           SizedBox(
//                             height: height * 0.01,
//                           ),
//                           Row(
//                             children: [
//                               Image.asset(
//                                 'assets/images/rupee-indian.png',
//                                 height: 20,
//                                 width: 20,
//                               ),
//                               Text(posts.expectedprice!,
//                                   style: GoogleFonts.lato(fontSize: 18)),
//                               SizedBox(
//                                 width: width * 0.02,
//                               ),
//                               Text(
//                                   posts.priceunit == 'tonne'
//                                       ? "per ${posts.priceunit}"
//                                       : posts.priceunit!,
//                                   style: const TextStyle(fontSize: 18)),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: height * 0.01),
//                     Visibility(
//                         visible: !isMe,
//                         child: Card(
//                             elevation: 0,
//                             color: Colors.grey[100],
//                             child: ListTile(
//                                 title: Text(users.username!),
//                                 subtitle: Text(users.companyname!),
//                                 leading: users.photourl!.isNotEmpty
//                                     ? CircleAvatar(
//                                         radius: 20,
//                                         backgroundColor:
//                                             const Color(0xff4D4D4D),
//                                         backgroundImage:
//                                             CachedNetworkImageProvider(
//                                                 users.photourl ?? ""),
//                                       )
//                                     : const CircleAvatar(
//                                         radius: 20.0,
//                                         backgroundColor: Color(0xff4D4D4D),
//                                       ),
//                                 trailing:
//                                     posts.loadorderstatus == "Loadinprogress" &&
//                                             bidpost.biduserid == currentUserId()
//                                         ? FlatButton(
//                                             color: Colors.orange,
//                                             onPressed: () {},
//                                             child: Text(
//                                               "Waiting",
//                                               style: TextStyle(
//                                                   color: Constants.white,
//                                                   fontSize: 18),
//                                             ))
//                                         : FlatButton(
//                                             color: Colors.black,
//                                             onPressed: () {
//                                               bidSheet(context, posts, users);
//                                             },
//                                             child: Text(
//                                               "BID",
//                                               style: TextStyle(
//                                                   color: Constants.white,
//                                                   fontSize: 18),
//                                             ),
//                                           ))))
//                   ],
//                 )),
//           );
//         });
//   }

//   ////Bid
//   bidSheet(BuildContext context, PostModal post, UserModel user) {
//     showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (
//           context,
//         ) {
//           return Padding(
//               padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).viewInsets.bottom),
//               child: Container(
//                 color: Color(0xFF737373),
//                 child: Container(
//                   child: _buildBidSheet(context, post, user),
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

//   _buildBidSheet(BuildContext context, PostModal posts, UserModel users) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return StatefulBuilder(builder: (context, setState) {
//       return Form(
//           key: _formKey,
//           child: Wrap(
//             children: [
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   ListTile(
//                     title: Text(users.companyname!),
//                     subtitle: Text(posts.sourcelocation!),
//                     trailing: InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Icon(Icons.close_rounded),
//                     ),
//                     leading: CircleAvatar(
//                       child: ClipOval(
//                         child: cachedNetworkImage(users.photourl!),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     color: Constants.h2lhbg,
//                     child: ListTile(
//                       title: Wrap(
//                         children: [
//                           Text(
//                             posts.sourcelocation!.split(',')[0] +
//                                 posts.sourcelocation!.split(',')[1],
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           Text(' - '),
//                           Text(
//                             posts.destinationlocation!.split(',')[0] +
//                                 posts.destinationlocation!.split(',')[1],
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                       leading: const Icon(Icons.location_city),
//                       subtitle: Row(
//                         children: [
//                           Text("Materials : ${posts.material}"),
//                           Text("Quantity : ${posts.quantity} Tons")
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: height * 0.02,
//                   ),
//                   Container(
//                     height: 30,
//                     alignment: Alignment.center,
//                     width: 100,
//                     color: Colors.grey[300],
//                     child: Text(posts.loadposttime!.split(',')[1]),
//                   ),
//                   SizedBox(height: height * 0.02),
//                   Card(
//                       elevation: 8,
//                       child: Container(
//                         margin: EdgeInsets.all(15),
//                         padding: EdgeInsets.only(bottom: 5),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               "Send Response to ${users.companyname}",
//                               style: GoogleFonts.robotoSlab(fontSize: 16),
//                             ),
//                             TextFormField(
//                               cursorColor: Constants.cursorColor,
//                               controller: rateController,
//                               keyboardType: TextInputType.number,
//                               decoration: InputDecoration(
//                                   hintText: "INR 800",
//                                   labelStyle:
//                                       GoogleFonts.kanit(color: Colors.black),
//                                   labelText: "Please enter your rate",
//                                   suffix: Container(
//                                     margin: EdgeInsets.only(right: 10),
//                                     child: Text(posts.priceunit!,
//                                         style:
//                                             TextStyle(color: Constants.alert)),
//                                   )),
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return 'Please enter your rate';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(
//                               height: height * 0.02,
//                             ),
//                             TextFormField(
//                               controller: remakrsController,
//                               maxLines: 3,
//                               decoration: const InputDecoration(
//                                   hintText: "Enter your remarks",
//                                   border: OutlineInputBorder(),
//                                   focusedBorder: OutlineInputBorder()),
//                             )
//                           ],
//                         ),
//                       )),
//                   Padding(
//                     padding: EdgeInsets.all(15),
//                     child: RaisedButton(
//                         color: Constants.btnBG,
//                         onPressed: () async {
//                           FormState? form = _formKey.currentState;
//                           form!.save();
//                           if (!form.validate()) {
//                             validate = true;
//                           } else {
//                             try {
//                               loading = true;

//                               await postRef
//                                   .doc(posts.id)
//                                   .collection('Bid')
//                                   .doc(UserService().currentUid())
//                                   .set({
//                                 'rate': rateController.text,
//                                 'remarks': remakrsController.text,
//                                 'bidtime': Jiffy(DateTime.now()).yMMMMEEEEdjm,
//                                 'biduserid': UserService().currentUid(),
//                                 'bidresponse': ""
//                                 // 'biduserlocation': users.location,
//                                 // 'biduserdp': users.photourl,
//                                 // 'bidusername': users.username.toString()
//                               }).catchError((e) {
//                                 print(e);
//                               });

//                               await postRef.doc(posts.id).update({
//                                 'loadorderstatus': 'Loadinprogress',
//                               });

//                               loading = false;
//                               await CoolAlert.show(
//                                   context: context,
//                                   type: CoolAlertType.loading,
//                                   text:
//                                       'Your bid has been placed successfully, Please wait for the transporter to respond',
//                                   lottieAsset: 'assets/1708-success.json',
//                                   autoCloseDuration: Duration(seconds: 2),
//                                   animType: CoolAlertAnimType.slideInUp,
//                                   title: 'Bidding Successfully');

//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => BidPage(
//                                             posts: posts,
//                                             users: users,
//                                           )));
//                             } catch (e) {
//                               print(e);
//                               loading = false;
//                             }
//                           }
//                         },
//                         child: Container(
//                             alignment: Alignment.center,
//                             height: 45,
//                             width: width,
//                             child: const Text(
//                               "Bid Now",
//                               style: TextStyle(color: Colors.white),
//                             ))),
//                   )
//                 ],
//               )
//             ],
//           ));
//     });
//   }
// }
