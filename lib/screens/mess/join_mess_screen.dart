import 'package:flutter/material.dart';
import 'package:messman/screens/mess/create_mess_screen.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/services/helpers.dart';
import 'package:messman/services/mess_service.dart';
import 'package:messman/widgets/screen_loading.dart';
import 'package:provider/provider.dart';

class JoinMessScreen extends StatefulWidget {
  static const routeName = '/mess/join';
  @override
  _JoinMessScreenState createState() => _JoinMessScreenState();
}

class _JoinMessScreenState extends State<JoinMessScreen> {
  bool _isLoading = false;
  final _joinCodeController = TextEditingController();
  MessService _messService;

  void joinMess(String joinCode) async {
    if (joinCode.isEmpty) {
      return showHttpError(
        context,
        'Please enter your mess\'s join code. Ask your manager to get that code from add member section.',
        title: 'No Join Code!',
      );
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final int messId = await _messService.joinMess(joinCode);
      if (messId != null && messId > 0) {
        Provider.of<AuthService>(context, listen: false).messId = messId;
        return;
      } else {
        showHttpError(context, 'Received mess ID is invalid!');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      showHttpError(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    _messService = Provider.of<MessService>(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 40),
                  Image.asset('assets/images/lunch.png'),
                  SizedBox(height: 20),
                  Text(
                    'Welcome to MessMan',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Spacer(),
                  Text(
                    'Join an existing mess.',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.security),
                            labelText: 'Join Code',
                          ),
                          onSubmitted: (val) => joinMess(val),
                          controller: _joinCodeController,
                        ),
                      ),
                      SizedBox(width: 5),
                      FlatButton(
                        onPressed: () => joinMess(_joinCodeController.text),
                        child: Text('Join Mess'),
                        color: Theme.of(context).primaryColorLight,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(CreateMessScreen.routeName);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Create a new Mess',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward, size: 22),
                      ],
                    ),
                    textColor: Theme.of(context).primaryColorDark,
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            if (_isLoading) ScreenLoading(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _joinCodeController.dispose();
    super.dispose();
  }
}
