import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaartransport/screens/kyc/accountkyc/UserRoundImage.dart';
import 'package:thaartransport/screens/kyc/addressproof.dart';
import 'package:thaartransport/screens/kyc/pannumber/kycdocuments.dart';
import 'package:thaartransport/services/userservice.dart';
import 'package:thaartransport/utils/constants.dart';
import 'package:thaartransport/utils/firebase.dart';

class AccountKyc extends StatefulWidget {
  const AccountKyc({Key? key}) : super(key: key);

  @override
  _AccountKycState createState() => _AccountKycState();
}

class _AccountKycState extends State<AccountKyc> {
  bool value = false;
  bool validate = false;
  TextEditingController name = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String imgUrl1 = '';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: FloatingActionButton.extended(
              backgroundColor: value ? Constants.btnBG : Colors.grey[300],
              shape: Border(),
              label: Container(
                alignment: Alignment.center,
                width: width,
                child: const Text("Verify now",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              onPressed: () async {
                FormState? form = _formKey.currentState;
                form!.save();
                if (!form.validate()) {
                  validate = true;
                } else if (value == false) {
                  Fluttertoast.showToast(msg: "Please select the checkbox");
                } else if (imgUrl1.isEmpty) {
                  Fluttertoast.showToast(msg: 'Please select the image');
                } else {
                  await usersRef.doc(UserService().currentUid()).update({
                    "UserKyc": {
                      'kycname': name.text,
                      "selfi": imgUrl1,
                    },
                  });

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => KycDocuments()));
                }
              })),
      appBar: appBar(),
      body: _body(),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text("Thaar account KYC"),
    );
  }

  Widget _body() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    height: 45,
                    color: Colors.grey[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Why am I asked to verify my profile?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                            'So that we know who is the user of the THAAR App.')
                      ],
                    )),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                          labelText: "Your Name",
                          labelStyle: TextStyle(color: Constants.labelcolor),
                          hintText: "Enter Your Full Name",
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Constants.textfieldborder,
                                  width: 2.5)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2.5,
                                  color: Constants.textfieldborder))),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please Enter Your Name';
                        }
                        return null;
                      },
                    )),
                const SizedBox(
                  height: 40,
                ),
                UserRoundImage(onFileChanged: (imgUrl) {
                  setState(() {
                    this.imgUrl1 = imgUrl;
                  });
                }),
                SizedBox(
                  height: height * 0.2,
                ),
                Row(
                  children: [
                    Checkbox(
                        value: value,
                        onChanged: (val) {
                          setState(() {
                            value = val!;
                          });
                        }),
                    const Text("Terms and condition")
                  ],
                ),
              ],
            )));
  }

  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('stringValue', name.text);
  }
}
