// ignore_for_file: unnecessary_this, prefer_collection_literals, unnecessary_new

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class TruckModal {
  String? capacity;
  String? sourcelocation;
  String? id;
  String? lorrynumber;
  String? truckposttime;
  String? ownerId;
  String? truckpostid;
  String? truckloadstatus;
  String? usernumber;
  TruckModal({
    this.capacity,
    this.sourcelocation,
    this.id,
    this.lorrynumber,
    this.truckposttime,
    this.ownerId,
    this.truckpostid,
    this.truckloadstatus,
    this.usernumber,
  });

  TruckModal.fromJson(Map<String, dynamic> json) {
    capacity = json['capacity'];
    sourcelocation = json['sourcelocation'];
    id = json['id'];
    truckloadstatus = json['truckloadstatus'];
    truckposttime = json['truckposttime'];
    ownerId = json['ownerId'];
    truckpostid = json['truckpostid'];
    usernumber = json['usernumber'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['capacity'] = capacity;
    data['sourcelocation'] = sourcelocation;
    data['id'] = id;
    data['truckloadstatus'] = truckloadstatus;
    data['truckposttime'] = truckposttime;
    data['ownerId'] = ownerId;
    data['truckpostid'] = truckpostid;
    data['usernumber'] = usernumber;
    return data;
  }
}
