import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import '../models/user.dart';

const String authUrl =
    'https://www.googleapis.com/identitytoolkit/v3/relyingparty/'; //signupNewUser?key=AIzaSyBM0lrgncgSoztq2BwPyYXdnITyMSXLND0';
const String apiKey = '?key=AIzaSyBM0lrgncgSoztq2BwPyYXdnITyMSXLND0';

mixin UserModel on Model {
  User _authenticatedUser;
  bool _isLoadingUser = false;
  bool _isInSignInMode = true;
  PublishSubject<bool> _userSubject = PublishSubject();

  Future<Map<String, dynamic>> authenticate(
      String email, String password) async {
    _isLoadingUser = true;
    notifyListeners();
    final Map<String, dynamic> userCredentials = {
      "email": email,
      "password": password,
      "returnSecureToken": true
    };
    String enpoint = _isInSignInMode ? 'verifyPassword' : 'signupNewUser';
    http.Response response = await http.post(authUrl + enpoint + apiKey,
        body: json.encode(userCredentials),
        headers: {'Content-Type': 'application/json'});
    final Map<String, dynamic> parsedResponse = json.decode(response.body);
    bool success = false;
    String message = 'Something went wrong';
    if (parsedResponse.containsKey('idToken')) {
      success = true;
    } else if (parsedResponse['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists';
    } else if (parsedResponse['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found';
    } else if (parsedResponse['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid';
    }
    _isLoadingUser = false;
    if (success) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', parsedResponse['idToken']);
      prefs.setString('userId', parsedResponse['localId']);
      prefs.setString('userEmail', parsedResponse['email']);
      _authenticatedUser = User(
          email: parsedResponse['email'],
          id: parsedResponse['localId'],
          token: parsedResponse['idToken'],
          refreshToken: parsedResponse['refreshedToken']);
    }
    notifyListeners();
    return {'success': success, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token != null) {
      String userId = prefs.getString('userId');
      String userEmail = prefs.getString('userEmail');
      _authenticatedUser = User(id: userId, email: userEmail, token: token);
      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedUser = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userId');
    prefs.remove('userEmail');
    notifyListeners();
  }

  User get authenticatedUser {
    return _authenticatedUser;
  }

  bool get isLoadingUser {
    return _isLoadingUser;
  }

  bool get isInSignInMode {
    return _isInSignInMode;
  }

  void setSignInMode(bool value) {
    _isInSignInMode = value;
    notifyListeners();
  }

  PublishSubject get userSubject {
    return _userSubject;
  }
}
