import 'package:etakesh_client/Models/commande.dart';
import 'package:etakesh_client/Utils/AppSharedPreferences.dart';
import 'package:etakesh_client/Utils/PriceFormated.dart';
import 'package:etakesh_client/Utils/Scan_qr_code.dart';
import 'package:etakesh_client/pages/Commande/tracking_prestataire.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailsCmdPage extends StatefulWidget {
  final CommandeDetail commande;
  DetailsCmdPage({Key key, this.commande}) : super(key: key);
  @override
  _DetailsCmdPageState createState() => _DetailsCmdPageState();
}

class _DetailsCmdPageState extends State<DetailsCmdPage> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  DateTime _dateCmd;
  String _token;
  @override
  void initState() {
    super.initState();
    AppSharedPreferences().getToken().then((String token) {
      setState(() {
         _token = token;
      });
    });
    initializeDateFormatting();
    _dateCmd = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(widget.commande.date);
  }

  Widget _snackCmdAtt() => SnackBar(
        content: Text(
          "Votre commande n'a pas encore été acceptée !!!",
          style: TextStyle(
            color: Color(0xFFDEAC17),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        action: SnackBarAction(
          label: "OK",
          textColor: Color(0xFF0C60A8),
          onPressed: () {
            print("Cmd son acceptee");
          },
        ),
        backgroundColor: Colors.white,
        duration: Duration(milliseconds: 5000),
      );

      Widget _snackCmdAnul() => SnackBar(
        content: Text(
          "Votre commande a été annulée !!!",
          style: TextStyle(
            color: Colors.red,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        action: SnackBarAction(
          label: "OK",
          textColor: Color(0xFF0C60A8),
          onPressed: () {
            print("Cmd son acceptee");
          },
        ),
        backgroundColor: Colors.white,
        duration: Duration(milliseconds: 5000),
      );

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Commande N° " + widget.commande.code,
            style: TextStyle(color: Colors.white, fontSize: 16.0)),
        
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              SizedBox(height: 10.0),
              Stack(
                 children: <Widget>[
                  Center(
                      child: ClipRRect(
                              borderRadius: BorderRadius.circular(90.0),
                              child: new CachedNetworkImage(
                                imageUrl: widget.commande.prestation.vehicule.image+"?access_token="+_token,
                                height: 170.0,
                                width: 170.0,
                                fit: BoxFit.cover,
                                placeholder:(context, url) =>
                                Center(child: CircularProgressIndicator()),
                                 errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                              ),
                            )
                  ),
                  Positioned(
                    bottom: 107.0,
                    right: 95.0,
                    child: ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: new CachedNetworkImage(
                                imageUrl: widget.commande.prestation.prestataire.image+"?access_token="+_token,
                                height: 60.0,
                                width: 60.0,
                                fit: BoxFit.cover,
                                placeholder:(context, url) =>
                                Center(child: CircularProgressIndicator()),
                                 errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                              ),
                            ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Center(
                child: Text(
                  "Mr " + widget.commande.prestation.prestataire.nom,
                  style: TextStyle(color: Colors.black, fontSize: 20.0),
                ),
              ),
              SizedBox(height: 5.0),
              Center(
                child: Text(
                  "Service : " + widget.commande.prestation.service.intitule,
                  style: TextStyle(color: Colors.black87, fontSize: 20.0),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              
                                child: new Container(
                                  width: double.infinity,
                                  height: 40.0,
                                  child: Center(
                                  child: Text(
                                        widget.commande.position_prise_en_charge,
                                        style: TextStyle(fontSize: 17.0),),
                                  ),
                                ),
                             
                            ),
                           
                            new Positioned(
                              top: 5.0,
                              left: 17.0,
                              child: new Container(
                                height: 35.0,
                                width: 35.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: new Container(
                                  child: new Center(
                                    child: Text('1',
                                    style: TextStyle(color: Colors.white, fontSize: 12.0),),
                                  ),
                                  margin: new EdgeInsets.all(5.0),
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue),
                                ),
                              ),
                            )
                          ],
                        ),
                        Stack(
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.only(left: 10.0),                
                                child: new Container(
                                  width: double.infinity,
                                  height: 40.0,
                                  child: Center(
                                  child: Text(
                                       widget.commande.position_destination,
                                        style: TextStyle(fontSize: 17.0),),
                                  ),
                                ),
                             
                            ),
                            
                            new Positioned(
                              top: 5.0,
                              left: 17.0,
                              child: new Container(
                                height: 35.0,
                                width: 35.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: new Container(
                                  child: new Center(
                                    child: Text('2',
                                    style: TextStyle(color: Colors.white, fontSize: 12.0),),
                                  ),
                                  margin: new EdgeInsets.all(5.0),
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFDEAC17)),
                                ),
                              ),
                            )
                          ],
                        ),
                  // ListTile(
                  //   contentPadding: EdgeInsets.only(bottom: 0.0,top: 0.0),
                  //   title: Text(widget.commande.position_prise_en_charge),
                  //   leading: Padding(
                  //     padding:
                  //         new EdgeInsets.symmetric(horizontal: 32.0 - 12.0 / 2),
                  //     child: new Container(
                  //       height: 10.0,
                  //       width: 10.0,
                  //       decoration: new BoxDecoration(
                  //           shape: BoxShape.circle, color: Colors.blue),
                  //     ),
                  //   ),
                  // ),
                  // ListTile(
                  //   contentPadding: EdgeInsets.only(bottom: 0.0,top: 0.0),
                  //   title: Text(widget.commande.position_destination),
                  //   leading: Padding(
                  //     padding:
                  //         new EdgeInsets.symmetric(horizontal: 32.0 - 12.0 / 2),
                  //     child: new Container(
                  //       height: 10.0,
                  //       width: 10.0,
                  //       decoration: new BoxDecoration(
                  //           shape: BoxShape.circle, color: Color(0xFFDEAC17)),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 25.0, right: 25.0, bottom: 5.0),
                    decoration: new BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: getStatusCommandValueColor(widget.commande)),
                    child: ListTile(
                      title: Text(getStatusCommand((widget.commande)),
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text(
                          DateFormat('EEEE d MMMM y','fr_CA').format(_dateCmd) +
                              " à " +
                              DateFormat.Hm().format(_dateCmd) +
                              " min",
                          style: TextStyle(color: Colors.white)),
                      trailing: Text(
                          PriceFormatter.moneyFormat(widget.commande.prestation.service.prix) +
                              " XAF",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.0)),
                    ),
                  ),
                  //tracking
                   Container(
                 width: MediaQuery.of(context).size.width -50.0,
                 margin: EdgeInsets.only(bottom: 5.0),
                    decoration: new BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: widget.commande.is_accepted
                            ? Colors.green
                            : Colors.grey),
                    child: widget.commande.is_accepted ?
                     RaisedButton(
                              color: Colors.green,
                              child: Text(" TRACKING ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0)),
                              padding: EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              onPressed: () {
                                if (widget.commande.is_accepted == true) {
                                  Navigator.of(context)
                                      .push(new MaterialPageRoute(
                                          builder: (context) => TrackingPage(
                                                commande: widget.commande,
                                              )));
                                }
                              }):
                              RaisedButton(
                        color: widget.commande.is_accepted
                            ? Colors.green
                            : Colors.grey,
                        child: Text(" TRACKING ",
                            style: TextStyle(
                                color: widget.commande.is_accepted
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 20.0)),
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                        onPressed: () {
                          if (widget.commande.is_accepted == true) {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) => TrackingPage(
                                      commande: widget.commande,
                                    )));
                          } else if(widget.commande.is_refused == true){
                            final bar = _snackCmdAnul();
                            _key.currentState.showSnackBar(bar);
                          } else{
                            final bar = _snackCmdAtt();
                            _key.currentState.showSnackBar(bar);
                          }
                        }),
                  ),
                  // QR Scan
                  widget.commande.is_accepted? Container(
                    width: MediaQuery.of(context).size.width -50.0,
                    
                    decoration: new BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Color(0xFF0C60A8)),
                    child: RaisedButton(
                      color: Color(0xFF0C60A8),
                              child: Text(" QR-CODE SCAN ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0)),
                              padding: EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => ScanScreen()),
                                );
                              }),
                  ):Text(""),
                ],
              ),
              // Padding(
              //   padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 50),
              //   child: widget.commande.is_accepted
              //       ? Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: <Widget>[
              //             RaisedButton(
              //                 color: Colors.green,
              //                 child: Text(" TRACKING ",
              //                     style: TextStyle(
              //                         color: Colors.white, fontSize: 20.0)),
              //                 padding: EdgeInsets.only(
              //                     left: 15.0,
              //                     right: 15.0,
              //                     top: 10.0,
              //                     bottom: 10.0),
              //                 onPressed: () {
              //                   if (widget.commande.is_accepted == true) {
              //                     Navigator.of(context)
              //                         .push(new MaterialPageRoute(
              //                             builder: (context) => TrackingPage(
              //                                   commande: widget.commande,
              //                                 )));
              //                   }
              //                 }),
              //             RaisedButton(
              //                 color: Color(0xFF0C60A8),
              //                 child: Text(" QR-CODE SCAN ",
              //                     style: TextStyle(
              //                         color: Colors.white, fontSize: 20.0)),
              //                 padding: EdgeInsets.only(
              //                     left: 15.0,
              //                     right: 15.0,
              //                     top: 10.0,
              //                     bottom: 10.0),
              //                 onPressed: () {
              //                   Navigator.push(
              //                     context,
              //                     new MaterialPageRoute(
              //                         builder: (context) => ScanScreen()),
              //                   );
              //                 })
              //           ],
              //         )
              //       : RaisedButton(
              //           color: widget.commande.is_accepted
              //               ? Colors.green
              //               : Colors.grey,
              //           child: Text(" TRACKING ",
              //               style: TextStyle(
              //                   color: widget.commande.is_accepted
              //                       ? Colors.white
              //                       : Colors.black,
              //                   fontSize: 20.0)),
              //           padding: EdgeInsets.only(
              //               left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
              //           onPressed: () {
              //             if (widget.commande.is_accepted == true) {
              //               Navigator.of(context).push(new MaterialPageRoute(
              //                   builder: (context) => TrackingPage(
              //                         commande: widget.commande,
              //                       )));
              //             } else if(widget.commande.is_refused == true){
              //               final bar = _snackCmdAnul();
              //               _key.currentState.showSnackBar(bar);
              //             } else{
              //               final bar = _snackCmdAtt();
              //               _key.currentState.showSnackBar(bar);
              //             }
              //           }),
              // )
            ],
          )
        ],
      ),
    );
  }

  String getStatusCommand(CommandeDetail cmd) {

    if (cmd.is_created == true &&
        cmd.is_accepted == false &&
        cmd.is_refused == false &&
        cmd.status == "CREATED" ) return "Commande en attente";
    if (cmd.is_accepted == true &&
        cmd.is_created == true &&
        cmd.is_refused == false
        && cmd.status == "READ") return "Commande validée";
    if (cmd.is_refused == true &&
        cmd.is_created == true &&
        cmd.is_accepted == false) return "Commande refusée";
    if (cmd.is_terminated == true && cmd.status == "TERMINATED")
      return "Commande terminée";
      if (cmd.is_terminated == true && cmd.status == "ANNULER")
      return "Commande annulée";
  }

  Color getStatusCommandValueColor(CommandeDetail cmd) {
    if (cmd.is_created == true &&
        cmd.is_accepted == false &&
        cmd.is_refused == false) return Color(0xFFDEAC17);
    if (cmd.is_accepted == true &&
        cmd.is_created == true &&
        cmd.is_refused == false) return Color(0xFF0C60A8);
    if (cmd.is_refused == true &&
        cmd.is_created == true &&
        cmd.is_accepted == false&&cmd.status=="ANNULER") return Color(0xFFC72230);
    if (cmd.is_terminated == true && cmd.status == "TERMINETED")
      return Color(0xFF33B841);
  }
}
