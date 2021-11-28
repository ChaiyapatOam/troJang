import 'package:flutter/material.dart';
import 'package:trojang/db/contact_database.dart';
import 'package:trojang/model/contact_class.dart';

class ContactDetail extends StatefulWidget {
  final int ID;
  const ContactDetail({Key? key, required this.ID}) : super(key: key);

  @override
  _ContactDetailState createState() => _ContactDetailState();
}

class _ContactDetailState extends State<ContactDetail> {
  late MyContact contact;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshContact();
  }

  Future refreshContact() async {
    setState(() => isLoading = true);

    this.contact = await ContactDatabase.instance.readContact(widget.ID);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        actions: [editButton(), deleteButton()],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(12),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(
                    contact.name,
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    contact.phonenumber,
                    style: const TextStyle(color: Colors.red, fontSize: 30),
                  )
                ],
              ),
            ));

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        //await Navigator.of(context).push(MaterialPageRoute(
        //builder: (context) => AddEditNotePage(note: note),
        // ));

        refreshContact();
      });

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await ContactDatabase.instance.delete(widget.ID);
          // refreshContact();
          Navigator.of(context).pop();
        },
      );
}








// class ContactPick extends StatelessWidget {
//   final String? name;--no-sound-null-safety
//   final String? image;
//   final int? phonenumber;
//   const ContactPick(
//       {Key? key, this.name = '', this.image = '', this.phonenumber = 0})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             //dfgdfgdfgdf
//           },
//         ),
//         actions: [],
//         title: Text("Select"),
//       ),
//     );
//   }
// }
