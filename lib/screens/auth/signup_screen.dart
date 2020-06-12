import 'package:flutter/material.dart';
import 'package:mess/models/http_exception.dart';
import 'package:mess/services/auth_service.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SignupScreen> {
  final _form = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _passwordController = TextEditingController();

  AuthService _auth;

  bool _isLoading = false;

  Map<String, String> _authData = {
    'name': 'MH Sagor',
    'email': 'mhsagor91@gmail.com',
    'password': 'password',
  };

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ooops!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState.save();
    try {
      await _auth.signUp(_authData);
      Navigator.of(context).pop();
    } on HttpException catch (error) {
      _showError(error.toString());
    } catch (error) {
      _showError('Something went wrong, could not sign you up!');
      throw error;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _passwordController.text = _authData['password'];
    _auth = Provider.of<AuthService>(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // SizedBox(height: 30),
                      Text(
                        'Create account,',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Let\'s create an account for you....',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Form(
                    key: _form,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: _authData['name'],
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: 'Name',
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_emailFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Name cannot be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['name'] = value.trim();
                          },
                        ),
                        SizedBox(height: 25),
                        TextFormField(
                          initialValue: _authData['email'],
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: 'Email Address',
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
                            _authData['email'] = value.trim();
                          },
                        ),
                        SizedBox(height: 25),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Password',
                          ),
                          focusNode: _passwordFocusNode,
                          textInputAction: TextInputAction.next,
                          controller: _passwordController,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_confirmPasswordFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a password!';
                            } else if (value.length < 6) {
                              return 'Password cannot be less than 6 character!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['password'] = value;
                          },
                        ),
                        SizedBox(height: 25),
                        TextFormField(
                          initialValue: _authData['password'],
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Confirm Password',
                          ),
                          focusNode: _confirmPasswordFocusNode,
                          onFieldSubmitted: (value) {
                            _saveForm();
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please re enter your password!';
                            } else if (value != _passwordController.text) {
                              return 'Password does not match!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['password'] = value;
                          },
                        ),
                        SizedBox(height: 25),
                        SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: _saveForm,
                            child: Text('Sign Up'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: Color(0xff2c2d35),
                            textColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Already have an account? '),
                      GestureDetector(
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
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
    );
  }
}
