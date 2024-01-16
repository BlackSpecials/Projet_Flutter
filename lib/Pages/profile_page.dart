import 'package:chatappflutter/Components/text_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('Users');

  // Future<void> editField(String field) async {
  //   String field1 = field.toLowerCase();
  //   String newVal = "";
  //   await showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //             title: Text(
  //               "Edit " + field1,
  //               style: TextStyle(color: Colors.black),
  //             ),
  //             content: TextField(
  //               autofocus: true,
  //               style: TextStyle(color: Colors.black),
  //               decoration: InputDecoration(
  //                 hintText: "Enter new $field1",
  //                 hintStyle: TextStyle(color: Colors.grey),
  //               ),
  //               onChanged: (value) {
  //                 newVal = value;
  //               },
  //             ),
  //             actions: [
  //               TextButton(
  //                   onPressed: () => Navigator.of(context).pop(newVal),
  //                   child: Text('Save')),
  //               TextButton(
  //                   onPressed: () => Navigator.pop(context),
  //                   child: Text('Cancel')),
  //             ],
  //           ));
  //   if (newVal.trim().length > 0) {
  //     await usersCollection.doc(currentUser.email).update({field: newVal});
  //   }
  // }

  Future<void> editField(String field) async {
    String field1 = field.toLowerCase();
    String newVal = "";

    // Check if the field is 'password'
    if (field1 == 'password') {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Edit $field1",
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                style: TextStyle(color: Colors.black),
                obscureText: true, // To hide the entered password
                decoration: InputDecoration(
                  hintText: "Enter current password",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  newVal = value;
                },
              ),
              SizedBox(height: 10),
              TextField(
                style: TextStyle(color: Colors.black),
                obscureText: true, // To hide the entered password
                decoration: InputDecoration(
                  hintText: "Enter new password",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  newVal = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(newVal);
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        ),
      );

      if (newVal.trim().length > 0) {
        await updatePassword(newVal);
      }
    } else {
      // For fields other than 'password'
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Edit $field1",
            style: TextStyle(color: Colors.black),
          ),
          content: TextField(
            autofocus: true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: "Enter new $field1",
              hintStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              newVal = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(newVal);
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        ),
      );

      if (newVal.trim().length > 0) {
        await usersCollection.doc(currentUser.email).update({field: newVal});
      }
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      // Use the Firebase Authentication API to update the user's password
      await currentUser.updatePassword(newPassword);

      // Show a message or handle the password update success
      showMessage("Password updated successfully");
    } catch (e) {
      // Handle password update failure
      showMessage("Error updating password");
    }
  }



  void showMessage(String message){
    showDialog(context: context, builder: (context)=> AlertDialog(
      title: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile page',style :TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
        ,backgroundColor: Colors.grey[600],),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").doc(currentUser.email).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            final userData = snapshot.data!.data() as Map<String,dynamic>;
            return ListView(
              children: [
                SizedBox(height: 50,),
                Icon(Icons.person,size: 70,),
                SizedBox(height: 10,),
                Text(currentUser.email!,textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.bold),),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text('My informations : ',style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.bold),),
                ),
                MyTextBox(text: userData['Username'], sectionName: 'Username',onPressed: () => editField('Username'),),
                MyTextBox(text: userData['Full name'], sectionName: 'Full name',onPressed: () => editField('Full name'),),
                MyTextBox(text: userData['Bio'], sectionName: 'User bio',onPressed: () => editField('Bio'),),
                MyTextBox(text: '', sectionName: 'Password',onPressed: () => editField('Password'),),
                SizedBox(height: 50,),
                // Padding(
                //   padding: const EdgeInsets.only(left: 25.0),
                //   child: Text('My posts : ',style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.bold),),
                // ),
              ],
            );
          }else if(snapshot.hasError){
            return Center(child: Text('Error : ${snapshot.error}'),
            );
          }
          return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}