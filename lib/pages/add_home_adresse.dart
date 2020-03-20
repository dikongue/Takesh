import 'dart:convert';

import 'package:etakesh_client/DAO/Rest_dt.dart';
import 'package:etakesh_client/DAO/google_maps_requests.dart';
import 'package:etakesh_client/Database/DatabaseHelper.dart';
import 'package:etakesh_client/Models/clients.dart';
import 'package:etakesh_client/Models/google_place_item.dart';
import 'package:etakesh_client/Models/google_place_item_term.dart';
import 'package:etakesh_client/Models/google_place_model.dart';
import 'package:etakesh_client/Utils/AppSharedPreferences.dart';
import 'package:flutter/material.dart';

class AddHommeAdressPage extends StatefulWidget {
  final double lat;
  final double lng;

  AddHommeAdressPage({Key key, this.lat, this.lng}) : super(key: key);
  @override
  AddHommeAdressPageState createState() => new AddHommeAdressPageState();
}

class AddHommeAdressPageState extends State<AddHommeAdressPage> {
  TextEditingController _adresse;
  RestDatasource api = new RestDatasource();
  LocalAdress _home_datas;
  bool _sendDatas, _loading, _edite;
  String _placeId;
  var _locations = new List<GooglePlacesItem>();
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  @override
  initState() {
    super.initState();
    _edite = false;
    _sendDatas = false;
    _loading = false;
    _home_datas = new LocalAdress();
    _adresse = new TextEditingController();
  }

  _findLocation(String input) {
    api.findLocation(input, "fr", widget.lat, widget.lng).then((response) {
      final String responseString = response.body;
      setState(() {
        GooglePlacesModel placesModel =
            new GooglePlacesModel.fromJson(json.decode(responseString));
        _locations = placesModel.predictions;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: new Text(
            'Votre domicile',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
          child: Column(children: <Widget>[
            Center(
                child: Container(
              height: 75.0,
              width: 75.0,
              margin: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(38.0),
                  image: DecorationImage(
                      image: AssetImage("assets/images/home.png"),
                      fit: BoxFit.cover),
                  boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.black)]),
            )),
            SizedBox(
              height: 15.0,
            ),
            Card(
              elevation: 4.0,
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: Container(
                  margin: EdgeInsets.only(
                      top: 2.0, bottom: 2.0, left: 15.0, right: 4.0),
                  child: Column(children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              flex: 0,
                              child: Icon(
                                Icons.home,
                                color: Colors.black,
                              )),
                          Expanded(
                            flex: 1,
                            child: new TextField(
                              controller: _adresse,
                              enabled: true,
                              enableInteractiveSelection: true,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 19.0,
                              ),
                              decoration: new InputDecoration(
                                contentPadding: EdgeInsets.all(12.0),
                                hintText: "Adresse du domicile",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                              ),
                              onChanged: (text) {
                                if (text.isNotEmpty) {
                                  setState(() {
                                    _edite = true;
                                  });
                                  _findLocation(text);
                                } else {
                                  setState(() {
                                    _adresse.text = "";
                                  });
                                }
                              },
                            ),
                          ),
                          _adresse.text.isNotEmpty
                              ? Expanded(
                                  flex: 0,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _adresse.text = "";
                                        _sendDatas = false;
                                      });
                                    },
                                    icon:
                                        Icon(Icons.clear, color: Colors.black),
                                  ),
                                )
                              : Container(),
                        ]),
                  ])),
            ),
            _edite
                ? Expanded(
                    child: ListView.separated(
                    padding: EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                    ),
                    itemCount: _locations.length,
                    itemBuilder: (context, index) {
                      String title = _locations[index].terms[0].value;
                      String subtitle = "";

                      for (int i = 1; i < _locations[index].terms.length; i++) {
                        subtitle = _locations[index].terms[i].value + ", ";
                      }
                      return ListTile(
                        leading: Icon(
                          Icons.location_on,
                          color: Colors.black,
                        ),
                        title: Text(
                          title,
                          style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(subtitle),
                        onTap: () {
//                            Navigator.of(context).pop(_locations[index]);
                          _adresse.text = title;
                          _placeId = _locations[index].place_id;
                          setState(() {
                            _edite = false;
                            _sendDatas = true;
                          });
                          print("onTap Location item index=${index}");
                          print("Destinatiion Selected " +
                              _locations[index].description);
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(height: 1.0,);
                    },
                  ))
                : Container(),
            _sendDatas
                ? Container(margin: EdgeInsets.only(top: 17.0))
                : Container(),
            _sendDatas
                ? Container(
                    margin: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: SizedBox(
                        height: 45.0,
                        width: double.infinity,
                        child: new RaisedButton(
                          color: Colors.black87,
                          child: Text(
                            "ENREGISTRER",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 19.0),
                          ),
                          onPressed: () async {
                            setState(() {
                              _loading = true;
                            });
                            LocationModel position = await _googleMapsServices
                                .getRoutePlaceById(_placeId);

                            setState(() {
                              _home_datas.adresse = _adresse.text;
                              _home_datas.nom = "Mon domicile";
                              _home_datas.longitude = position.lng;
                              _home_datas.latitude = position.lat;
                              _home_datas.place_id = _placeId;
                            });
                            DatabaseHelper()
                                .getHomeAdresse()
                                .then((LocalAdress l) {
                              if (l != null) {
                                print("Home adresse " + l.adresse.toString());
                              } else {
                                DatabaseHelper()
                                    .saveHome(_home_datas)
                                    .then((index) {
                                  AppSharedPreferences().setHomeSave(true);
                                  Navigator.of(context).pop(_home_datas);
                                });
                              }
                            });
                          },
                        )))
                : Container(),
            _loading
                ? Container(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 30.0, bottom: 15.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
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
                  )
                : Container(),
          ]),
        ));
  }
}
