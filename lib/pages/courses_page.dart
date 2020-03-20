import 'package:etakesh_client/DAO/Presenters/CoursesPresenter.dart';
import 'package:etakesh_client/DAO/Rest_dt.dart';
import 'package:etakesh_client/Database/DatabaseHelper.dart';
import 'package:etakesh_client/Models/clients.dart';
import 'package:etakesh_client/Models/commande.dart';
import 'package:etakesh_client/Models/prestataires.dart';
import 'package:etakesh_client/Utils/AppSharedPreferences.dart';
import 'package:etakesh_client/Utils/Loading.dart';
import 'package:etakesh_client/Utils/PriceFormated.dart';
import 'package:etakesh_client/pages/Commande/details_cmd.dart';
import 'package:etakesh_client/pages/Commande/details_cmd_terminees.dart';
import 'package:etakesh_client/pages/Mycolor.dart';
import 'package:etakesh_client/pages/fluttertoast.dart';
import 'package:etakesh_client/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:etakesh_client/pages/Commande/progress_bouton.dart';

class CoursesPage extends StatefulWidget {
  @override
  State createState() => CoursesPageState();
}

class CoursesPageState extends State<CoursesPage> implements CoursesContract {
//class CoursesPage extends StatelessWidget {
  String _token;
  int _stateIndex;
  List<CommandeDetail> _ncmds;
  List<CommandeDetail> _ocmds;
  List<CommandeDetail> _acmds;

  RestDatasource api = new RestDatasource();
  CoursesPresenter _presenter;
  bool _ncourses, _ocourses, _acourses, _enTime, _loading;
  Client1 client;
  DateFormat dateFormat;
  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: true,
    isOverlayTapDismiss: true,
    descStyle: TextStyle(fontSize: 14),
    animationDuration: Duration(milliseconds: 500),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.black,
    ),
  );
  bool reading;
  @override
  void initState() {
    reading = false;
    _ncourses = false;
    _ocourses = false;
    _acourses = false;
    _enTime = true;
    setState(() {
      _loading = false;
    });

    initializeDateFormatting();
    AppSharedPreferences().getToken().then((String token1) {
      if (token1 != '') {
        _token = token1;
        DatabaseHelper().getClient().then((Client1 c) {
          if (c != null) {
            client = c;
            _presenter = new CoursesPresenter(this);
            _presenter.loadCmd(token1, c.client_id);
          }
        });
      }
    }).catchError((err) {
      print("Not get Token " + err.toString());
    });

    AppSharedPreferences().getToken().then((String token1) {
      if (token1 != '') {
        _token = token1;
        DatabaseHelper().getClient().then((Client1 c) {
          if (c != null) {
            api.getNewCmdClient(_token, c.client_id).then((data) {
              if (data != null) {
                setState(() {
                  _ncmds = data;
                });
              }
            });
          }
        });
      }
    }).catchError((err) {
      print("Not get Token " + err.toString());
    });
    _stateIndex = 0;
    super.initState();
  }

  _timeOff() {}
  Future<bool> _onBackPressed() {
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => HomePage()),
        ModalRoute.withName(Navigator.defaultRouteName));
  }

  @override
  Widget build(BuildContext context) {
    switch (_stateIndex) {
      case 0:
        return ShowLoadingView();

      case 2:
        return ShowConnectionErrorView(_onRetryClick);

      default:
        return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: new AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    _onBackPressed();
                  },
                ),
                bottom: TabBar(
                  indicatorColor: Color(0xFF2773A1),
                  tabs: [
                    Tab(
                      child: Text(
                        "A venir",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Annulée",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Terminée",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                title: new Text(
                  'Mes courses',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.black,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              body: TabBarView(
                children: [
                  _ncourses
                      ? ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(0.0),
                          scrollDirection: Axis.vertical,
                          itemCount: _ncmds.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return InkWell(
                                child: Container(child: getItemNew(index)),
                                onTap: () {
                                  print("travail sur les dates");
                                  Navigator.of(context)
                                      .push(new MaterialPageRoute(
                                          builder: (context) => DetailsCmdPage(
                                                commande: _ncmds[index],
                                              )));
                                });
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                        )
                      :

                      ///si on n'a pas encore effectuer une course
                      Center(
                          child: Text("Vous n'avez pas de course planifiée ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.black)),
                        ),
                  _acourses
                      ? ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(0.0),
                          scrollDirection: Axis.vertical,
                          itemCount: _acmds.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return InkWell(
                                child: Container(child: getItemAnn(index)),
                                onTap: () {
                                  print("travail sur les dates");
                                  Navigator.of(context)
                                      .push(new MaterialPageRoute(
                                          builder: (context) => DetailsCmdPage(
                                                commande: _acmds[index],
                                              )));
                                });
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                        )
                      :

                      ///si on n'a pas encore effectuer une course
                      Center(
                          child: Text("Vous n'avez pas de course annulée ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.black)),
                        ),
                  _ocourses
                      ? ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(0.0),
                          scrollDirection: Axis.vertical,
                          itemCount: _ocmds.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return InkWell(
                                child: Container(child: getItemOld(index)),
                                onTap: () {
                                  Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              DetailsCmdTerminePage(
                                                commande: _ocmds[index],
                                              )));
                                });
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                        )
                      :

                      ///si on n'a pas aucune course programmee
                      Center(
                          child: Text(
                              "Vous n'avez pas encore effectué de course",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.black)),
                        )
                ],
              ),
            ));
    }
  }

  Widget getItemAnn(indexItem) {
    DateTime dateCmd =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(_acmds[indexItem].date);
    print("DateTime ");
    print(dateCmd);
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Container(
          color: Color(0x88F9FAFC),
          child: Row(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.symmetric(horizontal: 32.0 - 12.0 / 2),
                child: new Container(
                  height: 12.0,
                  width: 12.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: getStatusCommandValueColor(_acmds[indexItem])),
                ),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      _acmds[indexItem].prestation.service.intitule,
                      style:
                          new TextStyle(fontSize: 18.0, color: Colors.black87),
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    new Text(
                      PriceFormatter.moneyFormat(_acmds[indexItem].montant) +
                          ' XFA',
                      style: new TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Text(
                      DateFormat('EEEE d MMMM y', 'fr_CA').format(dateCmd),
                      style: new TextStyle(
                          fontSize: 12.0, color: Color(0xFF93BFD8)),
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    new Text(
                      " à " + DateFormat.Hm().format(dateCmd) + " min",
                      style: new TextStyle(
                          fontSize: 12.0, color: Color(0xFF93BFD8)),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    new Text(
                      getStatusCommand(_acmds[indexItem]),
                      style: new TextStyle(
                          fontSize: 9.0,
                          color: getStatusCommandValueColor(_acmds[indexItem])),
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          ),
        ));
  }

  Widget getItemNew(indexItem) {
    int endT;
    //  _presenter = new CoursesPresenter(this);
    //      _presenter.loadCmd(_token, client.client_id);

    // String libeler, fax, ;
    DateTime dateCmd =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(_ncmds[indexItem].date);

    DateTime dateEnd =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(_ncmds[indexItem].date);
    print(DateFormat.Hm().format(dateEnd));

    print("min" + DateTime.now().minute.toString());
    int t = int.parse(DateFormat.m().format(dateEnd));
    print(int.parse(DateFormat.m().format(dateEnd)));
    print(t);
    print(dateEnd);
    print("difference:");
    print((DateTime.now()).difference(dateEnd).inMinutes);
    //   endT = int.parse(DateFormat.Hm().format(dateEnd));
    // print(endT);
    //endT=endT+5;
    /*  if(_ncmds[indexItem].is_accepted==true){
       DateTime dateEnd =  DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(_ncmds[indexItem].date);
            endT = int.parse(DateFormat.Hm().format(dateEnd));
            print(endT);
            endT=endT+5;
            
    }*/
    // _enTime=fin(t);
    // print("DateTime ");
    //  print(dateCmd);
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Container(
          color: Color(0x88F9FAFC),
          child: Row(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.symmetric(horizontal: 32.0 - 12.0 / 2),
                child: new Container(
                  height: 12.0,
                  width: 12.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: getStatusCommandValueColor(_ncmds[indexItem])),
                ),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      _ncmds[indexItem].prestation.service.intitule,
                      style:
                          new TextStyle(fontSize: 18.0, color: Colors.black87),
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    new Text(
                      PriceFormatter.moneyFormat(_ncmds[indexItem].montant) +
                          ' XFA',
                      style: new TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
             _enTime?  new Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Text(
                      DateFormat('EEEE d MMMM y', 'fr_CA').format(dateCmd),
                      style: new TextStyle(
                          fontSize: 12.0, color: Color(0xFF93BFD8)),
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    new Text(
                      " à " + DateFormat.Hm().format(dateCmd) + " min",
                      style: new TextStyle(
                          fontSize: 12.0, color: Color(0xFF93BFD8)),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    RaisedButton(
                            color: Colors.red,
                            child: Text(
                              "ANNULER ?",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10.0),
                            ),
                            onPressed: () {
                              annuler(_ncmds, indexItem);
                            })
                       
                  ],
                ),
              )
               : Container(child: CircularProgressIndicator()),
              Divider(),
            ],
          ),
        ));
  }

  void annuler(List<CommandeDetail> ncmds, indexItem) {
    if (_ncmds[indexItem].is_accepted == true) {
      Alert(
        context: context,
        style: alertStyle,
        type: AlertType.warning,
        title: "AVERTISSEMENT!!!",
        desc:
            "Course déja acceptée \n Voulez-vous vraiment annulez cette course? \n",
        /* content: Column(
                                    children: <Widget>[
                                     /* Container(
                                        child: CircularProgressIndicator(),
                                      )*/
                                     /*ProgressBouton(
                                        ncmds: _ncmds,
                                        indexC: indexItem,
                                        token: _token,
                                      ),*/
                                    ],
                                  ),*/
        buttons: [
          DialogButton(
            child: Text(
              "ANNULER",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _enTime = false;
              });
              RestDatasource()
                  .updateCmdStatus1(_ncmds[indexItem], _token)
                  .then((data) {
                if (data != null) {
                  print('commande annuler avec sucess........');
                  print(_ncmds[indexItem].prestation.prestataireId.toString());
                  print(data.status);

                  print(
                      "prestatairesId ......." + data.prestataireId.toString());
                  String prestataireId =
                      _ncmds[indexItem].prestation.prestataireId.toString();

                  api
                      .getPrestataires1(_token, prestataireId)
                      .then((List<PrestataireOnline> prestataires) {
                    if (prestataires != null) {
                      print("fababy........");
                      api
                          .updatPresta(prestataires[0], "false", _token)
                          .then((donnee) {
                        if (donnee != null) {
                          setState(() {
                            _enTime = true;
                          });
                          setState(() {
                            _ncmds.removeAt(indexItem);
                          });
                          //_presenter.loadCmd(_token, client.client_id);
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  'cette opération a échouer veillez recommencer..',
                              backgroundColor: MyColors.colorRouge,
                              textColor: Colors.white,
                              timeInSecForIos: 5);
                        }
                      });
                    }
                  });
                  print("cmd update");
                }
              });
            },
            color: Colors.red,
          ),
        ],
      ).show();
    }
    if (_ncmds[indexItem].is_accepted == false) {
      Alert(
        context: context,
        style: alertStyle,
        type: AlertType.warning,
        title: "AVERTISSEMENT!!!",
        desc:
            "Course en attente d'aceptation.. \n Voulez-vous vraiment annulez cette course? \n",
        /* content: Column(
                                    children: <Widget>[
                                     /* Container(
                                        child: CircularProgressIndicator(),
                                      )*/
                                     /*ProgressBouton(
                                        ncmds: _ncmds,
                                        indexC: indexItem,
                                        token: _token,
                                      ),*/
                                    ],
                                  ),*/
        buttons: [
          DialogButton(
            child: Text(
              "ANNULER",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _enTime = false;
              });

              RestDatasource()
                  .updateCmdStatus1(_ncmds[indexItem], _token)
                  .then((data) {
                if (data != null) {
                  print('commande annuler avec sucess........');
                  print(_ncmds[indexItem].prestation.prestataireId.toString());
                  print(data.status);

                  print(
                      "prestatairesId ......." + data.prestataireId.toString());
                  String prestataireId =
                      _ncmds[indexItem].prestation.prestataireId.toString();

                  api
                      .getPrestataires1(_token, prestataireId)
                      .then((List<PrestataireOnline> prestataires) {
                    if (prestataires != null) {
                      print("fababy........");
                      api
                          .updatPresta(prestataires[0], "false", _token)
                          .then((donnee) {
                        if (donnee != null) {
                          setState(() {
                            _enTime = true;
                          });
                          setState(() {
                            _ncmds.removeAt(indexItem);
                          });
                          // _presenter.loadCmd(_token,
                          //   client.client_id);
                          //  Navigator.of(context).pop();
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  'cette opération a échouer veillez recommencer..',
                              backgroundColor: MyColors.colorRouge,
                              textColor: Colors.white,
                              timeInSecForIos: 5);
                        }
                      });
                    }
                  });

                  print("cmd update");
                }
              });

              // Navigator.of(context).pop();
            },
            color: Colors.red,
          ),
        ],

        //                             ProgressBouton(),
      ).show();
      /*  Alert(
                                  context: context,
                                  style: alertStyle,
                                  type: AlertType.warning,
                                  title: "AVERTISSEMENT!!!",
                                  desc:
                                      "Cette course est en attente d'acceptation... \n Voulez-vous vraiment annulez cette course? \n",
                                  buttons: [],
                                  content: Column(
                                    children: <Widget>[
                                      ProgressBouton(
                                        ncmds: _ncmds,
                                        indexC: indexItem,
                                        token: _token,
                                      ),
                                    ],
                                  ),
                                ).show();*/

    }
  }

  Widget getItemOld(indexItem) {
    DateTime dateCmdo =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(_ocmds[indexItem].date);
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Container(
          color: Color(0x88F9FAFC),
          child: Row(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.symmetric(horizontal: 32.0 - 12.0 / 2),
                child: new Container(
                  height: 12.0,
                  width: 12.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: getStatusCommandValueColor(_ocmds[indexItem]),
                  ),
                ),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      _ocmds[indexItem].prestation.service.intitule,
                      style:
                          new TextStyle(fontSize: 18.0, color: Colors.black87),
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    new Text(
                      PriceFormatter.moneyFormat(_ocmds[indexItem].montant) +
                          ' XFA',
                      style: new TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Text(
                      DateFormat('EEEE d MMMM y', 'fr_CA').format(dateCmdo),
                      style: new TextStyle(
                          fontSize: 12.0, color: Color(0xFF93BFD8)),
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    new Text(
                      " à " + DateFormat.Hm().format(dateCmdo) + " min",
                      style: new TextStyle(
                          fontSize: 12.0, color: Color(0xFF93BFD8)),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    new Text(
                      getStatusCommand(_ocmds[indexItem]),
                      style: new TextStyle(
                          fontSize: 9.0,
                          color: getStatusCommandValueColor(_ocmds[indexItem])),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _onRetryClick() {
    setState(() {
      _stateIndex = 0;
      _presenter.loadCmd(_token, client.client_id);
    });
  }

  ///soucis de connexion internet
  @override
  void onConnectionError() {
    setState(() {
      _stateIndex = 2;
    });
  }

  ///en cas de soucis
  @override
  void onLoadingError() {
    setState(() {
      _stateIndex = 1;
    });
  }

  ///si tout ce passe bien
  @override
  void onLoadingSuccess(List<CommandeDetail> ncmds, List<CommandeDetail> ocmds,
      List<CommandeDetail> acmds) {
    setState(() {
      _stateIndex = 3;
    });
    if (ncmds.length != 0)
      setState(() {
        _ncourses = true;
        this._ncmds = ncmds.reversed.toList();
      });
    if (ocmds.length != 0)
      setState(() {
        _ocourses = true;
        this._ocmds = ocmds.reversed.toList();
      });

    if (acmds.length != 0)
      setState(() {
        _acourses = true;
        this._acmds = acmds.reversed.toList();
      });
  }

  String getStatusCommand(CommandeDetail cmd) {
    if (cmd.is_created == true &&
        cmd.is_accepted == false &&
        cmd.is_refused == false &&
        cmd.status == "CREATED") return "Commande en attente";
    if (cmd.is_accepted == true &&
        cmd.is_created == true &&
        cmd.is_refused == false &&
        cmd.status == "CREATED") return "Commande validée";
    if (cmd.is_refused == true &&
        cmd.is_created == true &&
        cmd.is_accepted == false) return "Commande refusée";
    if (cmd.is_terminated == true && cmd.status == "TERMINATED")
      return "Commande terminée";
    if (cmd.is_terminated == true &&
        cmd.status == "ANNULER" &&
        cmd.is_accepted == true) return "Commande annulée";
    if (cmd.is_terminated == true &&
        cmd.status == "ANNULER" &&
        cmd.is_accepted == false) return "Commande annulée";
  }

  Color getStatusCommandValueColor(CommandeDetail cmd) {
    if (cmd.is_created == true &&
        cmd.is_accepted == false &&
        cmd.is_refused == false &&
        cmd.status != "ANNULER") return Color(0xFFDEAC17);
    if (cmd.is_accepted == true &&
        cmd.is_created == true &&
        cmd.is_refused == false &&
        cmd.status != "ANNULER") return Color(0xFF0C60A8);
    if (cmd.is_refused == true &&
        cmd.is_created == true &&
        cmd.is_accepted == false) return Color(0xFFC72230);
    if (cmd.is_terminated == true &&
        cmd.is_created == true &&
        cmd.status != "ANNULER") return Color(0xFF33B841);
    if (cmd.is_terminated == true && cmd.status == "ANNULER")
      return Color(0xFFff0000);
  }
}
