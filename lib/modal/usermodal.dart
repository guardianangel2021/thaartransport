// ignore_for_file: unnecessary_this, prefer_collection_literals, unnecessary_new

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? location;

  String? companyname;

  String? country;
  String? id;
  String? photourl;
  bool? isOnline;
  String? role;
  String? state;
  String? username;
  String? usernumber;
  CompanyDetails? companybio;
  UserModel(
      {this.location,
      this.companyname,
      this.country,
      this.id,
      this.photourl,
      this.isOnline,
      this.role,
      required this.companybio,
      this.state,
      this.username,
      this.usernumber});

  UserModel.fromJson(Map<String, dynamic> json) {
    location = json['location'] as String;
    companyname = json['companyname'] as String;
    country = json['country'] as String;
    id = json['id'] as String;
    companybio = (json['companybio'] != null
        ? CompanyDetails.fromJson(json['companybio'])
        : null);
    photourl = json['photourl'] as String;
    isOnline = json['isOnline'] as bool;
    role = json['role'] as String;
    state = json['state'] as String;
    username = json['username'] as String;
    usernumber = json['usernumber'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['location'] = this.location;
    data['companyname'] = this.companyname;
    data['country'] = this.country;
    data['id'] = this.id;
    data['photourl'] = this.photourl;
    data['isOnline'] = this.isOnline;
    data['role'] = this.role;
    if (this.companybio != null) {
      data['companybio'] = this.companybio!.toJson();
    }
    data['state'] = this.state;
    data['username'] = this.username;
    data['usernumber'] = this.usernumber;

    return data;
  }
}

class CompanyDetails {
  String? bio;
  String? esbmyear;

  CompanyDetails({required this.bio, required this.esbmyear});

  CompanyDetails.fromJson(Map<String, dynamic> json) {
    bio = json['bio'];
    esbmyear = json['esbmyear'];
  }
  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['bio'] = this.bio;
    data['esbmyear'] = this.esbmyear;

    return data;
  }
}
