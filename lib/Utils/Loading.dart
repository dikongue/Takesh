import 'package:flutter/material.dart';

class ShowLoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(
                backgroundColor: Color(0xFF0C60A8),
              ),
            ),
            Text(
              "Chargement...",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.black),
            )
          ],
        ),
      ),
    ));
  }
}

class ShowConnectionErrorView extends StatelessWidget {
  final void Function() onRetryClick;
  ShowConnectionErrorView(this.onRetryClick);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                  onPressed: onRetryClick,
                  color: Colors.transparent,
                  elevation: 0.0,
                  child: Icon(
                    Icons.refresh,
                    size: 50.0,
                    color: Color(0xFF0C60A8),
                  )),
            ),
            Text(
              "Il semble que votre appareil n’ait pas de connexion Internet. \n Veuillez  vérifier et réessayer.",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            )
          ],
        ),
      ),
    ));
  }
}

class ShowLoadingErrorView extends StatelessWidget {
  final void Function() onRetryClick;
  ShowLoadingErrorView(this.onRetryClick);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                  onPressed: onRetryClick,
                  color: Colors.transparent,
                  elevation: 0.0,
                  child: Icon(
                    Icons.refresh,
                    size: 50.0,
                    color: Color(0xFF0C60A8),
                  )),
            ),
            Text(
              "Une erreur C'est produite. Veuillez rafraichir",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            )
          ],
        ),
      ),
    ));
  }
}
