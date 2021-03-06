import 'dart:async';

import 'package:etakesh_client/Utils/google_sign_in_btn.dart';
import 'package:etakesh_client/Utils/masked_text.dart';
import 'package:etakesh_client/Utils/refresh_indicator.dart';
import 'package:etakesh_client/logger.dart';
import 'package:etakesh_client/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus { SOCIAL_AUTH, PHONE_AUTH, SMS_AUTH, PROFILE_AUTH }

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static const String TAG = "AUTH";
  AuthStatus status = AuthStatus.SOCIAL_AUTH;

  // Keys
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<MaskedTextFieldState> _maskedPhoneKey =
      GlobalKey<MaskedTextFieldState>();

  // Controllers
  TextEditingController smsCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  // Variables
  String _errorMessage;
  String _verificationId;
  Timer _codeTimer;

  bool _isRefreshing = false;
  bool _codeTimedOut = false;
  bool _codeVerified = false;
  Duration _timeOut = const Duration(minutes: 1);

  // Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInAccount _googleUser;

  // PhoneVerificationCompleted
  verificationCompleted(FirebaseUser user) async {
    Logger.log(TAG, message: "onVerificationCompleted, user: $user");
    if (await _onCodeVerified(user)) {
      await _finishSignIn(user);
    } else {
      setState(() {
        this.status = AuthStatus.SMS_AUTH;
        Logger.log(TAG, message: "Changed status to $status");
      });
    }
  }

  // PhoneVerificationFailed
  verificationFailed(AuthException authException) {
    _showErrorSnackbar(
        "Nous ne pouvons pas verifier votre code maintenant reessayez plutard !");
    Logger.log(TAG,
        message:
            'onVerificationFailed, code: ${authException.code}, message: ${authException.message}');
  }

  // PhoneCodeSent
  codeSent(String verificationId, [int forceResendingToken]) async {
    Logger.log(TAG,
        message:
            "Verification code sent to number ${phoneNumberController.text}");
    _codeTimer = Timer(_timeOut, () {
      setState(() {
        _codeTimedOut = true;
      });
    });
    _updateRefreshing(false);
    setState(() {
      this._verificationId = verificationId;
      this.status = AuthStatus.SMS_AUTH;
      Logger.log(TAG, message: "Changed status to $status");
    });
  }

  // PhoneCodeAutoRetrievalTimeout
  codeAutoRetrievalTimeout(String verificationId) {
    Logger.log(TAG, message: "onCodeTimeout");
    _updateRefreshing(false);
    setState(() {
      this._verificationId = verificationId;
      this._codeTimedOut = true;
    });
  }

  // Styling

  final decorationStyle = TextStyle(color: Colors.black87, fontSize: 16.0);
  final hintStyle = TextStyle(color: Colors.black26);
  final String url = "http://api.e-takesh.com:26960/api/clients";
  final String token =
      "?access_token=TmxqQVrxAKZTXjNgiOxzQVlf9gql9C3oKEYLRkTtjkoqkUD5YcHmPR6TiIaVVsAj";
  //

  @override
  void dispose() {
    _codeTimer?.cancel();
    super.dispose();
  }

  // async

  Future<Null> _updateRefreshing(bool isRefreshing) async {
    Logger.log(TAG,
        message: "Setting _isRefreshing ($_isRefreshing) to $isRefreshing");
    if (_isRefreshing) {
      setState(() {
        this._isRefreshing = false;
      });
    }
    setState(() {
      this._isRefreshing = isRefreshing;
    });
  }

  _showErrorSnackbar(String message) {
    _updateRefreshing(false);
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<Null> _signIn() async {
    GoogleSignInAccount user = _googleSignIn.currentUser;
    Logger.log(TAG, message: "Just got user as: $user");

    if (user == null) {
      await _googleSignIn.signIn().then((account) {
        user = account;
      }, onError: (error) {
        _showErrorSnackbar(
            "Nous ne parvenons pas a vous enrgistrer avec cette Email");
      });
    }

    if (user != null) {
      _updateRefreshing(false);
      this._googleUser = user;
      setState(() {
        this.status = AuthStatus.PHONE_AUTH;
        Logger.log(TAG, message: "Changed status to $status");
      });
      return null;
    }
    if (user != null && this.status == AuthStatus.PHONE_AUTH) {
      _updateRefreshing(false);
      this._googleUser = user;
      setState(() {
        this.status = AuthStatus.PROFILE_AUTH;
        Logger.log(TAG, message: "Changed status to $status");
      });
      return null;
    }
    return null;
  }

  Future<Null> _submitPhoneNumber() async {
    final error = _phoneInputValidator();
    if (error != null) {
      _updateRefreshing(false);
      setState(() {
        _errorMessage = error;
      });
      return null;
    } else {
      _updateRefreshing(false);
      setState(() {
        _errorMessage = null;
      });
      final result = await _verifyPhoneNumber();
      Logger.log(TAG, message: "Returning $result from _submitPhoneNumber");
      return result;
    }
  }

  String get phoneNumber {
    String unmaskedText = _maskedPhoneKey.currentState.unmaskedText;
    String formatted = "+237$unmaskedText".trim();
    return formatted;
  }

  Future<Null> _verifyPhoneNumber() async {
    Logger.log(TAG, message: "Got phone number as: ${this.phoneNumber}");
    await _auth.verifyPhoneNumber(
        phoneNumber: this.phoneNumber,
        timeout: _timeOut,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed);
    Logger.log(TAG, message: "Returning null from _verifyPhoneNumber");
    return null;
  }

  Future<Null> _submitSmsCode() async {
    final error = _smsInputValidator();
    if (error != null) {
      _updateRefreshing(false);
      _showErrorSnackbar(error);
      return null;
    } else {
      if (this._codeVerified) {
        await _finishSignIn(await _auth.currentUser());
      } else {
        Logger.log(TAG, message: "_signInWithPhoneNumber called");
        await _signInWithPhoneNumber();
      }
      return null;
    }
  }

  Future<void> _signInWithPhoneNumber() async {
    final errorMessage = "Nous ne pouvons verifier votre code reessayez !!!";
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: smsCodeController.text,
    );
    final FirebaseUser user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    assert(user.uid == currentUser.uid);
    if (user != null) {
      await _onCodeVerified(user).then((codeVerified) async {
        this._codeVerified = codeVerified;
        Logger.log(
          TAG,
          message: "Returning ${this._codeVerified} from _onCodeVerified",
        );
        if (this._codeVerified) {
          await _finishSignIn(user);
        } else {
          _showErrorSnackbar(errorMessage);
        }
      });
    } else {
      _showErrorSnackbar(errorMessage);
    }
//    await _auth
//        .signInWithPhoneNumber(
//            verificationId: _verificationId, smsCode: smsCodeController.text)
//        .then((user) async {
//      await _onCodeVerified(user).then((codeVerified) async {
//        this._codeVerified = codeVerified;
//        Logger.log(
//          TAG,
//          message: "Returning ${this._codeVerified} from _onCodeVerified",
//        );
//        if (this._codeVerified) {
//          await _finishSignIn(user);
//        } else {
//          _showErrorSnackbar(errorMessage);
//        }
//      });
//    }, onError: (error) {
//      print("Failed to verify SMS code: $error");
//      _showErrorSnackbar(errorMessage);
//    });
  }

  Future<bool> _onCodeVerified(FirebaseUser user) async {
    final isUserValid = (user != null &&
        (user.phoneNumber != null && user.phoneNumber.isNotEmpty));
    if (isUserValid) {
      setState(() {
        // Here we change the status once more to guarantee that the SMS's
        // text input isn't available while you do any other request
        // with the gathered data
        this.status = AuthStatus.PROFILE_AUTH;
        Logger.log(TAG, message: "Changed status to $status");
      });
    } else {
      _showErrorSnackbar("Nous ne pouvons verifier votre code reessayez !!!");
    }
    return isUserValid;
  }

  _finishSignIn(FirebaseUser user) async {
    await _onCodeVerified(user).then((result) {
      if (result) {
        // Here, instead of navigating to another screen, you should do whatever you want
        // as the user is already verified with Firebase from both
        // Google and phone number methods
        // Example: authenticate with your own API, use the data gathered
        // to post your profile/user, etc.

        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (context) => HomePage(
//                googleUser: _googleUser,
//                firebaseUser: user,
              ),
        ));
      } else {
        setState(() {
          this.status = AuthStatus.SMS_AUTH;
        });
        _showErrorSnackbar(
            "Nous ne pouvons pas vous enregistrer maintenant reessayer plus tard");
      }
    });
  }

  // Widgets

  Widget _buildSocialLoginBody() {
    return GoogleSignInButton(
      onPressed: () => _updateRefreshing(true),
    );
  }

  Widget _buildConfirmInputButton() {
    final theme = Theme.of(context);
    return IconButton(
      icon: Icon(Icons.check),
      color: Colors.green,
      disabledColor: theme.buttonColor,
      onPressed: (this.status == AuthStatus.PROFILE_AUTH)
          ? null
          : () => _updateRefreshing(true),
    );
  }

  Widget _buildPhoneNumberInput() {
    return MaskedTextField(
      key: _maskedPhoneKey,
      mask: "(x) xx-xx-xx-xx",
      keyboardType: TextInputType.number,
      maskedTextFieldController: phoneNumberController,
      maxLength: 15,
      onSubmitted: (text) => _updateRefreshing(true),
      style: Theme.of(context)
          .textTheme
          .subhead
          .copyWith(fontSize: 18.0, color: Colors.black),
      inputDecoration: InputDecoration(
        isDense: false,
        enabled: this.status == AuthStatus.PHONE_AUTH,
        counterText: "",
        icon: const Icon(
          Icons.phone,
          color: Colors.black87,
        ),
        labelText: "Telephone",
        labelStyle: decorationStyle,
        hintText: "(6) 99-99-99-99",
        hintStyle: hintStyle,
        errorText: _errorMessage,
      ),
    );
  }

  Widget _buildPhoneAuthBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          child: Text(
            "Nous vous enverons un SMS pour verifier votre votre identite, Veillez entrer votre numero de telephone!",
            style: decorationStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(flex: 5, child: _buildPhoneNumberInput()),
              Flexible(flex: 1, child: _buildConfirmInputButton())
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmsCodeInput() {
    final enabled = this.status == AuthStatus.SMS_AUTH;
    return TextField(
      keyboardType: TextInputType.number,
      enabled: enabled,
      textAlign: TextAlign.center,
      controller: smsCodeController,
      maxLength: 6,
      onSubmitted: (text) => _updateRefreshing(true),
      style: Theme.of(context).textTheme.subhead.copyWith(
            fontSize: 32.0,
            color: enabled ? Colors.black : Theme.of(context).buttonColor,
          ),
      decoration: InputDecoration(
        counterText: "",
        enabled: enabled,
        hintText: "--- ---",
        hintStyle: hintStyle.copyWith(fontSize: 42.0),
      ),
    );
  }

  Widget _buildResendSmsWidget() {
    return InkWell(
      onTap: () async {
        if (_codeTimedOut) {
          await _verifyPhoneNumber();
        } else {
          _showErrorSnackbar("Vous ne pouvez pas : reessayez maintenant");
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Si votre code n'arrive pas dans 1 minute touchez",
            style: decorationStyle,
            children: <TextSpan>[
              TextSpan(
                text: " Ici",
                style: TextStyle(
                  color: Colors.yellow,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmsAuthBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          child: Text(
            "Verification du code",
            style: decorationStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 64.0),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(flex: 5, child: _buildSmsCodeInput()),
              Flexible(flex: 2, child: _buildConfirmInputButton())
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _buildResendSmsWidget(),
        )
      ],
    );
  }

  String _phoneInputValidator() {
    if (phoneNumberController.text.isEmpty) {
      return "Votre numero de telephone ne peut pas etre vide";
    } else if (phoneNumberController.text.length < 15) {
      return "Ce numero de telephone est invalide";
    }
    return null;
  }

  String _smsInputValidator() {
    if (smsCodeController.text.isEmpty) {
      return "Votre code de verification ne peut pas etre vide";
    } else if (smsCodeController.text.length < 6) {
      return "Ce code est invalide";
    }
    return null;
  }

  Widget _buildBody() {
    Widget body;
    switch (this.status) {
      case AuthStatus.SOCIAL_AUTH:
        body = _buildSocialLoginBody();
        break;
      case AuthStatus.PHONE_AUTH:
        body = _buildPhoneAuthBody();
        break;
      case AuthStatus.SMS_AUTH:
      case AuthStatus.PROFILE_AUTH:
        body = _buildSmsAuthBody();
        break;
    }
    return body;
  }

  Future<Null> _onRefresh() async {
    switch (this.status) {
      case AuthStatus.SOCIAL_AUTH:
        return await _signIn();
        break;
      case AuthStatus.PHONE_AUTH:
        return await _submitPhoneNumber();
        break;
      case AuthStatus.SMS_AUTH:
        return await _submitSmsCode();
        break;
      case AuthStatus.PROFILE_AUTH:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: ReactiveRefreshIndicator(
          onRefresh: _onRefresh,
          isRefreshing: _isRefreshing,
          child: Container(child: _buildBody()),
        ),
      ),
    );
  }
}
