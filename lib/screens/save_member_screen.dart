import 'dart:io';
import 'package:messman/models/models.dart';
import 'package:messman/services/members_service.dart';
import 'package:flutter/material.dart';
import 'package:messman/widgets/network_circle_avatar.dart';
import 'package:provider/provider.dart';
import 'package:messman/widgets/image_capture.dart';

class SaveMemberScreen extends StatefulWidget {
  static const routeName = '/save-member';

  @override
  _SaveMemberScreenState createState() => _SaveMemberScreenState();
}

class _SaveMemberScreenState extends State<SaveMemberScreen> {
  bool _isLoading = false;

  final _form = GlobalKey<FormState>();
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  File _membersImage;

  User _member = User(
    name: 'Test Member',
    phone: '01775755272',
    email: 'test@gmail.com',
    imageUrl: '',
    // imageUrl: 'https://fakeimg.pl/440x320/',
  );

  Future<void> _saveForm() async {
    if (!_form.currentState.validate()) return;
    if (_member.imageUrl.isEmpty && _membersImage == null) {
      _showErrors(
          'You did not select any image. Please select an image of the member!');
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<MembersService>(context, listen: false)
          .addMember(_member, _membersImage);
      Navigator.of(context).pop(true);
      return;
    } catch (error) {
      _showErrors(error.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showErrors(String error) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Oooops!'),
        content: Text(error),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  void _membersImageCallback(File file) {
    setState(() {
      _membersImage = file;
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _membersImage = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final passedTransaction = ModalRoute.of(context).settings.arguments as User;
    if (passedTransaction != null) {
      _member = passedTransaction;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${_member.id == null ? 'Add New' : 'Update'} Member'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _isLoading ? null : _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                if (_member.imageUrl != null &&
                    _member.imageUrl.isNotEmpty &&
                    _membersImage == null) ...[
                  Center(
                    child: NetworkCircleAvatar(
                        imageUrl: _member.imageUrl, size: 100),
                  ),
                  SizedBox(height: 20),
                ],
                Text(
                  '${(_member.imageUrl != null && _member.imageUrl.isNotEmpty) ? 'Update' : 'Select'} Image',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                ImageCapture(
                  callback: _membersImageCallback,
                  maxHeight: 300,
                  maxWidth: 300,
                ),
                SizedBox(height: 20),
                Form(
                  key: _form,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _member.name,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                        },
                        validator: (value) {
                          value = value.trim();
                          if (value.isEmpty) {
                            return 'Name cannot be empty!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _member.name = value;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue: _member.email,
                        decoration: InputDecoration(
                          labelText: 'Email address',
                          prefixIcon: Icon(Icons.email),
                        ),
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_phoneFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Email address cannot be empty!';
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return 'This is not a valid email address!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _member.email = value;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue:
                            _member.phone != null ? _member.phone : '',
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        focusNode: _phoneFocusNode,
                        keyboardType: TextInputType.phone,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Phone number cannot be empty!';
                          } else if (value.length < 10) {
                            return 'Phone number is not long enough!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _member.phone = value;
                        },
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: RaisedButton.icon(
                          icon: Icon(Icons.save),
                          label: Text('Save Member'),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onPressed: _isLoading ? null : _saveForm,
                          disabledColor: Theme.of(context).backgroundColor,
                          disabledTextColor: Colors.white70,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
