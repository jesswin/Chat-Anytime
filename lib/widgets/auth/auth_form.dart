import 'dart:io';

import 'package:flutter/material.dart';

import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String pass, String uname, File image,
          bool isLogin, BuildContext ctx)
      _submitForm; //passing ctx from here because we dont have access to scffold of parent widget!so getting it from the child widget!
  final bool _isLoading;
  AuthForm(this._submitForm, this._isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  GlobalKey<FormState> _globalKey = GlobalKey();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPass = '';
  File _userImage;
  //BuildContext context;
  _submit() {
    if (_userImage == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Please Take an Image'),
          backgroundColor: Theme.of(context).errorColor));
      return;
    }
    final isValid = _globalKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _globalKey.currentState.save();
      widget._submitForm(_userEmail.trim(), _userPass.trim(), _userName.trim(),
          _userImage, _isLogin, context);
    }
  }

  void _pickImage(File image) {
    _userImage = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
              key: _globalKey,
              child: Column(
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(_pickImage),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Enter a Valid E-mail!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'Email-Address',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please Enter atleast 4 Characters!';
                        }
                        return null;
                      },
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      onSaved: (value) {
                        _userName = value;
                      },
                      decoration: InputDecoration(
                          labelText: 'UserName',
                          labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password should be atleast 7 Characters Long!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPass = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Pasword',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget._isLoading)
                    CircularProgressIndicator(),
                  if (!widget._isLoading)
                    RaisedButton(
                      onPressed: _submit,
                      child: Text(_isLogin ? 'Login' : 'SignUp'),
                    ),
                  //if (widget._isLoading) CircularProgressIndicator(),this will show 2 spinners
                  if (!widget._isLoading)
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create a New Account'
                          : 'I already Have an Account'),
                      textColor: Theme.of(context).primaryColor,
                    )
                ],
                mainAxisSize: MainAxisSize.min,
              )),
        ),
      ),
    );
  }
}
