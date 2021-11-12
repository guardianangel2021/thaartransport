// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors, unused_field
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:thaartransport/Utils/constants.dart';
import 'package:thaartransport/addnewload/destination.dart';
import 'package:thaartransport/addnewload/expiretime.dart';
import 'package:thaartransport/addnewload/postmodal.dart';
import 'package:thaartransport/addnewload/source.dart';
import 'package:thaartransport/screens/homepage.dart';
import 'package:thaartransport/utils/controllers.dart';
import 'package:thaartransport/utils/firebase.dart';

class UpdateLoad extends StatefulWidget {
  PostModal posts;
  UpdateLoad({required this.posts});

  @override
  _UpdateLoadState createState() => _UpdateLoadState();
}

class _UpdateLoadState extends State<UpdateLoad> {
  TextEditingController updatePriceunit = TextEditingController();
  TextEditingController updatePaymentmode = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool validate = false;
  bool loading = false;
  String _selectedItem = '';
  String group = '';
  void initState() {
    // getSource().then(updateSource);
    // getDes().then(updateDestination);
    // print(multiplyVal.toString());
    updatePriceunit.text = widget.posts.priceunit.toString();
    updatePaymentmode.text = widget.posts.paymentmode.toString();
  }

  int multiplyVal = 0;

  bool _value = false;
  String val = '';

  void dispose() {
    quantity.clear();
  }

  String timeCheck = '';

  // for inital value
  String? updateSource;
  String? updateDestination;
  String? updateMaterial;
  String? updateQuantity;
  String? updateExpectedprice;
  String? updateloadexpire;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBar(),
      body: Container(
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
      )),
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
                    loading = true;
                    await postRef.doc(widget.posts.postid).update({
                      "expectedprice": updateExpectedprice,
                      "postexpiretime": updateloadexpire,
                      "paymentmode": updatePaymentmode.text,
                      "quantity": updateQuantity,
                      "destinationlocation": updateDestination,
                      "priceunit": updatePriceunit.text,
                      "material": updateMaterial,
                      "sourcelocation": updateSource,
                      "loadposttime": Jiffy(DateTime.now()).yMMMMEEEEdjm,
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
                            builder: (context) => HomePage(selectedIndex: 0)));
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
      title: const Text("Update Load"),
      centerTitle: false,
    );
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
                  initialValue: widget.posts.sourcelocation,
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
                  onChanged: (val) {
                    updateSource = val;
                  },
                  onSaved: (val) {
                    updateSource = val;
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  initialValue: widget.posts.destinationlocation,
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
                  onChanged: (val) {
                    updateDestination = val;
                  },
                  onSaved: (val) {
                    updateDestination = val;
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  initialValue: widget.posts.material,
                  // controller: material,
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
                  onChanged: (val) {
                    updateMaterial = val;
                  },
                  onSaved: (val) {
                    updateMaterial = val;
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                TextFormField(
                  initialValue: widget.posts.quantity,
                  // controller: quantity,
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
                  onChanged: (val) {
                    updateQuantity = val;
                  },
                  onSaved: (val) {
                    updateQuantity = val;
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  // initialValue: widget.posts.priceunit,
                  controller: updatePriceunit,
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
                  initialValue: widget.posts.expectedprice,
                  // controller: expectedPrice,
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
                  onChanged: (val) {
                    updateExpectedprice = val;
                  },
                  onSaved: (val) {
                    updateExpectedprice = val;
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                TextFormField(
                  onTap: _onPaymentMode,
                  readOnly: true,
                  // initialValue: widget.posts.paymentmode,
                  controller: updatePaymentmode,
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
                  initialValue: widget.posts.postexpiretime,
                  // controller: expireLoad,
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
                      updateloadexpire = val;
                    });
                  },
                  onSaved: (val) {
                    setState(() {
                      updateloadexpire = val;
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
            updatePriceunit.text = value;
          },
        ),
        RadioListTile(
          title: Text("Tonne"),
          value: 'tonne',
          groupValue: group,
          onChanged: (value) {
            group = value as String;
            updatePriceunit.text = value;
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
                ),
              ),
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
            },
          ),
          RaisedButton(
              color: Constants.btnBG,
              textColor: Constants.white,
              onPressed: () async {
                if (val == "Advance pay" && advancePay.text.isEmpty) {
                  Fluttertoast.showToast(
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.cyan,
                      msg: "Advance pay should not be blank");
                } else if (val == "Advance pay" && advancePay.text.isNotEmpty) {
                  updatePaymentmode.text =
                      "${advancePay.text}% " + val.toString();
                  Navigator.pop(context);
                } else {
                  updatePaymentmode.text = val.toString();
                  Navigator.pop(context);
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
  // void updateSource(String name1) {
  //   setState(() {
  //     controller1.text = name1;
  //   });
  // }

// To get the Destination Address
  // void updateDestination(String des) {
  //   setState(() {
  //     controller2.text = des;
  //   });
  // }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

// To pass the all controller value on nextPage(PaymentDetails)

}
