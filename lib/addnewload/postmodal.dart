// ignore_for_file: unnecessary_this, prefer_collection_literals, unnecessary_new

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PostModal {
  String? destinationlocation;
  String? sourcelocation;

  String? expectedprice;
  String? remarks;
  String? id;
  String? postexpiretime;
  String? usernumber;
  String? loadposttime;
  String? material;
  String? ownerId;
  String? paymentmode;
  String? priceunit;
  String? postid;
  String? dp;
  String? loadstatus;
  String? quantity;

  String? loadorderstatus;
  PostModal({
    required this.destinationlocation,
    required this.sourcelocation,
    required this.expectedprice,
    required this.postexpiretime,
    required this.loadposttime,
    required this.material,
    required this.id,
    required this.quantity,
    required this.loadorderstatus,
    required this.ownerId,
    required this.dp,
    required this.remarks,
    required this.paymentmode,
    required this.priceunit,
    required this.loadstatus,
    required this.postid,
  });

  PostModal.fromJson(Map<String, dynamic> json) {
    destinationlocation = json['destinationlocation'];
    sourcelocation = json['sourcelocation'];
    expectedprice = json['expectedprice'];
    id = json['id'];
    loadstatus = json['loadstatus'];
    dp = json['dp'];
    loadorderstatus = json['loadorderstatus'];
    remarks = json['remarks'];
    postexpiretime = json['postexpiretime'];
    usernumber = json['usernumber'];
    loadposttime = json['loadposttime'];
    material = json['material'];
    ownerId = json['ownerId'];
    paymentmode = json['paymentmode'];
    priceunit = json['priceunit'];
    postid = json['postid'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['destinationlocation'] = destinationlocation;
    data['sourcelocation'] = sourcelocation;
    data['expectedprice'] = expectedprice;
    data['id'] = id;
    data['dp'] = dp;
    data['loadorderstatus'] = loadorderstatus;
    data['remarks'] = remarks;
    data['postexpiretime'] = postexpiretime;
    data['loadstatus'] = loadstatus;
    data['usernumber'] = usernumber;
    data['loadposttime'] = loadposttime;
    data['material'] = material;
    data['ownerId'] = ownerId;
    data['paymentmode'] = paymentmode;
    data['priceunit'] = priceunit;
    data['postid'] = postid;
    data['quantity'] = quantity;
    return data;
  }
}
