// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:thaartransport/addnewload/PostLoad.dart';
import 'package:thaartransport/viewordersbid/bidresponse.dart';
import 'package:thaartransport/addnewload/postmodal.dart';
import 'package:thaartransport/addnewload/updateload.dart';
import 'package:thaartransport/modal/usermodal.dart';
import 'package:thaartransport/screens/bid/bidpage.dart';
import 'package:thaartransport/screens/market/bidmodal.dart';
import 'package:thaartransport/utils/constants.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
import 'package:thaartransport/utils/firebase.dart';
import 'package:thaartransport/widget/indicatiors.dart';
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
  ScrollController scrollController = ScrollController();
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
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 5,
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    // onTap: () => showModalBottomSheet(
                    //     context: context, builder: (context) => buildSheet()),
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.posts.loadstatus == "Active"
                        ? Container(
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
                                      fontSize: 18,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        : widget.posts.loadstatus == "Expired"
                            ? Container(
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
                                      "Load Expired",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            : widget.posts.loadstatus == "Intransit"
                                ? Container(
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
                                          "In Transit",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
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
                                          "Load Completed",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
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
        widget.posts.loadorderstatus == "Expired" &&
                widget.posts.loadorderstatus == "Expired"
            ? repostButton()
            : WhatsAppButton(),
        tabBar(),
      ],
    );
  }

  Widget repostButton() {
    return FlatButton(
        color: Colors.grey,
        textColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UpdateLoad(
                        posts: widget.posts,
                      )));
        },
        child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.refresh),
              SizedBox(
                width: 5,
              ),
              Text("Repost Load")
            ],
          ),
        ));
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
                  BidResponse(
                    posts: widget.posts,
                  ),
                  Text("data")
                ]),
              )
            ],
          ),
        ));
  }
}

//   Widget buildSheet() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: ListView(
//         shrinkWrap: true,
//         children: [
//           Text(
//             "Your Trip Details",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           TimelineTile(
//             indicatorStyle: IndicatorStyle(height: 30, width: 30),
//             isFirst: true,
//             endChild: Container(
//                 height: 60,
//                 width: 80,
//                 alignment: Alignment.center,
//                 child: ListTile(
//                   title: Text(
//                     "Load Posted",
//                     // style: TextStyle(fontSize: 20),
//                   ),
//                   subtitle: Text("Your Load is available in Live Market"),
//                 )),
//           ),
//           TimelineTile(
//             indicatorStyle: IndicatorStyle(height: 30, width: 30),
//             isFirst: false,
//             endChild: Container(
//                 height: 60,
//                 // color: Colors.red,
//                 width: 80,
//                 alignment: Alignment.center,
//                 child: ListTile(
//                   title: Text("Load In Progress"),
//                   // subtitle: Text(data),
//                 )),
//           ),
//           TimelineTile(
//             indicatorStyle: IndicatorStyle(height: 30, width: 30),
//             isFirst: false,
//             endChild: Container(
//                 height: 60,
//                 width: 80,
//                 alignment: Alignment.center,
//                 child: ListTile(
//                   title: Text("Load in Transit"),
//                 )),
//           ),
//           TimelineTile(
//             indicatorStyle: IndicatorStyle(height: 30, width: 30),
//             isFirst: false,
//             endChild: Container(
//                 height: 60,
//                 width: 80,
//                 alignment: Alignment.center,
//                 child: ListTile(
//                   title: Text("Trip Completed"),
//                 )),
//           ),
//           SizedBox(
//             height: 30,
//           ),
//           RaisedButton(
//             color: Colors.blue,
//             onPressed: () {},
//             child: Container(
//               height: 45,
//               alignment: Alignment.center,
//               child: Text(
//                 "OKAY, GOT IT",
//                 style: TextStyle(color: Colors.white, fontSize: 18),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
