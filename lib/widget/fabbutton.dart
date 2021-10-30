import 'package:flutter/material.dart';
import 'package:thaartransport/Utils/constants.dart';
import 'package:thaartransport/addtruck/addtruck.dart';

Widget buildFAB(BuildContext context) {
  return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
      width: 50,
      height: 50,
      child: FloatingActionButton.extended(
          backgroundColor: Constants.floatingbtnBG,
          shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: Constants.floatingbtnBG)),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddTruck()));
          },
          label: SizedBox(),
          icon: const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
          )));
}

Widget buildExtendedFAB(BuildContext context) {
  return Padding(
      padding: EdgeInsets.only(right: 10),
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
          width: 150,
          height: 50,
          child: FloatingActionButton.extended(
              backgroundColor: Constants.floatingbtnBG,
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddTruck()));
              },
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              label: const Center(
                child: Text(
                  "ADD TRUCK",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ))));
}
