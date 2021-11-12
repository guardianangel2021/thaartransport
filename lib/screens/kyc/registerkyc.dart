import 'package:flutter/material.dart';
import 'package:thaartransport/screens/homepage.dart';
import 'package:thaartransport/screens/kyc/accountkyc/accountkyc.dart';
import 'package:thaartransport/services/userservice.dart';
import 'package:thaartransport/utils/constants.dart';
import 'package:thaartransport/utils/firebase.dart';

class RegisterKYC extends StatefulWidget {
  const RegisterKYC({Key? key}) : super(key: key);

  @override
  _RegisterKYCState createState() => _RegisterKYCState();
}

class _RegisterKYCState extends State<RegisterKYC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.yellow, width: 2),
                        borderRadius: BorderRadius.circular(30)),
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.sd_card_alert_sharp,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Want to restart KYC?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Just a few more steps to get verfiied by Thaar",
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            FlatButton(
                color: Constants.btnBG,
                textColor: Colors.white,
                onPressed: () async {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AccountKyc()));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text("RESTART KYC"),
                )),
            const SizedBox(
              height: 5,
            ),
            FlatButton(
                color: Constants.btnBG,
                textColor: Colors.white,
                onPressed: () async {
                  // await usersRef
                  //     .doc(UserService().currentUid())
                  //     .update({"userkyc": "Nonverified"});

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                selectedIndex: 0,
                              )));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: const Text("CONTINUE LATER"),
                )),
          ],
        ),
      ),
    );
  }
}
