import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thaartransport/addnewload/postmodal.dart';
import 'package:thaartransport/modal/usermodal.dart';
import 'package:thaartransport/screens/market/bidmodal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:thaartransport/screens/myorders/acceptedbid.dart';
import 'package:thaartransport/screens/myorders/allbids.dart';
import 'package:thaartransport/screens/myorders/rejectedbid.dart';
import 'package:thaartransport/services/userservice.dart';
import 'package:thaartransport/utils/constants.dart';
import 'package:thaartransport/utils/firebase.dart';

class OnGoingOrders extends StatefulWidget {
  const OnGoingOrders({Key? key}) : super(key: key);

  @override
  _OnGoingOrdersState createState() => _OnGoingOrdersState();
}

class _OnGoingOrdersState extends State<OnGoingOrders> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: appBar(),
        body: TabBarView(children: [AllBids(), AcceptedBids(), RejectedBids()]),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      toolbarHeight: 15,
      bottom: TabBar(
          labelStyle: TextStyle(fontSize: 18),
          unselectedLabelStyle: TextStyle(),
          indicatorWeight: 0,
          labelColor: Constants.btnBG,
          unselectedLabelColor: Color(0xfff183850),
          indicator: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.grey[100],

              // boxShadow: ,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(
                25,
              )),
          tabs: const [
            Tab(
              text: "All",
            ),
            Tab(
              text: "Accepted",
            ),
            Tab(
              text: "Rejected",
            )
          ]),
    );
  }
}
