import 'package:flutter/material.dart';

final String tableContact = 'contact';

class ContactFields {
  static final List<String> values = [id, name, image, phonenumber];
  static final String id = '_id';
  static final String name = 'name';
  static final String image = 'image';
  static final String phonenumber = 'phonenumber';
}

class MyContact {
  final int? id;
  final String name;
  final String image;
  final String phonenumber;

  const MyContact(
      {this.id,
      required this.name,
      required this.image,
      required this.phonenumber});

  MyContact copy({
    int? id,
    String? name,
    String? image,
    String? phonenumber,
  }) =>
      MyContact(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        phonenumber: phonenumber ?? this.phonenumber,
      );

  static MyContact fromJson(Map<String, Object?> json) => MyContact(
        id: json[ContactFields.id] as int?,
        name: json[ContactFields.name] as String,
        image: json[ContactFields.image] as String,
        phonenumber: json[ContactFields.phonenumber] as String,
      );

  Map<String, Object?> toJson() => {
        ContactFields.id: id,
        ContactFields.name: name,
        ContactFields.image: image,
        ContactFields.phonenumber: phonenumber,
      };
}
