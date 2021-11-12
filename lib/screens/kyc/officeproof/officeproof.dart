import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thaartransport/screens/homepage.dart';
import 'package:thaartransport/screens/kyc/officeproof/images.dart';
import 'package:thaartransport/screens/kyc/pannumber/kycrectangelimage.dart';
import 'package:thaartransport/services/userservice.dart';
import 'package:thaartransport/utils/constants.dart';
import 'package:thaartransport/utils/firebase.dart';

import '../registerkyc.dart';

class OfficeProof extends StatefulWidget {
  const OfficeProof({Key? key}) : super(key: key);

  @override
  _OfficeProofState createState() => _OfficeProofState();
}

class _OfficeProofState extends State<OfficeProof> {
  static final List<String> items = <String>[
    "Select an ID proof",
    "GSTIN Certificate",
    "Shop & Establishment Certificate",
    "Udyog Aadhaar",
    "Signage Board",
    "Visiting Card",
    "Trade License"
  ];
  String value = items.first;
  TextEditingController businessName = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String imgUrl1 = '';
  String imgUrl2 = '';
  String imgUrl3 = '';
  String imgUrl4 = '';
  bool validate = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RegisterKYC()));
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Your Documents"),
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 10,
                  right: 10,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Business Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: businessName,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Business Name",
                          labelText: "Business Name",
                          labelStyle: TextStyle(color: Constants.labelcolor),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            width: 2.5,
                            color: Constants.textfieldborder,
                          )),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Constants.textfieldborder)),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Business Name should not be Empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Office Address proof",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      buildDropdown(),
                      const SizedBox(
                        height: 10,
                      ),
                      ImageProof(),
                      const SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                )),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterFloat,
          floatingActionButton: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: FloatingActionButton.extended(
                  backgroundColor: Constants.btnBG,
                  shape: Border(),
                  label: Container(
                    alignment: Alignment.center,
                    width: width,
                    child: const Text("SUBMIT",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                  onPressed: () async {
                    FormState? form = _formKey.currentState;
                    form!.save();
                    if (!form.validate()) {
                      validate = true;
                    } else if (imgUrl1.isEmpty &&
                        imgUrl2.isEmpty &&
                        imgUrl3.isEmpty &&
                        imgUrl4.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please select at least one ID Proof");
                    } else {
                      await usersRef.doc(UserService().currentUid()).update({
                        "OfficeKyc": {
                          "businessname": businessName.text,
                          "officeimg1": imgUrl1,
                          "officeimg2": imgUrl2,
                          "officeimg3": imgUrl3,
                          "officeimg4": imgUrl4
                        },
                      }).catchError((e) {
                        print(e);
                      });
                      await usersRef
                          .doc(UserService().currentUid())
                          .update({"userkycstatus": "Pending"}).catchError((e) {
                        print(e);
                      });
                      await CoolAlert.show(
                          context: context,
                          type: CoolAlertType.loading,
                          text: 'KYC Successfully',
                          lottieAsset: 'assets/782-check-mark-success.json',
                          autoCloseDuration: Duration(seconds: 2),
                          animType: CoolAlertAnimType.slideInUp,
                          title: 'KYC Successfully');

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                    selectedIndex: 0,
                                  )));
                    }
                  })),
        ));
  }

  Widget buildDropdown() {
    return Container(
        // width: 200,
        height: 40,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          value: value,
          // isDense: true,
          items: items
              .map((item) => DropdownMenuItem<String>(
                    enabled: true,
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 17),
                    ),
                    value: item,
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              this.value = value!;
            });
          },
        )));
  }

  Widget ImageProof() {
    return Column(
      children: [
        OfficeImage(onFileChanged: (imgUrl) {
          setState(() {
            this.imgUrl1 = imgUrl;
          });
        }),
        const SizedBox(
          height: 10,
        ),
        OfficeImage(onFileChanged: (imgUrl) {
          setState(() {
            this.imgUrl2 = imgUrl;
          });
        }),
        const SizedBox(
          height: 10,
        ),
        OfficeImage(onFileChanged: (imgUrl) {
          setState(() {
            this.imgUrl3 = imgUrl;
          });
        }),
        const SizedBox(
          height: 10,
        ),
        OfficeImage(onFileChanged: (imgUrl) {
          setState(() {
            this.imgUrl4 = imgUrl;
          });
        }),
      ],
    );
  }
}
