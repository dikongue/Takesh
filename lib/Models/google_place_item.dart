import 'google_place_item_term.dart';

class GooglePlacesItem {
  String description;
  String id;
  String place_id;
  String reference;
  List<GooglePlacesItemTerm> terms;

  GooglePlacesItem(
      {this.description, this.id, this.place_id, this.reference, this.terms});

  factory GooglePlacesItem.fromJson(Map<String, dynamic> json) {
    return GooglePlacesItem(
      description: json["description"],
      id: json["id"],
      place_id: json["place_id"],
      reference: json["reference"],
      terms: (json['terms'] as List)
          ?.map((e) => e == null
              ? null
              : GooglePlacesItemTerm.fromJson(e as Map<String, dynamic>))
          ?.toList(),
    );
  }
}
