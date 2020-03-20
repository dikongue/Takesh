import 'dart:convert';

import 'package:etakesh_client/DAO/Rest_dt.dart';
import 'package:etakesh_client/Database/DatabaseHelper.dart';
import 'package:etakesh_client/Models/clients.dart';
import 'package:etakesh_client/Models/google_place_item.dart';
import 'package:etakesh_client/Models/google_place_model.dart';
import 'package:etakesh_client/Utils/AppSharedPreferences.dart';
import 'package:flutter/material.dart';

class DestinationPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  DestinationPage({Key key, this.latitude, this.longitude}) : super(key: key);
  @override
  DestinationPageState createState() => new DestinationPageState();
}

class DestinationPageState extends State<DestinationPage> {
  TextEditingController _searchDestination;
  TextEditingController _searchPosition;
  RestDatasource api = new RestDatasource();
  var _locations = new List<GooglePlacesItem>();
  AutoCompleteModel adress;
  LocalAdress _homeAdresse, _officeAdresse;
  bool _isOfficeSave = false;
  bool _isHomeSave = false;
  @override
  initState() {
    super.initState();
    adress = new AutoCompleteModel();
    _searchDestination = new TextEditingController();
    _searchPosition = new TextEditingController();
    AppSharedPreferences().isOfficeSave().then((bool office) {
      if (office == true) {
        DatabaseHelper().getOfficeAdresse().then((LocalAdress l) {
          setState(() {
            _isOfficeSave = true;
            _officeAdresse = l;
          });
        });
      }
    });

    AppSharedPreferences().isHomeSave().then((bool home) {
      if (home == true) {
        DatabaseHelper().getHomeAdresse().then((LocalAdress l) {
          setState(() {
            _isHomeSave = true;
            _homeAdresse = l;
          });
        });
      }
    });
  }

  _findLocation(String input) {
    api
        .findLocation(input, "fr", widget.latitude, widget.longitude)
        .then((response) {
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
      body: Container(
        margin: EdgeInsets.only(top: 14.0),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 4.0,
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: Container(
                  margin: EdgeInsets.only(
                      top: 2.0, bottom: 2.0, left: 4.0, right: 4.0),
                  child: Column(children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 0,
                            child: IconButton(
                              onPressed: () {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ]),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Container(
                            height: 5.0,
                            width: 5.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF0C60A8)),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: new TextField(
                            controller: _searchDestination,
                            enabled: true,
                            autofocus: true,
                            enableInteractiveSelection: true,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                            ),
                            decoration: new InputDecoration(
                              contentPadding: EdgeInsets.all(12.0),
                              hintText: "Où allez-vous ?",
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
                                  _isHomeSave=false;
                                  _isOfficeSave=false;
                                });
                                _findLocation(text);
                                return;
                              } else {
                                setState(() {
                                  _searchDestination.text = "";
                                });
                              }
                            },
                          ),
                        ),
                        _searchDestination.text.isNotEmpty
                            ? Expanded(
                                flex: 0,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _searchDestination.text = "";
                                    });
                                  },
                                  icon: Icon(Icons.clear, color: Colors.black),
                                ),
                              )
                            : Container(),
                      ],
                    ),

                    ///ou allez vous ?

                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Container(
                            height: 5.0,
                            width: 5.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFDEAC17)),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: new TextField(
                            enabled: false,
                            enableInteractiveSelection: true,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                            ),
                            decoration: new InputDecoration(
                              contentPadding: EdgeInsets.all(12.0),
                              hintText: "Où etes-vous ?",
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
                                  _isHomeSave=false;
                                  _isOfficeSave=false;
                                });
                                _findLocation(text);
                              

                                return;
                              } else {
                                setState(() {
                                  _searchPosition.text = "";
                                });
                              }
                            },
                          ),
                        ),
                        _searchPosition.text.isNotEmpty
                            ? Expanded(
                                flex: 0,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _searchPosition.text = "";
                                    });
                                  },
                                  icon: Icon(Icons.clear, color: Colors.black),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ])),
            ),
            _isHomeSave || _isOfficeSave ? Container(
                width: MediaQuery.of(context).size.width,
                height: 63.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                   _isHomeSave ? Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _isOfficeSave ? Colors.black:Colors.transparent,
                            width: 2.0,
                          ),
                          right: BorderSide(
                            color: _isOfficeSave ? Colors.black:Colors.transparent,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child:ListTile(
                              leading: Icon(
                                Icons.home,
                                color: Colors.black,
                              ),
                              title: Text(
                                _homeAdresse.nom,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.black),
                              ),
                              subtitle: Text(_homeAdresse.adresse),
                              onTap: () {
                                setState(() {
                                  adress.adresse = _homeAdresse.adresse;
                                  adress.place_id = _homeAdresse.place_id;
                                  adress.nom = _homeAdresse.nom;
                                });
                                Navigator.of(context).pop(adress);
                                // Navigator.of(context).pop(_locations[index]);
                              },
                            )
                    ):Container(),
                   _isOfficeSave ? Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _isHomeSave ? Colors.black : Colors.transparent,
                            width: 2.0,
                          ),
                          left: BorderSide(
                            color: _isHomeSave ? Colors.black : Colors.transparent ,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: ListTile(
                              leading: Icon(
                                Icons.business_center,
                                color: Colors.black,
                              ),
                              title: Text(
                                _officeAdresse.nom,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.black),
                              ),
                              subtitle: Text(_officeAdresse.adresse),
                              onTap: () {
                                setState(() {
                                  adress.adresse = _officeAdresse.adresse;
                                  adress.place_id = _officeAdresse.place_id;
                                  adress.nom = _officeAdresse.nom;
                                });
                                Navigator.of(context).pop(adress);
                                // Navigator.of(context).pop(_locations[index]);
                              },
                            ),
                    ):Container()
                  ],
                )): Container(),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(right: 8.0, left: 8.0),
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
                      setState(() {
                        adress.adresse = _locations[index].terms[0].value;
                        adress.place_id = _locations[index].place_id;
                        adress.nom = _locations[index].description;
                      });
                      Navigator.of(context).pop(adress);
                      // Navigator.of(context).pop(_locations[index]);
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
