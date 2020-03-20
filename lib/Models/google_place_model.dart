import 'google_place_item.dart';

class GooglePlacesModel {
  String status;
  List<GooglePlacesItem> predictions;

  GooglePlacesModel({this.status, this.predictions});

  factory GooglePlacesModel.fromJson(Map<String, dynamic> json) {
    return GooglePlacesModel(
      status: json["status"],
      predictions: (json['predictions'] as List)
          ?.map((e) => e == null
              ? null
              : GooglePlacesItem.fromJson(e as Map<String, dynamic>))
          ?.toList(),
    );
  }
}
