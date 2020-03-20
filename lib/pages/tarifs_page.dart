import 'package:etakesh_client/DAO/Presenters/ServicePresenter.dart';
import 'package:etakesh_client/Models/services.dart';
import 'package:etakesh_client/Utils/AppSharedPreferences.dart';
import 'package:etakesh_client/Utils/Loading.dart';
import 'package:etakesh_client/Utils/PriceFormated.dart';
import 'package:flutter/material.dart';

class TarifsPage extends StatefulWidget {
  @override
  State createState() => TarifsPageState();
}

class TarifsPageState extends State<TarifsPage> implements ServiceContract {
  int stateIndex;
  List<CategorieService> services;
  ServicePresenter _presenter;
  String token;
  @override
  void initState() {
    AppSharedPreferences().getToken().then((String token1) {
      if (token1 != '') {
        token = token1;
        _presenter = new ServicePresenter(this);
        _presenter.loadServices(token1);
      }
    }).catchError((err) {
      print("Not get Token " + err.toString());
    });
    stateIndex = 0;
    super.initState();
  }

  BoxDecoration boxDecorationHeader() {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          //
          color: Colors.black87,
          width: 2.0,
        ),
      ),
    );
  }

  BoxDecoration boxDecorationSubHeader() {
    return BoxDecoration(
      border: Border(
        top: BorderSide(
          //
          color: Colors.black45,
          width: 1.0,
        ),
      ),
    );
  }

  Widget header() {
    return Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Container(
            child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: new EdgeInsets.only(left: 16.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        "Services",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: new EdgeInsets.only(left: 22.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        "Yaoundé",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 36.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        "Douala",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    Card getItem(indexItem) {
      return Card(
          elevation: 3.0,
          child: Column(
            children: <Widget>[
              Container(
                height: 25.0,
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 15.0, top: 10.0, right: 10.0),
                decoration: boxDecorationHeader(),

                child: Text(
                  services[indexItem].code,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
              ),
              header(),

              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(0.0),
                  scrollDirection: Axis.vertical,
                  itemCount: services[indexItem].service.length,

                  itemBuilder: (BuildContext ctxt, int index2) {
                    return Padding(

                        padding: EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 10.0),
                        child: Container(
                          decoration: boxDecorationSubHeader(),
                          margin: EdgeInsets.only(left: 5.0),
                          /*

                           uniquement les taxis qui font soit depôt, course, aéroport........
                           */
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: <Widget>[
                              new Padding(
                                padding: new EdgeInsets.only(left: 5.0),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: <Widget>[
                                    new Text(
                                        services[indexItem]
                                            .service[index2]
                                            .intitule,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w400)),
                                    new Text(
                                      services[indexItem]
                                            .service[index2]
                                            .temps,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              ),
                              new Padding(
                                padding: new EdgeInsets.only(left: 1.0),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(

                                      PriceFormatter.moneyFormat(services[indexItem]
                                              .service[index2]
                                              .prix_yaounde) +
                                          " XAF",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(
                                      PriceFormatter.moneyFormat(services[indexItem]
                                              .service[index2]
                                              .prix_douala)+
                                          " XAF",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ));
                  })
            ],
          ));
    }

    switch (stateIndex) {
      case 0:
        return ShowLoadingView();

      case 2:
        return ShowConnectionErrorView(_onRetryClick);

      default:
        return new Scaffold(
            appBar: new AppBar(
              title: new Text(
                'Tarifs des services',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: Stack(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 10.0),
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0.0),
                        scrollDirection: Axis.vertical,
                        itemCount: services.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return getItem(index);
                        }),
                        ),
              ],
            ));
    }
  }

  ///relance le service en cas d'echec de connexion internet
  void _onRetryClick() {
    setState(() {
      stateIndex = 0;
      _presenter.loadServices(token);
    });
  }

  ///soucis de connexion internet
  @override
  void onConnectionError() {
    setState(() {
      stateIndex = 2;
    });
  }

  ///en cas de soucis
  @override
  void onLoadingError() {
    setState(() {
      stateIndex = 1;
    });
  }

  ///si tout ce passe bien
  @override
  void onLoadingSuccess(List<CategorieService> services) {
    setState(() {
      this.services = services;
      stateIndex = 3;
    });
  }
}
