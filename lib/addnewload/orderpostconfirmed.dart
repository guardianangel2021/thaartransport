import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:thaartransport/addnewload/postmodal.dart';
import 'package:thaartransport/screens/homepage.dart';
import 'package:thaartransport/services/userservice.dart';
import 'package:thaartransport/utils/constants.dart';
import 'package:thaartransport/utils/firebase.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderPostConfirmed extends StatefulWidget {
  final String id;
  OrderPostConfirmed(this.id);

  @override
  _OrderPostConfirmedState createState() => _OrderPostConfirmedState();
}

class _OrderPostConfirmedState extends State<OrderPostConfirmed> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: postRef.doc(widget.id).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Scaffold(body: Text("Somthing went Wrong"));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Text("Loading..."));
          }
          final PostModal posts =
              PostModal.fromJson(snapshot.data!.data() as Map<String, dynamic>);

          return WillPopScope(
              onWillPop: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
                return true;
              },
              child: Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 200,
                      titleSpacing: 3,
                      title: Text(
                          "Posted at ${posts.loadposttime!.split(',')[1]}${posts.loadposttime!.split(',')[2]}",
                          style: TextStyle(fontSize: 13)),
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                              margin: EdgeInsets.only(top: 130),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(posts.sourcelocation!,
                                      style: GoogleFonts.lato(
                                          textStyle: const TextStyle(
                                              fontSize: 25,
                                              color: Colors.white))),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_downward,
                                    color: Constants.white,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(posts.destinationlocation!,
                                      style: GoogleFonts.lato(
                                          textStyle: const TextStyle(
                                              fontSize: 25,
                                              color: Colors.white)))
                                ],
                              ))),
                      actions: [
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          child: PopupMenuButton(
                            icon: Icon(
                              Icons.more_vert,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  value: 1,
                                  enabled: true,
                                  child: Text(
                                    "disable",
                                  )),
                            ],
                            onSelected: (menu) {
                              if (menu == 1) {
                                CoolAlert.show(
                                    backgroundColor: Colors.white,
                                    context: context,
                                    type: CoolAlertType.error,
                                    text:
                                        'Are you sure you want to disable this post from the live market?',
                                    confirmBtnColor: Colors.green,
                                    animType: CoolAlertAnimType.slideInUp,
                                    cancelBtnText: "Cancel",
                                    showCancelBtn: true,
                                    onConfirmBtnTap: () {
                                      Navigator.pop(context);
                                    },
                                    onCancelBtnTap: () {
                                      Navigator.pop(context);
                                    },
                                    confirmBtnText: "Yes",
                                    title: 'Disable Confirmation');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      LoadPosted(
                          posts.material!.toUpperCase(),
                          posts.quantity!.toUpperCase(),
                          posts.paymentmode!.toUpperCase(),
                          posts.expectedprice!,
                          posts.priceunit!),
                      tabBar(),
                    ]))
                  ],
                ),
              ));
        });
  }

  Widget LoadPosted(String material, String quantity, String PaymentMode,
      String expectedPrice, String priceUnit) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Card(
      elevation: 10,
      child: Container(
        height: 200,
        width: width,
        padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
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
    );
  }

  Widget tabBar() {
    return DefaultTabController(
        length: 2,
        child: Container(
          // padding:
          // const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          child: Column(
            children: [
              RaisedButton(
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
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    scale: 4,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "You'll receive transporter Bids here!",
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 25,
                        width: 100,
                        decoration: BoxDecoration(border: Border.all()),
                        child: const Text('15 - 20 MINS'),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const TabBar(tabs: [
                Tab(
                  child: Text(
                    'LIVE LORRIES',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    "TRANSPORTERS",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ]),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 500,
                child: const TabBarView(children: [Text("data"), Text("data")]),
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
