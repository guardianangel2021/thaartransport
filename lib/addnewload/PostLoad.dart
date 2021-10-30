// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaartransport/Utils/constants.dart';
import 'package:thaartransport/Utils/firebase.dart';
import 'package:thaartransport/addnewload/destination.dart';
import 'package:thaartransport/addnewload/expiretime.dart';
import 'package:thaartransport/addnewload/orderdata.dart';
import 'package:thaartransport/addnewload/orderpostconfirmed.dart';
import 'package:thaartransport/addnewload/post_load_modal.dart';
import 'package:thaartransport/addnewload/source.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:thaartransport/modal/usermodal.dart';
import 'package:thaartransport/screens/homepage.dart';
import 'package:thaartransport/services/uploadload.dart';
import 'package:thaartransport/utils/controllers.dart';

class PostLoad extends StatefulWidget {
  const PostLoad({Key? key}) : super(key: key);

  @override
  _PostLoadState createState() => _PostLoadState();
}

class _PostLoadState extends State<PostLoad> {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool validate = false;
  bool loading = false;
  String _selectedItem = '';
  String group = '';
  void initState() {
    getSource().then(updateSource);
    getDes().then(updateDestination);
    print(multiplyVal.toString());
  }

  // String addVal = "";
  int multiplyVal = 0;

  bool _value = false;
  String val = '';

  void dispose() {
    quantity.clear();
  }

  String timeCheck = '';
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBar(),
      body: WillPopScope(
          onWillPop: () async {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
            source.clear();
            destination.clear();
            material.clear();
            quantity.clear();
            priceUnit.clear();
            expectedPrice.clear();
            paymentMode.clear();
            expireLoad.clear();

            return true;
          },
          child: Container(
              child: SingleChildScrollView(
            reverse: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.04,
                ),
                documentField(),
                SizedBox(
                  height: height * 0.09,
                ),
              ],
            ),
          ))),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: FloatingActionButton.extended(
              backgroundColor: Constants.btnBG,
              shape: Border(),
              label: Container(
                  alignment: Alignment.center,
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Next",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                      Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Colors.white,
                      ),
                    ],
                  )),
              onPressed: () async {
                FormState? form = _formKey.currentState;
                form!.save();
                if (!form.validate()) {
                  validate = true;

                  showInSnackBar(
                      'Please fix the errors in red before submitting.',
                      context);
                } else {
                  try {
                    DocumentSnapshot doc =
                        await usersRef.doc(firebaseAuth.currentUser!.uid).get();
                    var user =
                        UserModel.fromJson(doc.data() as Map<String, dynamic>);
                    var ref = postRef.doc();
                    loading = true;
                    ref.set({
                      "id": ref.id,
                      "postid": ref.id,
                      "ownerId": user.id,
                      "dp": user.photourl,
                      "expectedprice": expectedPrice.text,
                      "postexpiretime": expireLoad.text,
                      "paymentmode": paymentMode.text,
                      "quantity": quantity.text,
                      "destinationlocation": destination.text,
                      "priceunit": priceUnit.text,
                      "material": material.text,
                      "sourcelocation": source.text,
                      "loadposttime": Jiffy(DateTime.now()).yMMMMEEEEdjm,
                      "usernumber": user.usernumber,
                      "loadstatus": 'Active',
                      'loadorderstatus': 'Active',
                    }).catchError((e) {
                      print(e);
                    });

                    loading = false;
                    await CoolAlert.show(
                        context: context,
                        type: CoolAlertType.loading,
                        text: 'Load Posted Successfully',
                        lottieAsset: 'assets/782-check-mark-success.json',
                        autoCloseDuration: Duration(seconds: 2),
                        animType: CoolAlertAnimType.slideInUp,
                        title: 'Load Posted Successfully');

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderPostConfirmed(ref.id)));
                  } catch (e) {
                    print(e);
                    loading = false;

                    showInSnackBar('Uploaded successfully!', context);
                  }
                }
              })),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Constants.btntextactive,
      title: const Text("Post Load"),
      centerTitle: false,
    );
  }

  Widget heading() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
        padding: const EdgeInsets.only(left: 10),
        color: Colors.grey[200],
        height: height * 0.05,
        child: Row(
          children: [
            const Icon(
              Icons.ac_unit,
              size: 18,
            ),
            SizedBox(
              width: width * 0.03,
            ),
            const Text(
              "Load Details",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
            ),
          ],
        ));
  }

  Widget documentField() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  textInputAction: TextInputAction.next,
                  initialValue: source.text.toString(),
                  // controller: controller1,
                  readOnly: true,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SourceLocation()));
                  },

                  cursorColor: Constants.cursorColor,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    isDense: true,
                    hintText: 'Source Location',
                    labelText: 'Source Location',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 2.5,
                      color: Constants.textfieldborder,
                    )),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Constants.textfieldborder)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Source, Eg. Mumbai';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  initialValue: destination.text.toString(),
                  // controller: controller2,
                  readOnly: true,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Destination()));
                  },

                  cursorColor: Constants.cursorColor,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    isDense: true,
                    hintText: "Destination",
                    labelText: 'Destination',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Constants.textfieldborder)),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Constants.textfieldborder)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Destination, Eg. Bangalore';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: material,
                  cursorColor: Constants.cursorColor,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      isDense: true,
                      hintText: "Material",
                      labelText: 'Material',
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Constants.textfieldborder)),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Constants.textfieldborder),
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter material, Eg. Steel';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                TextFormField(
                  controller: quantity,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      isDense: true,
                      labelText: "Quantity",
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Constants.textfieldborder)),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Constants.textfieldborder))),
                  validator: (value) {
                    if (value!.isEmpty || value == '') {
                      return 'Please Enter Quantity';
                    } else if (int.parse(value) > 100) {
                      return 'Please Enter Quantity under 100';
                    }
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: priceUnit,
                  readOnly: true,
                  cursorColor: Constants.cursorColor,
                  onTap: () {
                    _onButtonPressed();
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    isDense: true,
                    hintText: "price unit",
                    labelText: 'Price Unit',
                    labelStyle: TextStyle(color: Colors.black),
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_right_outlined,
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Constants.textfieldborder)),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Constants.textfieldborder)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please select any one';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                TextFormField(
                  controller: expectedPrice,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      isDense: true,
                      labelText: "Expected Price",
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Constants.textfieldborder)),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Constants.textfieldborder))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter the price';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                TextFormField(
                  onTap: _onPaymentMode,
                  readOnly: true,
                  controller: paymentMode,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      isDense: true,
                      labelText: "Payment Modes",
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Colors.black,
                        size: 15,
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Constants.textfieldborder)),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Constants.textfieldborder))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please select any one';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                TextFormField(
                  controller: expireLoad,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ExpireTime()));
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      isDense: true,
                      labelText: "Load expires in",
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Constants.textfieldborder)),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Constants.textfieldborder))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please select any one';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      timeCheck = expireLoad.text;
                    });
                  },
                  onSaved: (val) {
                    setState(() {
                      timeCheck = expireLoad.text;
                    });
                  },
                ),

                // Align(
                //     alignment: Alignment.centerRight,
                //     child: Container(
                //       width: 100,
                //       // height: 50,
                //       decoration: BoxDecoration(
                //           border: Border.all(color: Constants.alert, width: 3)),
                //       alignment: Alignment.centerRight,
                //       child: TextFormField(
                //         controller: thirdcontroller,
                //         readOnly: true,
                //         decoration: InputDecoration(
                //           helperText: 'Total Price',
                //           border: InputBorder.none,
                //         ),
                //       ),
                //     )),
              ],
            )));
  }

  // void caluclate() {
  //   if (quantity.text.trim().isNotEmpty &&
  //       priceController.text.trim().isNotEmpty) {
  //     final firstvalue = double.parse(quantity.text);
  //     final secondvalue = double.parse(priceController.text);
  //     thirdcontroller.text = (firstvalue * secondvalue).toString();
  //     multiplyVal = (firstvalue * secondvalue).toInt();
  //   } else {
  //     thirdcontroller.clear();
  //   }
  // }

  // for price unit bottom sheet value

  _onButtonPressed() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 250,
            child: Container(
              child: _buildBottomNavigationMenu(),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }

  Column _buildBottomNavigationMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(
          height: 5,
        ),
        Center(
            child: Container(
                height: 3.0, width: 40.0, color: const Color(0xFF32335C))),
        const SizedBox(
          height: 30,
        ),
        Container(
            margin: EdgeInsets.only(left: 15),
            child: const Text("Select your price Unit",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ))),
        RadioListTile(
          title: Text("Fixed price"),
          value: 'fixed price',
          groupValue: group,
          onChanged: (value) {
            group = value as String;
            Navigator.pop(context);
            priceUnit.text = value;
          },
        ),
        RadioListTile(
          title: Text("Tonne"),
          value: 'tonne',
          groupValue: group,
          onChanged: (value) {
            group = value as String;
            priceUnit.text = value;
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  _onPaymentMode() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                color: Color(0xFF737373),
                height: 300,
                child: Container(
                  child: _buildSheet(),
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                ),
              ));
        });
  }

  Widget _buildSheet() {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            height: 5,
          ),
          Center(
              child: Container(
                  height: 3.0, width: 40.0, color: const Color(0xFF32335C))),
          const SizedBox(
            height: 30,
          ),
          Container(
              margin: EdgeInsets.only(left: 15),
              child: const Text("Select payment mode",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ))),
          RadioListTile(
            title: Text("Advance pay"),
            value: "Advance pay",
            selected: _value,
            groupValue: val,
            toggleable: _value,
            onChanged: (value) {
              setState(() {
                val = value as String;
                if (_value == false) {
                  _value = true;
                } else {
                  _value = false;
                }
              });

              print(value.toString());
              print(val.toString());
              // Navigator.pop(context);
            },
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              const Text('Enter Advance %(Optional)'),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                  child: TextFormField(
                controller: advancePay,
                readOnly: _value ? false : true,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    isDense: true,
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Constants.textfieldborder)),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Constants.textfieldborder))),
              )),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          RadioListTile(
            title: Text("ToPay"),
            value: "ToPay",
            groupValue: val,
            selected: _value,
            toggleable: _value,
            onChanged: (value) {
              setState(() {
                val = value as String;
                if (_value == false) {
                  _value = true;
                } else {
                  _value = false;
                }
              });
              print(value.toString());
              print(val.toString());
              // Navigator.pop(context);
            },
          ),
          RaisedButton(
              color: Constants.btnBG,
              textColor: Constants.white,
              onPressed: () {
                Navigator.pop(context);
                if (val == "Advance pay") {
                  paymentMode.text = advancePay.text + "% " + val.toString();
                } else {
                  paymentMode.text = val.toString();
                }
              },
              child: Container(
                height: 45,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Next",
                ),
              ))
        ],
      );
    });
  }
  // for paymentoption

  // To get the source Address
  void updateSource(String name1) {
    setState(() {
      controller1.text = name1;
    });
  }

// To get the Destination Address
  void updateDestination(String des) {
    setState(() {
      controller2.text = des;
    });
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

// To pass the all controller value on nextPage(PaymentDetails)

}
