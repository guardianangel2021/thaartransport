import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thaartransport/utils/constants.dart';
import 'package:thaartransport/utils/controllers.dart';
import 'package:jiffy/jiffy.dart';
import 'package:timeago/timeago.dart' as timeago;

class ExpireTime extends StatefulWidget {
  const ExpireTime({Key? key}) : super(key: key);

  @override
  _ExpireTimeState createState() => _ExpireTimeState();
}

class _ExpireTimeState extends State<ExpireTime> {
  static final values = <String>[
    '6 Hours  By ${Jiffy(DateTime.now().add(Duration(hours: 6))).yMMMMEEEEdjm}',
    // '12 Hours By ${Jiffy(DateTime.now().add(Duration(hours: 12))).yMMMMEEEEdjm} '
  ];

  String selectedValue = '';
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.close),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Load closes in"),
              SizedBox(
                height: 5,
              ),
              Text(
                "Choose your period",
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
        body: Column(
          children: [
            radioButton(),
            Spacer(),
            Padding(
                padding: EdgeInsets.all(15),
                child: RaisedButton(
                  color: Constants.btnBG,
                  textColor: Constants.white,
                  onPressed: () {
                    Navigator.pop(context);
                    expireLoad.text = val.toString();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 45,
                    width: width,
                    child: Text('Next'),
                  ),
                ))
          ],
        ));
  }

  bool _value = false;
  String val = '';

  Widget radioButton() {
    return Column(
      children: [
        RadioListTile(
            value:
                '6 hours ${Jiffy(DateTime.now().add(Duration(hours: 6))).yMMMMEEEEdjm}',
            title: Text("6 Hours"),
            subtitle: Text(
                Jiffy(DateTime.now().add(Duration(hours: 6))).yMMMMEEEEdjm),
            groupValue: val,
            onChanged: (value) {
              setState(() {
                val = value as String;
              });
            }),
        RadioListTile(
            value:
                '12 hours ${Jiffy(DateTime.now().add(Duration(hours: 12))).yMMMMEEEEdjm}',
            title: Text("12 Hours"),
            subtitle: Text(
                Jiffy(DateTime.now().add(Duration(hours: 12))).yMMMMEEEEdjm),
            groupValue: val,
            onChanged: (value) {
              setState(() {
                val = value as String;
              });
            })
      ],
    );
  }
}
