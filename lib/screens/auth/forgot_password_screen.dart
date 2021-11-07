import 'package:flutter/material.dart';
import 'package:messman/includes/dialogs.dart';
import 'package:messman/includes/helpers.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/widgets/screen_loading.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot-password';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthService _auth;

  String _email;

  Future<void> _saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState.save();
    try {
      final result = await _auth.resetPassword(_email);
      if (result != null) {
        return showInfoDialog(
          title: 'Success',
          content: result,
          context: context,
        ).then((value) {
          return Navigator.of(context).pop();
        });
      }
    } catch (error) {
      showHttpError(context, error);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // SizedBox(height: 30),
                Text(
                  'Reset password,',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Let\'s set a new password for your account.',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 6),

                Form(
                  key: _form,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _email,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Email Address',
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade50),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
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
                          _email = value.trim();
                        },
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: _saveForm,
                          child: Text('Email Me Password Reset Link'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading) ScreenLoading()
        ],
      ),
    );
  }
}
