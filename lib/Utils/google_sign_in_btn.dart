import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final Function onPressed;

  GoogleSignInButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => this.onPressed(),
      color: Colors.orange,
      elevation: 0.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            "assets/images/google.png",
            height: 18.0,
            width: 18.0,
          ),
          SizedBox(width: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "S'inscrire avec son Google",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
