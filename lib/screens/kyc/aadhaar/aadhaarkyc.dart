import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaartransport/screens/kyc/aadhaar/aadhaarimage.dart';
import 'package:thaartransport/screens/kyc/officeproof/officeproof.dart';
import 'package:thaartransport/services/userservice.dart';
import 'package:thaartransport/utils/constants.dart';
import 'package:thaartransport/utils/firebase.dart';
import 'package:thaartransport/utils/validations.dart';

import '../registerkyc.dart';

class AadhaarKyc extends StatefulWidget {
  const AadhaarKyc({Key? key}) : super(key: key);

  @override
  _AadhaarKycState createState() => _AadhaarKycState();
}

class _AadhaarKycState extends State<AadhaarKyc> {
  TextEditingController AadhaarNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String AadhaarFront = '';
  String AadhaarBack = '';
  bool validate = false;
  int charLength = 0;
  bool status = false;
  onChanged(String value) {
    charLength = value.length;
    if (charLength == 12) {
      status = true;
    } else {
      status = false;
    }
  }

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
                      top: 25, left: 10, right: 10, bottom: 5),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Enter aadhaar number",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        TextFormField(
                          controller: AadhaarNumber,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Aadhaar Number",
                            labelText: "Aadhaar number",
                            labelStyle: TextStyle(color: Constants.labelcolor),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              width: 2.5,
                              color: Constants.textfieldborder,
                            )),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Constants.textfieldborder)),
                          ),
                          validator: Validations.validateAadhaarNumber,
                          onChanged: onChanged,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          child: Column(
                            children: [
                              FrontImage(),
                              const SizedBox(
                                height: 30,
                              ),
                              BackImage()
                            ],
                          ),
                        )
                      ],
                    ),
                  ))),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterFloat,
          floatingActionButton: Visibility(
              visible: status,
              child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: FloatingActionButton.extended(
                      backgroundColor: Constants.btnBG,
                      shape: Border(),
                      label: Container(
                        alignment: Alignment.center,
                        width: width,
                        child: const Text("Next",
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                      onPressed: () async {
                        FormState? form = _formKey.currentState;
                        form!.save();
                        if (!form.validate()) {
                          validate = true;
                        } else if (AadhaarFront.isEmpty &&
                            AadhaarBack.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Please select the both image');
                        } else if (AadhaarFront.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Please select the fornt image');
                        } else if (AadhaarBack.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Please select the back image');
                        } else {
                          await usersRef
                              .doc(UserService().currentUid())
                              .update({
                            "AadhaarKyc": {
                              "aadhaarnumber": AadhaarNumber.text,
                              "aadhaarfrontimg": AadhaarFront,
                              "aadhaarbackimg": AadhaarBack,
                            },
                          }).catchError((e) {
                            print(e);
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OfficeProof()));
                        }
                      }))),
        ));
  }

  Widget FrontImage() {
    return InkWell(
        child: Column(
      children: [
        AadhaarImage(onFileChanged: (imgUrl) {
          setState(() {
            this.AadhaarFront = imgUrl;
          });
        }),
        const SizedBox(
          height: 10,
        ),
        const Text("Front image"),
      ],
    ));
  }

  Widget BackImage() {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          AadhaarImage(onFileChanged: (imgUrl) {
            setState(() {
              this.AadhaarBack = imgUrl;
            });
          }),
          const SizedBox(
            height: 10,
          ),
          const Text("Back image"),
        ],
      ),
    );
  }
}
