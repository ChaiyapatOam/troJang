// ignore_for_file: prefer_const_constructors

import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trojang/app_contact.dart';
import 'package:trojang/contact_detail.dart';
import 'package:trojang/contact_list.dart';
import 'package:trojang/db/contact_database.dart';
import 'package:trojang/model/contact_class.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(
        title: 'Trojang',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String? name;
  final String? image;
  final int? phonenumber;
  const MyHomePage({
    Key? key,
    required this.title,
    this.name,
    this.image,
    this.phonenumber,
  }) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<MyContact> mycontact;
  final ContactPicker _contactPicker = new ContactPicker();
  late Contact _contact;
  var contactimg = 'assets/avatar.png';
  String _contactimg = 'assets/avatar.png';
  late List<MyContact> myContact;
  bool isLoading = false;
  // ignore: prefer_final_fields
  List<String> _ListItem = [
    'assets/004.png',
    "assets/005.png",
    "assets/006.png",
    "assets/143.png",
    "assets/007.png",
    "assets/017.png",
  ];
  @override
  void initState() {
    super.initState();
    getPermissions();
    refreshContact();
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      //getAllContacts();
    }
  }

  @override
  void dispose() {
    ContactDatabase.instance.close();

    super.dispose();
  }

  Future refreshContact() async {
    setState(() => isLoading = true);

    this.myContact = await ContactDatabase.instance.readAllContacts();

    setState(() => isLoading = false);
  }

  showSelectImage() {
    Widget imagebutton = Container(
      width: 350,
      height: 350,
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.transparent,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 50,
              backgroundImage: AssetImage(_contactimg),
            ),
          ),
          Expanded(
              child: GridView.count(
            //padding: EdgeInsets.all(50),
            crossAxisCount: 3,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            children: _ListItem.map((item) => Card(
                  color: Colors.transparent,
                  elevation: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 50,
                    child: IconButton(
                      icon: Image.asset(item),
                      iconSize: 50,
                      onPressed: () {
                        setState(() {
                          _contactimg = item.toString();
                        });
                      },
                    ),
                  ),
                )).toList(),
          )),
          //Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
          ElevatedButton(onPressed: () {}, child: Text('Pick from gallery'))
        ],
      ),
    );
    Widget OKButton = TextButton(
        onPressed: () async {
          setState(() {
            contactimg = _contactimg;
          });
          final addmycontact = MyContact(
            name: _contact.fullName,
            image: contactimg,
            phonenumber: _contact.phoneNumber.number,
          );

          await ContactDatabase.instance.create(addmycontact);
          refreshContact();
          Navigator.of(context).pop();
        },
        child: Text(
          "OK",
          style: TextStyle(),
        ));
    Widget Cancel = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("Cancel"));
    AlertDialog alert = AlertDialog(
      title: Text("Please Select Image"),
    );
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Container(
                width: 350,
                height: 350,
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.transparent,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 50,
                        backgroundImage: AssetImage(_contactimg),
                      ),
                    ),
                    Expanded(
                        child: GridView.count(
                      //padding: EdgeInsets.all(50),
                      crossAxisCount: 3,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      children: _ListItem.map((item) => Card(
                            color: Colors.transparent,
                            elevation: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 50,
                              child: IconButton(
                                icon: Image.asset(item),
                                iconSize: 50,
                                onPressed: () {
                                  setState(() {
                                    _contactimg = item.toString();
                                  });
                                },
                              ),
                            ),
                          )).toList(),
                    )),
                    //Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                    ElevatedButton(
                        onPressed: () {}, child: Text('Pick from gallery'))
                  ],
                ),
              ),
              actions: [Cancel, OKButton],
            );
          });
        });
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return alert;
    //     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () async {
                refreshContact();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [buildContact()],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Contact contact = await _contactPicker.selectContact();
          setState(() {
            _contact = contact;
          });
          print(_contact);
          if (_contact.phoneNumber.number.isNotEmpty) {
            await showSelectImage();
          }

          //refreshContact();
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ), //
    );
  }

//-----------------------------------Contact-------------------------------------
  Widget buildContact() => Expanded(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, childAspectRatio: 0.75),
          itemCount: myContact.length,
          itemBuilder: (context, index) {
            MyContact mycontacts = myContact[index];
            showDeleteConfirmation() {
              Widget cancelButton = TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );
              Widget deleteButton = TextButton(
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () async {
                  await ContactDatabase.instance.delete(mycontacts.id!);
                  refreshContact();
                  Navigator.of(context).pop();
                },
              );
              AlertDialog alert = AlertDialog(
                title: Text('Delete contact?'),
                content: Text('Are you sure you want to delete this contact?'),
                actions: <Widget>[cancelButton, deleteButton],
              );

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  });
            }

            return Card(
                elevation: 0,
                color: Colors.transparent,
                child: Hero(
                  tag: Text(mycontacts.name),
                  child: Material(
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () {
                        FlutterPhoneDirectCaller.callNumber(
                            mycontacts.phonenumber);
                      },
                      onLongPress: () {
                        showDeleteConfirmation();
                      },
                      child: GridTile(
                        // ignore: prefer_const_constructors
                        child: Container(
                          width: 50,
                          height: 50,
                          // ignore: prefer_const_constructors
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          // ignore: prefer_const_constructors
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage(mycontacts.image),
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

//   Future addContact() async {
//     final addmycontact = MyContact(
//       name: _contact.fullName,
//       image: contactimg,
//       phonenumber: _contact.phoneNumber.number,
//     );

//     await ContactDatabase.instance.create(addmycontact);
//   }
}
