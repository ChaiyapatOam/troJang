import 'dart:math';
import 'package:flutter/material.dart';
import 'package:trojang/app_contact.dart';

class ContactAvatar extends StatelessWidget {
  ContactAvatar(this.contact, this.size);
  final AppContact contact;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        // decoration: BoxDecoration(
        //     shape: BoxShape.circle, gradient: getColorGradient(contact.color)),
        child: (contact.info.avatar != null && contact.info.avatar.length > 0)
            ? CircleAvatar(
                backgroundImage: MemoryImage(contact.info.avatar),
              )
            // ignore: prefer_const_constructors
            : CircleAvatar(
                backgroundImage: const AssetImage("assets/avatar.png"),
                backgroundColor: Colors.transparent,
              ));
  }
}
