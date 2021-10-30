// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unused_local_variable, prefer_function_declarations_over_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:thaartransport/Utils/constants.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:thaartransport/addtruck/truckcurrentlocation.dart';
import 'package:thaartransport/addtruck/uploadrc.dart';
import 'package:thaartransport/addtruck/validations.dart';
import 'package:thaartransport/modal/usermodal.dart';
import 'package:thaartransport/screens/homepage.dart';

import 'package:thaartransport/services/userservice.dart';
import 'package:thaartransport/utils/controllers.dart';
import 'package:thaartransport/utils/firebase.dart';

class AddTruck extends StatefulWidget {
  const AddTruck({Key? key}) : super(key: key);

  @override
  _AddTruckState createState() => _AddTruckState();
}

class _AddTruckState extends State<AddTruck> {
  bool showDoc = false;
  bool validate = false;
  bool loading = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    // getsearchCity().then(updateCurrentCity);
    // currentcity.clear();
  }

  var id = truckRef.doc().id.toString();
  String imgUrl1 = '';
  String imgUrl2 = '';
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.btntextactive,
        title: Text("Add New"),
      ),
      body: Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: height * 0.04),
          child: Container(
              child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                _BuildTextField(),
                SizedBox(
                  height: height * 0.06,
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                documentField()
              ],
            ),
          ))),
    );
  }

  Widget _BuildTextField() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Form(
      key: formkey,
      child: Column(
        children: [
          TextFormField(
            initialValue: trucksearchlocation.text,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TruckCurrentLocation()));
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Current City',
                hintText: 'Search source city',
                labelStyle: TextStyle(color: Colors.black),
                hintStyle: TextStyle(color: Colors.black26)),
            validator: (value) {
              if (value!.isEmpty) {
                return 'EnterCity, Eg. Mumbai';
              }
              return null;
            },
          ),
          SizedBox(
            height: height * 0.03,
          ),
          TextFormField(
              controller: lorrynumber,
              maxLength: 10,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Lorry Number',
                hintText: 'KA 10 AE 5555',
                labelStyle: TextStyle(color: Colors.black),
                hintStyle: TextStyle(color: Colors.black26),
              ),
              validator: Validations.validateNumber),
          SizedBox(
            height: height * 0.03,
          ),
          TextFormField(
              controller: truckcapacity,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "In Tonne(S)",
                  labelText: 'Capacity',
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black26)),
              validator: (value) {
                if (value!.isEmpty || value == '') {
                  return 'Please enter the capacity';
                } else if (int.parse(value) > 100) {
                  return 'Capacity more than 100 tonnes is not allowed';
                }
              }),
        ],
      ),
    );
  }

  Widget documentField() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return DottedBorder(
        color: Colors.blue,
        child: InkWell(
          onTap: () async {
            final isValid = formkey.currentState!.validate();
            if (!isValid) {
              return;
            }
            formkey.currentState!.save();
            dialog();
          },
          child: Container(
              height: height * 0.06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Text(
                    "Upload Documents",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              )),
        ));
  }

  Future dialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text("Are you sure?"),
                content: const Text("Do you want to  process further"),
                actions: [
                  FlatButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("No")),
                  FlatButton(
                      onPressed: () async {
                        FormState? form = formkey.currentState;
                        form!.save();
                        if (!form.validate()) {
                          validate = true;
                          showInSnackBar(
                              "Please fix the error in red before submitting.",
                              context);
                        } else {
                          try {
                            DocumentSnapshot doc = await usersRef
                                .doc(firebaseAuth.currentUser!.uid)
                                .get();
                            var user = UserModel.fromJson(
                                doc.data() as Map<String, dynamic>);
                            var truckref = truckRef.doc();
                            loading = true;
                            truckref.set({
                              "id": truckref.id,
                              "truckpostid": truckref.id,
                              "ownerId": user.id,
                              "dp": user.photourl,
                              "lorrynumber": lorrynumber.text.toUpperCase(),
                              "sourcelocation": trucksearchlocation.text,
                              "capacity": truckcapacity.text,
                              "usernumber": user.usernumber,
                            }).catchError((e) {
                              print(e);
                            });

                            loading = false;

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UploadRC(
                                        lorrynumber.text, truckref.id)));
                          } catch (e) {
                            print(e);
                            loading = false;
                          }
                        }
                      },
                      child: const Text("Yes"))
                ]));
  }

  void updateCurrentCity(String searchCity) {
    setState(() {
      // trucklocation.text = searchCity;
    });
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
