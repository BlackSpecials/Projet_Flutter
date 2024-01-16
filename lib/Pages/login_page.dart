import 'package:chatappflutter/Components/button.dart';
import 'package:chatappflutter/Components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();  // data il est stocker dans ces controleur
  final passwordTextController = TextEditingController();

  void signIn() async{
    showDialog(context: context, builder: (context)=>Center(child: CircularProgressIndicator(),)); //loading
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(  //definis sur firbase
          email: emailTextController.text,
          password: passwordTextController.text
      );
      if(context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch(err){
      Navigator.pop(context);
      showMessage(err.code);
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
      backgroundColor: Colors.grey[350],
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,//
                size: 100,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Welcome back, you've been missed !",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
              //
              SizedBox(
                height: 25,
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
              MyButton(onTap: signIn, text: 'Sign in'),  /****************************************/
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member ?",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Register now",
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

