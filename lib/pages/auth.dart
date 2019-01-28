import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';

enum AuthMode { Signup, Login }

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _userCredentials = {
    'email': null,
    'password': null,
    'confirmPassword': null
  };
  bool _acceptTerms = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  BoxDecoration _buildBackgroundImage() {
    return BoxDecoration(
        image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop),
            fit: BoxFit.cover,
            image: AssetImage('assets/background.jpg')));
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Email',
          filled: true,
          fillColor: Theme.of(context).cardColor),
      keyboardType: TextInputType.emailAddress,
      // validator: (String value) {
      //   if (!RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
      //           .hasMatch(value) ||
      //       value.isEmpty) {
      //     return 'Email is required';
      //   }
      // },
      onSaved: (value) {
        _userCredentials['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password',
          filled: true,
          fillColor: Theme.of(context).cardColor),
      controller: _textController,
      obscureText: true,
      // validator: (String value) {
      //   if (value.isEmpty) {
      //     return 'Password is required';
      //   }
      // },
      onSaved: (value) {
        _userCredentials['password'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Confirm Password',
          filled: true,
          fillColor: Theme.of(context).cardColor),
      obscureText: true,
      validator: (String value) {
        // if (value != _textController.text) {
        if (value != _userCredentials['password']) {
          return 'Passwords should match';
        }
      },
      onSaved: (value) {
        _userCredentials['password'] = value;
      },
    );
  }

  Widget _buildSwitch() {
    return SwitchListTile(
      title: Text("Accept terms"),
      value: _acceptTerms,
      onChanged: (value) {
        setState(() {
          _acceptTerms = value;
        });
      },
    );
  }

  void _login(Function login) {
    if (!_formKey.currentState.validate() || !_acceptTerms) {
      return;
    }
    _formKey.currentState.save();
    login(_userCredentials['email'], _userCredentials['password']);
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 768.0 ? 500.0 : deviceWidth * 0.95;

    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Container(
            padding: EdgeInsets.all(10.0),
            decoration: _buildBackgroundImage(),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                    width: targetWidth,
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            _buildEmailTextField(),
                            SizedBox(
                              height: 10.0,
                            ),
                            _buildPasswordTextField(),
                            SizedBox(
                              height: 10.0,
                            ),
                            _authMode == AuthMode.Signup
                                ? _buildPasswordConfirmTextField()
                                : Container(),
                            _buildSwitch(),
                            SizedBox(
                              height: 10.0,
                            ),
                            FlatButton(
                              child: Text(
                                  'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}'),
                              onPressed: () {
                                setState(() {
                                  _authMode = _authMode == AuthMode.Login
                                      ? AuthMode.Signup
                                      : AuthMode.Login;
                                });
                              },
                            ),
                            ScopedModelDescendant<MainModel>(
                              builder: (context, child, MainModel model) {
                                return RaisedButton(
                                  child: Text("LOGIN"),
                                  onPressed: !_acceptTerms
                                      ? null
                                      : () => _login(model.login),
                                );
                              },
                            ),
                          ],
                        ))),
              ),
            )));
  }
}
