import 'package:flutter/material.dart';
import 'package:messman/screens/auth/forgot_password_screen.dart';
import 'package:messman/screens/auth/signup_screen.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/includes/helpers.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  static const routeName = '/signin';
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _form = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  AuthService _auth;

  bool _isLoading = false;

  String _email = '';
  String _password = '';

  Future<void> _saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState.save();
    try {
      await _auth.signIn(_email, _password);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Oooops!'),
          content: Text(error.toString()),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                if (context != null) {
                  Navigator.of(context).pop();
                }
              },
              child: Text('Okay'),
            ),
          ],
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthService>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Icon(Icons.people, size: 60),
                        ),
                        SizedBox(height: 20),
                        FittedBox(
                          child: Text(
                            'Welcome to MessMan',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Please sign in to continue.',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
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
                                borderSide:
                                    BorderSide(color: Colors.grey.shade50),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode);
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
                              _email = value.trim();
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            initialValue: _password,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              labelText: 'Password',
                              contentPadding: EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade50),
                              ),
                            ),
                            focusNode: _passwordFocusNode,
                            onFieldSubmitted: (value) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your password!';
                              } else if (value.length < 6) {
                                return 'Password cannot be less than 6 character!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password = value;
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                              child: Text('Forgot Password?'),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(ForgotPasswordScreen.routeName);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 45,
                            width: double.infinity,
                            child: RaisedButton(
                              onPressed: _saveForm,
                              child: Text('Sign In'),
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
                    Column(
                      children: <Widget>[
                        SizedBox(height: 16),
                        SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: RaisedButton.icon(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              _auth.googleSignIn().then((_) {
//                                Navigator.of(context).pushNamed(HomeScreen.routeName);
                              }).catchError((error) {
                                setState(() {
                                  _isLoading = false;
                                });
                                showHttpError(context, error);
                              });
                            },
                            icon: SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset(
                                'assets/icons/google.png',
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            label: Text('Connect with Google'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('New here?'),
                        FlatButton(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(SignupScreen.routeName);
                          },
                        ),
                      ],
                    ),
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
      ),
    );
  }
}
