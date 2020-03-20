import 'package:etakesh_client/Models/google_place_item_term.dart';

class Prestataires {
  int prestataireid;
  String cni;
  String date_naissance;
  String date_creation;
  String email;
  String code;
  String nom;
  String prenom;
  String image;
  String pays;
  String status;
  String telephone;
  String ville;
  String positionId;
  int userId;

  Prestataires({
    this.prestataireid,
    this.cni,
    this.date_creation,
    this.date_naissance,
    this.email,
    this.code,
    this.nom,
    this.prenom,
    this.image,
    this.pays,
    this.status,
    this.telephone,
    this.ville,
    this.positionId,
    this.userId,
  });

  factory Prestataires.fromJson(Map<String, dynamic> json) {
    return Prestataires(
      prestataireid: json["prestataireid"],
      cni: json["cni"],
      date_naissance: json["date_naissance"],
      date_creation: json["date_creation"],
      email: json["email"],
      code: json["code"],
      nom: json["nom"],
      prenom: json["prenom"],
      pays: json["pays"],
      status: json["status"],
      telephone: json["telephone"],
      ville: json["ville"],
      image: json["image"],
      positionId: json["positionId"],
      userId: json["UserId"],
    );
  }
}

  class PrestatairesPosition {
  int prestataireid;
  String cni;
  String date_naissance;
  String date_creation;
  String code;
  String email;
  String nom;
  String prenom;
  String image;
  String pays;
  String status;
  String telephone;
  String ville;
  String positionId;
  int userId;
  bool etat;
  Positions positions;

  PrestatairesPosition({
    this.prestataireid,
    this.cni,
    this.date_creation,
    this.date_naissance,
    this.email,
    this.code,
    this.nom,
    this.prenom,
    this.image,
    this.pays,
    this.status,
    this.telephone,
    this.ville,
    this.positionId,
    this.userId,
    this.positions,
    this.etat
  });

  factory PrestatairesPosition.fromJson(Map<String, dynamic> json) {
    return PrestatairesPosition(
      prestataireid: json["prestataireid"],
      cni: json["cni"],
      date_naissance: json["date_naissance"],
      date_creation: json["date_creation"],
      email: json["email"],
      code: json["code"],
      nom: json["nom"],
      prenom: json["prenom"],
      pays: json["pays"],
      status: json["status"],
      telephone: json["telephone"],
      ville: json["ville"],
      image: json["image"],
      positionId: json["positionId"],
      userId: json["UserId"],
      positions: Positions.fromJson(json["position"]),
      etat: json["etat"],
    );
  }
}

class Positions {
  int positionid;
  double latitude;
  double longitude;
  String libelle;

  Positions({this.positionid, this.latitude, this.longitude, this.libelle});

  factory Positions.fromJson(Map<String, dynamic> json) {
    return Positions(
      positionid: json["positionid"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      libelle: json["libelle"],
    );
  }
}

class Vehicule {
  int vehiculeid;
  String couleur;
  String status;
  String marque;
  String image;
  String immatriculation;
  int nombre_places;
  String date;
  String categorievehiculeId;
  String prestataireId;

  Vehicule(
      {this.vehiculeid,
      this.couleur,
      this.status,
      this.immatriculation,
      this.marque,
      this.nombre_places,
      this.image,
      this.date,
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

class PrestataireService {
  int prestationid;
  int vehiculeId;
  String status;
  String serviceId;
  PrestatairesPosition prestataire;
  int montant;
  String date;
  Vehicule vehicule;
  int prestataireId;


  PrestataireService(
      {this.prestationid,
      this.vehiculeId,
      this.status,
      this.prestataire,
      this.serviceId,
      this.montant,
      this.date,
      this.vehicule,
      this.prestataireId
    
      });

  factory PrestataireService.fromJson(Map<String, dynamic> json) {
    return PrestataireService(
      prestationid: json["prestationid"],
      vehiculeId: json["vehiculeId"],
      status: json["status"],
      prestataire: PrestatairesPosition.fromJson(json["prestataire"]),
      serviceId: json["serviceId"],
      montant: json["montant"],
      date: json["date"],
      vehicule: Vehicule.fromJson(json["vehicule"]),
      prestataireId: json["prestataireId"],
     
    );
  }
}

class PrestataireOnline {
  int vehiculeid;
  String couleur;
  String status;
  String marque;
  String image;
  String immatriculation;
  int nombre_places;
  String date;
  String categorievehiculeId;
  int prestataireId;
  PrestatairesPosition prestataires;

  PrestataireOnline(
      {this.vehiculeid,
      this.couleur,
      this.status,
      this.immatriculation,
      this.marque,
      this.nombre_places,
      this.image,
      this.date,
      this.categorievehiculeId,
      this.prestataireId,
      this.prestataires});

  factory PrestataireOnline.fromJson(Map<String, dynamic> json) {
    return PrestataireOnline(
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
      prestataires: PrestatairesPosition.fromJson(json["prestataire"]),
    );
  }
}
