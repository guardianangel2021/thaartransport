// ignore: file_names
// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thaartransport/Utils/constants.dart';
import 'package:thaartransport/Utils/firebase.dart';
import 'package:thaartransport/services/userservice.dart';
import 'package:thaartransport/widget/fabbutton.dart';

class MyLorry extends StatefulWidget {
  const MyLorry({Key? key}) : super(key: key);

  @override
  _MyLorryState createState() => _MyLorryState();
}

class _MyLorryState extends State<MyLorry> {
  bool isFab = false;
  ScrollController scrollController = ScrollController();
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset > 50) {
        setState(() {
          isFab = true;
        });
      } else {
        setState(() {
          isFab = false;
        });
      }
    });
  }

  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  String id = user!.phoneNumber.toString();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        floatingActionButton:
            isFab ? buildFAB(context) : buildExtendedFAB(context),
        body: StreamBuilder<QuerySnapshot>(
            stream: truckRef
                .where('ownerId', isEqualTo: UserService().currentUid())
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Scaffold(body: Text("Somthing went Wrong"));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: Text("Loading...")));
              } else if (snapshot.data!.docs.isEmpty) {
                return Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "You have not active loads at the moment",
                    ));
              }
              final data = snapshot.requireData;
              return Padding(
                  padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      heading(),
                      SizedBox(height: height * 0.03),
                      ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                truckData(
                                  data.docs[index]['lorrynumber'],
                                  data.docs[index]['truckloadstatus'],
                                )
                              ],
                            );
                          })
                    ],
                  ));
            }));
  }

  Widget heading() {
    return const Text(
      'Other Trucks',
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget truckData(
    String truckNo,
    String status,
  ) {
    return Card(
      elevation: 10,
      child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.traffic_outlined),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    truckNo,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.warning_rounded,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(status),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              RaisedButton(
                color: Colors.red,
                onPressed: () {},
                child: Container(
                    alignment: Alignment.center,
                    height: 45,
                    child: Text(
                      'UPLOAD TRUCKS RC IMAGE',
                      style: TextStyle(
                        color: Constants.white,
                      ),
                    )),
              )
            ],
          )),
    );
  }
}
