// ignore_for_file: unnecessary_this, prefer_collection_literals, unnecessary_new

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class BidModal {
  String? bidresponse;
  String? bidtime;
  String? biduserid;
  String? rate;
  String? id;
  String? loadid;
  String? remarks;
  String? btnvalue;
  String? negotiateprice;
  BidModal(
      {required this.bidresponse,
      required this.bidtime,
      required this.biduserid,
      required this.rate,
      required this.btnvalue,
      required this.negotiateprice,
      required this.loadid,
      required this.id,
      required this.remarks});

  BidModal.fromJson(Map<String, dynamic> json) {
    bidresponse = json['bidresponse'];
    bidtime = json['bidtime'];
    biduserid = json['biduserid'];
    rate = json['rate'];
    loadid = json['loadid'];
    btnvalue = json['btnvalue'];
    negotiateprice = json['negotiateprice'];
    id = json['id'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['bidresponse'] = bidresponse;
    data['bidtime'] = bidtime;
    data['biduserid'] = biduserid;
    data['remakrs'] = remarks;
    data['negotiateprice'] = negotiateprice;
    data['btnvalue'] = btnvalue;
    data['loadid'] = loadid;
    data['rate'] = rate;
    data['id'] = id;

    return data;
  }
}
