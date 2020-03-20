class Client {
  int _client_id;
  int _user_id;
  String _email;
  String _username;
  String _lastname;
  String _phone;
  String _date_naissance;
  String _pays;
  String _ville;
  String _adresse;

  // List<String> _roles;

  Client.empty() {
    this._username = null;
    this._lastname = null;
    this._email = null;
    this._phone = null;
    this._date_naissance = null;
    this._pays = null;
    this._ville = null;
    this._adresse = null;
  }

  Client(this._client_id, this._username, this._lastname, this._email,
      this._phone);

  Client.map(dynamic obj) {
    this._client_id = obj["clientid"];
    this._username = obj["nom"];
    this._lastname = obj["prenom"];
    this._email = obj["email"];
    this._phone = obj["telephone"];
    this._date_naissance = obj["date_naissance"];
    this._ville = obj["ville"];
    this._pays = obj["pays"];
    this._adresse = obj["adresse"];
  }

  int get id_client => _client_id;
  int get user_id => _user_id;
  String get username => _username;
  String get lastname => _lastname;
  String get email => _email;
  String get phone => _phone;
  String get date_naissance => _date_naissance;
  String get ville => _ville;
  String get pays => _pays;
  String get adresse => _adresse;

  //List<String> get roles => _roles;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["client_id"] = _client_id;
    map["nom"] = _username;
    map["prenom"] = lastname;
    map["telephone"] = _phone;
    map["email"] = _email;
    map["date_naissance"] = _date_naissance;
    map["ville"] = _ville;
    map["pays"] = _pays;
    map["adresse"] = _adresse;
    return map;
  }

  set phone(String value) {
    _phone = value;
  }

  set id_client(int value) {
    _client_id = value;
  }

  set email(String value) {
    _email = value;
  }

  set lastname(String value) {
    _lastname = value;
  }

  set username(String value) {
    _username = value;
  }

  set user_id(int value) {
    _user_id = value;
  }

  set date_naissance(String value) {
    _date_naissance = value;
  }

  set ville(String value) {
    _ville = value;
  }

  set pays(String value) {
    _pays = value;
  }

  set adresse(String value) {
    _adresse = value;
  }

  @override
  String toString() {
    return 'Client{_client_id: $_client_id, _email: $_email, _user_id: $_user_id, _username: $_username, _lastname: $_lastname, _phone: $_phone, _date_naissance: $_date_naissance, _ville: $_ville, _pays: $_pays, _adresse: $_adresse}';
  }
}

class Client1 {
  int client_id;
  int user_id;
  String email;
  String nom;
  String prenom;
  String phone;
  String date_naissance;
  String pays;
  String ville;

  String date_creation;
  String image;
  String code;
  String status;
  String positionId;
  String adresse;

  Client1(
      {this.client_id,
      this.user_id,
      this.email,
      this.nom,
      this.prenom,
      this.phone,
      this.date_naissance,
      this.pays,
      this.ville,
      this.date_creation,
      this.image,
      this.code,
      this.status,
      this.positionId,
      this.adresse});
  void setNom(String nom1){
    this.nom=nom1;
  }  
    void setPrenom(String prenom1){
    this.prenom=prenom1;
  }  
    void setAdresse(String adress){
    this.adresse=adress;
  }  
  
  factory Client1.fromJson(Map<String, dynamic> obj) {
    return Client1(
        client_id: obj["clientid"],
        user_id: obj["UserId"],
        email: obj["email"],
        nom: obj["nom"],
        prenom: obj["prenom"],
        phone: obj["telephone"],
        date_naissance: obj["date_naissance"],
        pays: obj["pays"],
        ville: obj["ville"],
        date_creation: obj["date_creation"],
        image: obj["image"],
        code: obj["code"],
        status: obj["status"],
        positionId: obj["positionId"].toString(),
        adresse: obj["adresse"]);
  }

  factory Client1.fromJson2(Map<String, dynamic> obj) {
    return Client1(
        client_id: obj["client_id"],
        user_id: obj["user_id"],
        email: obj["email"],
        nom: obj["nom"],
        prenom: obj["prenom"],
        phone: obj["phone"],
        date_naissance: obj["date_naissance"],
        pays: obj["pays"],
        ville: obj["ville"],
        date_creation: obj["date_creation"],
        image: obj["image"],
        code: obj["code"],
        status: obj["status"],
        positionId: obj["positionId"].toString(),
        adresse: obj["adresse"]);
  }

  Map<String, dynamic> toMap() {
    var obj = new Map<String, dynamic>();
    obj["client_id"] = client_id;
    obj["user_id"] = user_id;
    obj["email"] = email;
    obj["nom"] = nom;
    obj["prenom"] = prenom;
    obj["phone"] = phone;
    obj["date_naissance"] = date_naissance;
    obj["pays"] = pays;
    obj["ville"] = ville;
    obj["date_creation"] = date_creation;
    obj["image"] = image;
    obj["code"] = code;
    obj["status"] = status;
    obj["positionId"] = positionId;
    obj["adresse"] = adresse;

    return obj;
  }
}

class Login2 {
  String token;
  int ttl;
  String date;
  int userId;
  Login2({this.token, this.ttl, this.date, this.userId});


  void tokenUser(String value) {
    this.token = value;
  }

  void ttlUser(int value) {
    this.ttl = value;
  }

  void dateUser(String value) {
    this.date = value;
  }

  void userid(int value) {
    this.userId = value;
  }


  factory Login2.fromJson(Map<String, dynamic> obj) {
    return Login2(
      token: obj["id"],
      ttl: obj["ttl"],
      date: obj["created"],
      userId: obj["userId"],
    );
  }
  factory Login2.fromJson2(Map<String, dynamic> obj) {
    return Login2(
      token: obj["token"],
      ttl: obj["ttl"],
      date: obj["date"],
      userId: obj["userId"],
    );
  }
}

class LocalAdress {
  String nom;
  String place_id;
  double latitude;
  String adresse;
  double longitude;
  LocalAdress({this.nom, this.latitude, this.adresse, this.longitude,this.place_id});

  factory LocalAdress.fromJson(Map<String, dynamic> obj) {
    return LocalAdress(
      nom: obj["nom"],
      latitude: obj["latitude"],
      adresse: obj["adresse"],
      longitude: obj["longitude"],
      place_id: obj["place_id"],
    );
  }
}

class AutoCompleteModel {
  String nom;
  String place_id;
  String adresse;
  AutoCompleteModel({this.nom, this.adresse, this.place_id});

  factory AutoCompleteModel.fromJson(Map<String, dynamic> obj) {
    return AutoCompleteModel(
      nom: obj["nom"],
      adresse: obj["adresse"],
      place_id: obj["place_id"],
    );
  }
}

class ClientLognin {
  String _token;
  int _ttl;
  String _date;
  int _userId;

  ClientLognin.empty() {
    this._token = null;
    this._ttl = -1;
    this._date = null;
    this._userId = -1;
  }

  ClientLognin(
    this._token,
    this._ttl,
    this._date,
    this._userId,
  );

  ClientLognin.map(dynamic obj) {
    this._token = obj["id"];
    this._ttl = obj["ttl"];
    this._date = obj["created"];
    this._userId = obj["userId"];
  }

  String get token => _token;
  int get ttl => _ttl;
  String get date => _date;
  int get userId => _userId;

  //List<String> get roles => _roles;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _token;
    map["created"] = _date;
    map["userId"] = _userId;
    return map;
  }

  set token(String value) {
    _token = value;
  }

  set ttl(int value) {
    _ttl = value;
  }

  set userId(int value) {
    _userId = value;
  }

  set date(String value) {
    _date = value;
  }

  @override
  String toString() {
    return 'ClientLognin{_ttl: $_ttl,_token: $_token, _date: $_date, _userId: $_userId}';
  }
}
