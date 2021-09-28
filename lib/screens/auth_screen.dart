import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  AuthResult _authResult;
  var _isLoading = false;
  _submitForm(String email, String pass, String uname, File image, bool isLogin,
      BuildContext ctx) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        _authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: pass);
      } else {
        _authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: pass);
        final ref = FirebaseStorage.instance.ref().child('user_image').child(
            _authResult.user.uid + '.jpg'); //another child for name of image
        await ref //to make it a Future we used onComplete
            .putFile(image)
            .onComplete; //this will store image with name of UserID

        final url = await ref.getDownloadURL();

        await Firestore.instance
            .collection('users')
            .document(_authResult.user.uid)
            .setData({
          'username': uname,
          'email': email,
          'image_url': url
        }); //collection will be created on the fly //we use document to set the name of doc to username
        //setdata to feed the data
      }
    } on PlatformException catch (err) {
      var message = 'An Error Occured!';
      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(_submitForm, _isLoading));
  }
}
