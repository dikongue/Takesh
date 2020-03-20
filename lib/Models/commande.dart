class Commande {
  int commandeid;
  String date_debut;
  String date_fin;
  String date;
  int montant;
  String status;
  String distance_client_prestataire;
  String duree_client_prestataire;
  String date_acceptation;
  String date_prise_en_charge;
  String position_prise_en_charge;
  String position_destination;
  int position_priseId;
  int position_destId;
  String rate_comment;
  String rate_date;
  int prestationId;
  int clientId;
  int prestataireId;

  Commande(
      {this.commandeid,
      this.date_debut,
      this.date_fin,
      this.date,
      this.montant,
      this.status,
      this.distance_client_prestataire,
      this.duree_client_prestataire,
      this.date_acceptation,
      this.date_prise_en_charge,
      this.position_prise_en_charge,
      this.position_destination,
      this.position_priseId,
      this.position_destId,
      this.rate_comment,
      this.rate_date,
      this.prestationId,
      this.clientId,
      this.prestataireId});

  factory Commande.fromJson(Map<String, dynamic> obj) {
    return Commande(
        commandeid: obj["commandeid"],
        date_debut: obj["date_debut"],
        date_fin: obj["date_fin"],
        date: obj["date"],
        position_priseId: obj["position_priseId"],
        position_destId: obj["position_destId"],
        montant: obj["montant"],
        status: obj["status"],
        distance_client_prestataire: obj["distance_client_prestataire"],
        duree_client_prestataire: obj["duree_client_prestataire"],
        date_acceptation: obj["date_acceptation"],
        date_prise_en_charge: obj["date_prise_en_charge"],
        position_prise_en_charge: obj["position_prise_en_charge"],
        position_destination: obj["position_destination"],
        rate_comment: obj["rate_comment"],
        rate_date: obj["rate_date"],
        prestationId: obj["prestationId"],
        clientId: obj["clientId"],
        prestataireId: obj["prestataireId"]);
  }
  factory Commande.fromJson2(Map<String, dynamic> obj) {
    return Commande(
      commandeid: obj["commandeid"],
      date_debut: obj["date_debut"],
      date_fin: obj["date_fin"],
      date: obj["date"],
      montant: obj["montant"],
      status: obj["status"],
      distance_client_prestataire: obj["distance_client_prestataire"],
      duree_client_prestataire: obj["duree_client_prestataire"],
      date_acceptation: obj["date_acceptation"],
      date_prise_en_charge: obj["date_prise_en_charge"],
      position_prise_en_charge: obj["position_prise_en_charge"],
      position_destination: obj["position_destination"],
      rate_comment: obj["rate_comment"],
      rate_date: obj["rate_date"],
      prestationId: obj["prestationId"],
      clientId: obj["clientId"],
    );
  }
}

class PositionModel {
  int positionid;
  double latitude;
  double longitude;
  String libelle;

  PositionModel({this.positionid, this.latitude, this.longitude, this.libelle});

  factory PositionModel.fromJson(Map<String, dynamic> obj) {
    return PositionModel(
      positionid: obj["positionid"],
      latitude: obj["latitude"],
      longitude: obj["longitude"],
      libelle: obj["libelle"],
    );
  }
}

//Create to get the local information about order
class CommandeLocal {
  int clientId;
  int prestataireId;
  int commandeId;
  int prestationId;
  String date_debut;
  String date_fin;
  String date;
  int montant;
  String status;
  String position_prise_en_charge;
  String position_destination;
  String distance_client_prestataire;
  String duree_client_prestataire;
  String date_acceptation;
  String date_prise_en_charge;
  String position_priseId;
  String position_destId;
  String rate_comment;
  String rate_date;
  int rate_value;
  String code;
  String is_created;
  String is_accepted;
  String is_refused;
  String is_terminated;
  String is_started;

  CommandeLocal(
      {this.clientId,
      this.prestataireId,
      this.commandeId,
      this.prestationId,
      this.date_debut,
      this.date_fin,
      this.date,
      this.montant,
      this.status,
      this.position_prise_en_charge,
      this.position_destination,
      this.distance_client_prestataire,
      this.duree_client_prestataire,
      this.date_acceptation,
      this.date_prise_en_charge,
      this.position_priseId,
      this.position_destId,
      this.rate_comment,
      this.rate_date,
      this.rate_value,
      this.code,
      this.is_accepted,
      this.is_created,
      this.is_refused,
      this.is_terminated,
      this.is_started});

  factory CommandeLocal.fromJson(Map<String, dynamic> obj) {
    return CommandeLocal(
      clientId: obj["clientId"],
      prestataireId: obj["prestataireId"],
      commandeId: obj["cmdId"],
      prestationId: obj["prestationId"],
      date_debut: obj["date_debut"],
      date_fin: obj["date_fin"],
      code: obj["code"],
      date: obj["date"],
      montant: obj["montant"],
      status: obj["status"],
      position_prise_en_charge: obj["position_prise_en_charge"],
      position_destination: obj["position_destination"],
      distance_client_prestataire: obj["distance_client_prestataire"],
      duree_client_prestataire: obj["duree_client_prestataire"],
      date_acceptation: obj["date_acceptation"],
      date_prise_en_charge: obj["date_prise_en_charge"],
      position_priseId: obj["position_priseId"],
      position_destId: obj["position_destId"],
      rate_comment: obj["rate_comment"],
      rate_date: obj["rate_date"],
      rate_value: obj["rate_value"],
      is_accepted: obj["is_accepted"],
      is_created: obj["is_created"],
      is_refused: obj["is_refused"],
      is_terminated: obj["is_terminated"],
      is_started: obj["is_started"],
    );
  }
}

class CommandeDetail {
  int commandeid;
  String date_debut;
  String date_fin;
  String date;
  int montant;
  String status;
  String position_prise_en_charge;
  String position_destination;
  String distance_client_prestataire;
  String duree_client_prestataire;
  String date_acceptation;
  String date_prise_en_charge;
  String position_priseId;
  String position_destId;
  String rate_comment;
  String rate_date;
  int rate_value;
  int prestationId;
  Prestation prestation;
  String clientId;
  String code;
  bool is_created;
  bool is_accepted;
  bool is_refused;
  bool is_terminated;
  bool is_started;
 // int prestataireId;

  CommandeDetail(
      {this.commandeid,
      this.date_debut,
      this.date_fin,
      this.date,
      this.montant,
      this.status,
      this.position_prise_en_charge,
      this.position_destination,
      this.distance_client_prestataire,
      this.duree_client_prestataire,
      this.date_acceptation,
      this.date_prise_en_charge,
      this.position_priseId,
      this.position_destId,
      this.rate_comment,
      this.rate_date,
      this.rate_value,
      this.prestationId,
      this.prestation,
      this.clientId,
      this.code,
      this.is_accepted,
      this.is_created,
      this.is_refused,
      this.is_terminated,
      this.is_started,
     // this.prestataireId
      });

  factory CommandeDetail.fromJson(Map<String, dynamic> obj) {
    return CommandeDetail(
      commandeid: obj["commandeid"],
      date_debut: obj["date_debut"],
      date_fin: obj["date_fin"],
      code: obj["code"],
      date: obj["date"],
      montant: obj["montant"],
      status: obj["status"],
      position_prise_en_charge: obj["position_prise_en_charge"],
      position_destination: obj["position_destination"],
      distance_client_prestataire: obj["distance_client_prestataire"],
      duree_client_prestataire: obj["duree_client_prestataire"],
      date_acceptation: obj["date_acceptation"],
      date_prise_en_charge: obj["date_prise_en_charge"],
      position_priseId: obj["position_priseId"],
      position_destId: obj["position_destId"],
      rate_comment: obj["rate_comment"],
      rate_date: obj["rate_date"],
      rate_value: obj["rate_value"],
      prestationId: obj["prestationId"],
      prestation: Prestation.fromJson(obj["prestation"]),
      clientId: obj["clientId"],
      is_accepted: obj["is_accepted"],
      is_created: obj["is_created"],
      is_refused: obj["is_refused"],
      is_terminated: obj["is_terminated"],
      is_started: obj["is_started"]
   
    );
  }
}

class Prestation {
  int prestationid;
  String vehiculeId;
  String status;
  String serviceId;
  int montant;
  String date;
  String prestataireId;
  Service1 service;
  Prestataire prestataire;
  Vehicule vehicule;

  Prestation(
      {this.prestationid,
      this.vehiculeId,
      this.status,
      this.serviceId,
      this.montant,
      this.date,
      this.service,
      this.prestataire,
      this.vehicule,
      this.prestataireId});

  factory Prestation.fromJson(Map<String, dynamic> json) {
    return Prestation(
      prestationid: json["prestationid"],
      vehiculeId: json["vehiculeId"],
      status: json["status"],
      vehicule: Vehicule.fromJson(json["vehicule"]),
      service: Service1.fromJson(json["service"]),
      prestataire: Prestataire.fromJson(json["prestataire"]),
      serviceId: json["serviceId"],
      montant: json["montant"],
      date: json["date"],
      prestataireId: json["prestataireId"],
    );
  }
}

class Service1 {
  final int serviceid;
  final String code;
  final int duree;
  final String intitule;
  final int prix;

  Service1({this.serviceid, this.code, this.duree, this.intitule, this.prix});

  factory Service1.fromJson(Map<String, dynamic> json) {
    return Service1(
      serviceid: json['serviceid'],
      code: json['code'],
      duree: json['duree'],
      intitule: json['intitule'],
      prix: json['prix'],
    );
  }
}

class Prestataire {
  int prestataireid;
  String cni;
  String date_naissance;
  String date_creation;
  String email;
  String code;
  String nom;
  String prenom;
  String pays;
  String image;
  String status;
  String telephone;
  String ville;
  String positionId;
  bool etat;
  int UserId;

  Prestataire({
    this.prestataireid,
    this.cni,
    this.date_creation,
    this.date_naissance,
    this.email,
    this.code,
    this.nom,
    this.prenom,
    this.pays,
    this.image,
    this.status,
    this.telephone,
    this.ville,
    this.positionId,
    this.etat,
    this.UserId,
  });

  factory Prestataire.fromJson(Map<String, dynamic> json) {
    return Prestataire(
      prestataireid: json["prestataireid"],
      cni: json["cni"],
      date_naissance: json["date_naissance"],
      date_creation: json["date_creation"],
      email: json["email"],
      nom: json["nom"],
      code: json["code"],
      prenom: json["prenom"],
      pays: json["pays"],
      image: json["image"],
      status: json["status"],
      telephone: json["telephone"],
      ville: json["ville"],
      positionId: json["positionId"],
      etat: json["etat"],
      UserId: json["UserId"],
    );
  }
}

class Vehicule {
  int vehiculeid;
  String couleur;
  String status;
  String marque;
  String immatriculation;
  int nombre_places;
  String date;
  String image;
  String categorievehiculeId;
  String prestataireId;

  Vehicule(
      {this.vehiculeid,
      this.couleur,
      this.status,
      this.immatriculation,
      this.marque,
      this.nombre_places,
      this.date,
      this.image,
      this.categorievehiculeId,
      this.prestataireId});

  factory Vehicule.fromJson(Map<String, dynamic> json) {
    return Vehicule(
      vehiculeid: json["vehiculeid"],
      couleur: json["couleur"],
      status: json["status"],
      immatriculation: json["immatriculation"],
      marque: json["marque"],
      nombre_places: json["nombre_places"],
      date: json["date"],
      image: json["image"],
      categorievehiculeId: json["categorievehiculeId"],
      prestataireId: json["prestataireId"],
    );
  }
}
