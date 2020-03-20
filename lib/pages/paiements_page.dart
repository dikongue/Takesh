import 'package:flutter/material.dart';

//const kGoogleApiKey = "AIzaSyACQUQ3bBUBnWKqr1lwZA8j9s6obY9oPTQ";
const kGoogleApiKey = "AIzaSyBNm8cnYw5inbqzgw8LjXyt3rMhFhEVTjY";

class PaiementPage extends StatefulWidget {
  @override
  State createState() => PaiementPageState();
}

class PaiementPageState extends State<PaiementPage> {
  double PADDING_HORIZONTAL = 15.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Mes Paiements',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Text("En cours de developpement...."),
      ),
    );
  }
}
