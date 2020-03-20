import 'package:flutter/material.dart';

class ConfidentialitePage extends StatefulWidget {
  @override
  State createState() => ConfidentialitePageState();
}

class ConfidentialitePageState extends State<ConfidentialitePage> {
  @override
  void initState() {
    super.initState();
  }

  _verticalD() => Container(
        margin: EdgeInsets.only(left: 10.0, right: 0.0, top: 0.0, bottom: 0.0),
      );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle =
        theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Notre confidentialité',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
                child: Card(
                    child: Container(
                  padding: EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.lock_outline, color: Colors.black54),
                          Container(
                            margin: EdgeInsets.only(left: 5.0),
                          ),
                          Text(
                            'Politique de confidentialite',
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
              ),
              Container(
                height: 50.0,
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 7.0),
                child: new Row(
                  children: <Widget>[
                    _verticalD(),
                    new Text(
                      'Informations sur Takesh',
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Text(
                  "À cette étape, vous devez préciser le nom et les coordonnées, non seulement de votre organisme ou de votre entreprise, mais également de la personne responsable de la protection des renseignements personnels au sein de votre organisme ou de votre entreprise.",
                  style: dialogTextStyle,
                ),
              ),
              Container(
                height: 50.0,
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 7.0),
                child: new Row(
                  children: <Widget>[
                    _verticalD(),
                    new Text(
                      'Engagements de Takesh',
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "À cette étape, vous devez préciser – de façon générale – les engagements de votre organisme ou de votre entreprise en ce qui a trait à la protection des renseignements personnels.",
                    style: dialogTextStyle,
                  )),
              Container(
                height: 50.0,
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 7.0),
                child: new Row(
                  children: <Widget>[
                    _verticalD(),
                    new Text(
                      'Complémentaires sur Takesh',
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "À cette étape, vous devez documenter – de façon spécifique – les engagements de votre organisme ou de votre entreprise en ce qui a trait à la protection des renseignements personnels.",
                    style: dialogTextStyle,
                  )),
              Container(
                margin: EdgeInsets.only(top: 15.0),
              ),
              Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                child: Card(
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.assignment, color: Colors.black54),
                        Container(
                          margin: EdgeInsets.only(left: 5.0),
                        ),
                        Text(
                          "Termes d'utilisations de Takesh",
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 50.0,
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 7.0),
                child: new Row(
                  children: <Widget>[
                    _verticalD(),
                    new Text(
                      'Utilisation du la plateforme',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Vous ne pouvez utiliser le Site que si vous êtes âgé d'au moins 18 ans et que vous pouvez passer un contrat irrévocable (ce Site est réservé aux personnes majeures). En utilisant ce Site, vous déclarez être âgé d'au moins 18 ans. Tout le contenu publié sur ce Site est fourni à des fins d'information uniquement. Certains des supports et des informations de ce Site sont fournis par les franchisés qui conservent le contrôle des politiques et procédures en vigueur dans leur établissement.",
                    style: dialogTextStyle,
                  )),
              Container(
                height: 50.0,
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 7.0),
                child: new Row(
                  children: <Widget>[
                    _verticalD(),
                    new Text(
                      "Restrictions d'utilisation",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Il est interdit, sans l'autorisation écrite de Radisson Hospitality, de faire des copies « miroir » de toute partie du Contenu de ce Site ou de tout autre serveur. Il est interdit d'utiliser le Site dans un but illégal ou interdit par les présentes Conditions générales. Il est interdit d'utiliser le Site d'une manière pouvant endommager, désactiver, surcharger ou détériorer le Site, ou interférer avec l'utilisation et la jouissance du Site par un tiers. Il est interdit de tenter d'obtenir un accès non autorisé au Site en le piratant, en récupérant illicitement des mots de passe ou par d'autres moyens. Radisson Hospitality se réserve le droit, à sa seule discrétion, de résilier votre accès au Site, en totalité ou en partie, à tout moment, avec ou sans motif, sans préavis.",
                    style: dialogTextStyle,
                  )),
              Container(
                margin: EdgeInsets.only(top: 15.0),
              ),
              Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                child: Card(
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.security, color: Colors.black54),
                        Container(
                          margin: EdgeInsets.only(left: 5.0),
                        ),
                        Text(
                          'Protection de vos données',
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 50.0,
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 7.0),
                child: new Row(
                  children: <Widget>[
                    _verticalD(),
                    new Text(
                      "Vos informations",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Vous trouverez ci-après notre politique en matière de traitement des données personnelles (les « Données »)La présente Politique a pour but de renforcer votre information dans le cadre de notre engagement quant à la protection de vos Données, que vous soyez client, partenaire, fournisseur, actionnaire ou, plus généralement, contact des sociétés du Groupe Takesh.",
                    style: dialogTextStyle,
                  )),
              Container(
                height: 50.0,
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 7.0),
                child: new Row(
                  children: <Widget>[
                    _verticalD(),
                    new Text(
                      "Votre localisation",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Cette politique s’inscrit dans une démarche de transparence et de loyauté, décrit comment nous collectons, utilisons et gérons vos données à caractère personnel, et décrit vos droits ainsi que la manière dont nous nous conformons à nos obligations légales.Elle complète l’information que nous délivrons notamment dans les contrats conclus avec vous et, en cas de contradiction entre les dispositions de la présente politique et des stipulations contractuelles, ces dernières prévaudront",
                    style: dialogTextStyle,
                  )),
              Container(
                margin: EdgeInsets.only(top: 30.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
