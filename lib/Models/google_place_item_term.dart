class GooglePlacesItemTerm {
  int offset;
  String value;

  GooglePlacesItemTerm({this.offset, this.value});

  factory GooglePlacesItemTerm.fromJson(Map<String, dynamic> json) {
    return GooglePlacesItemTerm(
      offset: json['offset'],
      value: json['value'],
    );
  }
}

class LocationModel {
  double lat;
  double lng;

  LocationModel({this.lat, this.lng});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      lat: json["lat"],
      lng: json["lng"],
    );
  }
}

class Distance {
  String dist;
  int value;

  Distance({this.dist, this.value});

  factory Distance.fromJson(Map<String, dynamic> json) {
    return Distance(
      dist: json['text'],
      value: json['value'],
    );
  }
}

class Duree {
  String time;
  int value;

  Duree({this.time, this.value});

  factory Duree.fromJson(Map<String, dynamic> json) {
    return Duree(
      time: json['text'],
      value: json['value'],
    );
  }
}

class DistanceTime {
  Distance distance;
  Duree duree;

  DistanceTime({this.distance, this.duree});

  factory DistanceTime.fromJson(Map<String, dynamic> json) {
    return DistanceTime(
      distance: Distance.fromJson(json['distance']),
      duree: Duree.fromJson(json['duration'])
    );
  }
}

