// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:thaartransport/Utils/firebase.dart';
import 'package:thaartransport/addtruck/UserRectangelImage.dart';
import 'package:thaartransport/screens/homepage.dart';

class UploadRC extends StatefulWidget {
  final String lorrynumber;
  final String id;
  UploadRC(this.lorrynumber, this.id);

  @override
  _UploadRCState createState() => _UploadRCState();
}

class _UploadRCState extends State<UploadRC> {
  String imgUrl1 = '';
  String imgUrl2 = '';
  String userId = user!.phoneNumber.toString();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload RC"),
      ),
      body: Column(
        children: [
          Container(
              width: width,
              alignment: Alignment.center,
              height: 30,
              color: Colors.black12,
              child:
                  Text.rich(TextSpan(text: 'Please upload RC for ', children: [
                TextSpan(
                    text: widget.lorrynumber.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold))
              ]))),
          SizedBox(
            height: height * 0.04,
          ),
          ForntImage(),
          SizedBox(
            height: height * 0.05,
          ),
          BackImage(),
          Spacer(),
          Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () async {
                  if (imgUrl1.isEmpty && imgUrl2.isEmpty) {
                    Fluttertoast.showToast(msg: 'Please select the both image');
                  } else if (imgUrl1.isEmpty) {
                    Fluttertoast.showToast(
                        msg: 'Please select the fornt image');
                  } else if (imgUrl2.isEmpty) {
                    Fluttertoast.showToast(msg: 'Please select the back image');
                  } else {
                    await truckRef.doc(widget.id).update({
                      'frontimage': imgUrl1,
                      'backimage': imgUrl2,
                      'truckloadstatus': 'Verification Pending',
                      "truckposttime": Jiffy(DateTime.now()).yMMMMEEEEdjm,
                    });

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  selectedIndex: 1,
                                )));
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: width,
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget ForntImage() {
    return InkWell(
      child: Column(
        children: [
          Text("Front Image"),
          SizedBox(
            height: 30,
          ),
          UserRectangelImage(onFileChanged: (imgUrl) {
            setState(() {
              this.imgUrl1 = imgUrl;
            });
          }),
        ],
      ),
    );
  }

  Widget BackImage() {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Text("Back image"),
          const SizedBox(
            height: 30,
          ),
          UserRectangelImage(onFileChanged: (imgUrl) {
            setState(() {
              this.imgUrl2 = imgUrl;
            });
          }),
        ],
      ),
    );
  }
}
