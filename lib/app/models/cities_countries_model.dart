import 'dart:convert';

CityCountryModel cityCountryModelFromJson(String str) =>
    CityCountryModel.fromJson(json.decode(str));

String cityCountryModelToJson(CityCountryModel data) =>
    json.encode(data.toJson());

class CityCountryModel {
  List<City>? cities;

  CityCountryModel({
    this.cities,
  });

  factory CityCountryModel.fromJson(Map<String, dynamic> json) =>
      CityCountryModel(
        cities: List<City>.from(json["cities"].map((x) => City.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cities": List<dynamic>.from(cities?.map((x) => x.toJson()) ?? []),
      };
}

City cityFromJson(Map<String, dynamic> str) => City.fromJson((str));

Map<String, dynamic> cityToJson(City data) => (data.toJson());

class City {
  int? id;
  String? city;
  double? lat;
  double? lng;
  String? country;

  City({
    this.id,
    this.city,
    this.lat,
    this.lng,
    this.country,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        city: json["city"],
        lat: json["lat"] == null ? null : double.parse(json["lat"].toString()),
        lng: json["lng"] == null ? null : double.parse(json["lng"].toString()),
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city": city,
        "lat": lat,
        "lng": lng,
        "country": country,
      };
}
