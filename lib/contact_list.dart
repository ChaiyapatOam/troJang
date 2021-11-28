import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:trojang/contact_avatar.dart';
import 'package:trojang/contact_detail.dart';
import 'package:trojang/db/contact_database.dart';
import 'package:trojang/model/contact_class.dart';

class ContactsList extends StatefulWidget {
  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ContactPicker _contactPicker = new ContactPicker();
  late Contact _contact;

  bool isLoading = false;

  late List<MyContact> mycontact;

  @override
  void initState() {
    super.initState();

    refreshContact();
  }

  @override
  void dispose() {
    ContactDatabase.instance.close();

    super.dispose();
  }

  Future refreshContact() async {
    setState(() => isLoading = true);

    this.mycontact = await ContactDatabase.instance.readAllContacts();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, childAspectRatio: 0.75),
        itemCount: mycontact.length,
        itemBuilder: (context, index) {
          MyContact mycontacts = mycontact[index];

          return Card(
              elevation: 0,
              color: Colors.transparent,
              child: Hero(
                tag: Text(mycontacts.name),
                child: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: () {
                      //FlutterPhoneDirectCaller.callNumber(
                      //mycontacts.phonenumber);
                    },
                    onLongPress: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ContactDetail(ID: mycontacts.id!)));
                    },
                    child: GridTile(
                      // ignore: prefer_const_constructors
                      child: Container(
                        width: 50,
                        height: 50,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/avatar.png"),
                        ),
                      ),
                      footer: Container(
                        height: 20,
                        width: 5,
                        padding: const EdgeInsets.all(2),
                        color: Colors.transparent,
                        child: GridTileBar(
                          backgroundColor: Colors.transparent,
                          title: Text(
                            mycontacts.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
