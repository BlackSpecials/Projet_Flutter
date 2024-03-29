import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Components/button.dart';
import '../Components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, this.onTap});//

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  bool isEmailValid(String email) {
    String pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  void signUp() async{
    showDialog(context: context, builder: (context)=>Center(child: CircularProgressIndicator(),));
    if (!isEmailValid(emailTextController.text)) {
      Navigator.pop(context);
      showMessage('Please enter a valid email address !');
      return;
    }
    if(passwordTextController.text!=confirmPasswordTextController.text){
      Navigator.pop(context);
      showMessage("Passwords don't match ! Please try again");
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set({
        'Username' : emailTextController.text.split('@')[0],
        'Full name' : 'Empty full name..',
        'Bio' : 'Empty bio..'
      });
      if(context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showMessage('The password provided is too weak ! Please try again');
      } else if (e.code == 'email-already-in-use') {
        showMessage('The account already exists for that email ! Please try again');
      }
    } catch (e) {
      print(e);
    }
    // try{
    //   UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailTextController.text,
    //       password: confirmPasswordTextController.text);
    //   FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set({
    //     'username' : emailTextController.text.split('@')[0],
    //     'bio' : 'Empty bio..'
    //   });
    //   if(context.mounted) Navigator.pop(context);
    // } on FirebaseAuthException catch(err){
    //   Navigator.pop(context);
    //   showMessage(err.code);
    // }

  }

  void showMessage(String message){
    showDialog(context: context, builder: (context)=> AlertDialog(
      title: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_add_alt_1_rounded,
                size: 100,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Create a new account",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              MyTextField(
                  controller: emailTextController,
                  hintText: 'Email',
                  obscureText: false),
              SizedBox(
                height: 10,
              ),
              MyTextField(
                  controller: passwordTextController,
                  hintText: 'Password',
                  obscureText: true),
              SizedBox(
                height: 10,
              ),
              MyTextField(
                  controller: confirmPasswordTextController,
                  hintText: 'Confirm password',
                  obscureText: true),
              SizedBox(
                height: 10,
              ),
              MyButton(onTap: signUp, text: 'Sign up'),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already a member ?",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Sign in now",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
