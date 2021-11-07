import 'dart:io';

import 'package:flutter/material.dart';
import 'package:messman/models/user.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/includes/helpers.dart';
import 'package:messman/widgets/image_capture.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/profile/edit';

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<EditProfileScreen> {
  final _form = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();

  AuthService _auth;

  bool _isLoading = false;
  User _user = new User(name: '', email: '', phone: '');
  File _selectedImage;

  Future<void> _saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState.save();
    try {
      await _auth.editProfile(_user, _selectedImage);
      return Navigator.of(context).pop(true);
    } catch (error) {
      showHttpError(context, error);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _imageSelectedCallback(File file) {
    setState(() {
      _selectedImage = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthService>(context);
    _user = _auth.user;

    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: <Widget>[
            Form(
              key: _form,
              child: Column(
                children: <Widget>[
                  ImageCapture(
                    callback: _imageSelectedCallback,
                    maxHeight: 300,
                    maxWidth: 300,
                  ),
                  TextFormField(
                    initialValue: _user.name,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Name',
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_emailFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _user.name = value.trim();
                    },
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                    initialValue: _user.email,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email Address',
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_phoneFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your email address!';
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'This is not a valid email!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _user.email = value.trim();
                    },
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                    initialValue: _user.phone,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      labelText: 'Phone Number',
                    ),
                    focusNode: _phoneFocusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _saveForm(),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a phone number!';
                      } else if (value.length < 6) {
                        return 'Phone cannot be less than 11 character!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _user.phone = value;
                    },
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: _saveForm,
                      child: Text('Save'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.grey.shade100.withOpacity(0.5),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
