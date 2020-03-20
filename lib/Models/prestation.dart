
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
  PrestatairesPrestation prestation;

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
    this.prestation,
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
      prestation: PrestatairesPrestation.fromJson(json["prestation"]),
      etat: json["etat"],
    );
  }
}
  class PrestatairesPrestation {
  int prestationid;
  String date;
  String status;
  String montant;
  String pourcentage;
  String vehiculeId;
  int prestataireId;
  int serviceId;

  PrestatairesPrestation({
    this.prestationid,
    this.date,
    this.status,
    this.montant,
    this.pourcentage,
    this.vehiculeId,
    this.prestataireId,
    this.serviceId,
  });

  factory PrestatairesPrestation.fromJson(Map<String, dynamic> json) {
    return PrestatairesPrestation(
      prestationid: json["prestationid"],
      date: json["date"],
      status: json["status"],
      montant: json["montant"],
      pourcentage: json["pourcentage_et"],
      vehiculeId: json["vehiculeId"],
      prestataireId: json["prestataireId"],
      serviceId: json["serviceId"],
    );
  }
}
class PrestatairePrestationOnline {
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
 

  PrestatairePrestationOnline(
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

  factory PrestatairePrestationOnline.fromJson(Map<String, dynamic> json) {
    return PrestatairePrestationOnline(
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