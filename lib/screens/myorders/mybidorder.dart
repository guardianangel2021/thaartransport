// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thaartransport/addnewload/postmodal.dart';
import 'package:thaartransport/screens/myorders/ongoingorders.dart';
import 'package:thaartransport/services/userservice.dart';
import 'package:thaartransport/utils/constants.dart';
import 'package:thaartransport/utils/firebase.dart';

class MyBidOrder extends StatefulWidget {
  const MyBidOrder({Key? key}) : super(key: key);

  @override
  _MyBidOrderState createState() => _MyBidOrderState();
}

class _MyBidOrderState extends State<MyBidOrder> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: appBar(),
          body: TabBarView(children: [
            OnGoingOrders(),
            Text("data"),
          ])),
    );
  }

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 8,
      backgroundColor: Constants.btnBG,
      bottom: TabBar(
          labelColor: Constants.white,
          // indicatorColor: Constants.btnBG,
          // // labelColor: Constants.btnBG,
          // unselectedLabelColor: Colors.grey,

          indicatorColor: Constants.cursorColor,
          unselectedLabelColor: Color(0xffb8b0b8),
          labelStyle: TextStyle(fontSize: 18),
          tabs: [
            Tab(
              text: "OnGoing",
            ),
            Tab(
              text: "Completed",
            )
          ]),
    );
  }
}
