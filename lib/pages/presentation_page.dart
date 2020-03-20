import 'package:flutter/material.dart';

class PresentationPage extends StatelessWidget {
  final controler = PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text('Vos courses'),
//        backgroundColor: Colors.black87,
//      ),
      body: new Center(
        child: PageView(
          controller: controler,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                image:
                    new AssetImage('assets/images/presentation/Present1.png'),
                fit: BoxFit.cover,
              )),
            ),
            Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                image:
                    new AssetImage('assets/images/presentation/Present2.png'),
                fit: BoxFit.cover,
              )),
            ),
            Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                image:
                    new AssetImage('assets/images/presentation/Present3.png'),
                fit: BoxFit.cover,
              )),
            ),
            Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                image:
                    new AssetImage('assets/images/presentation/Present4.png'),
                fit: BoxFit.cover,
              )),
            ),
            Container(
              child: new Text("Conditions d'utilisations"),
            ),
          ],
        ),
      ),
    );
  }
}
