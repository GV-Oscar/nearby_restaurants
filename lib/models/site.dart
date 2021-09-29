import 'dart:convert';

Site siteFromJson(String str) => Site.fromJson(json.decode(str));

String siteToJson(Site data) => json.encode(data.toJson());

class Site {
  Site({
    this.placeId = '',
    this.address = '',
    this.addressLine = '',
    this.adminArea = '',
    this.adminAreaCode = '',
    this.countryCode = '',
    this.countryName = '',
    this.latitude = 0,
    this.locality = '',
    this.localityCode = '',
    this.subLocality = '',
    this.longitude = 0,
    this.neighborhoods = '',
    this.postalCode = '',
    this.region = '',
    this.route = '',
    this.street = '',
    this.type = '',
  });

  String placeId;
  String address;
  String addressLine;
  String adminArea;
  String adminAreaCode;
  String countryCode;
  String countryName;
  double latitude;
  String locality;
  String localityCode;
  String subLocality;
  double longitude;
  String neighborhoods;
  String postalCode;
  String region;
  String route;
  String street;
  String type;

  factory Site.fromJson(Map<String, dynamic> json) => Site(
        placeId       : json.containsKey('placeId') ? json["placeId"] : '',
        address       : json.containsKey('address') ? json["address"]: '',
        addressLine   : json.containsKey('addressLine') ? json["addressLine"]: '',
        adminArea     : json.containsKey('adminArea') ? json["adminArea"]: '',
        adminAreaCode : json.containsKey('adminAreaCode') ? json["adminAreaCode"]: '',
        countryCode   : json.containsKey('countryCode') ? json["countryCode"]: '',
        countryName   : json.containsKey('countryName') ? json["countryName"]: '',
        latitude      : json.containsKey('latitude') ? json["latitude"]?.toDouble(): '',
        locality      : json.containsKey('locality') ? json["locality"]: '',
        localityCode  : json.containsKey('localityCode') ? json["localityCode"]: '',
        subLocality   : json.containsKey('subLocality') ? json["subLocality"]: '',
        longitude     : json.containsKey('longitude') ? json["longitude"]?.toDouble(): '',
        neighborhoods : json.containsKey('neighborhoods') ?  json["neighborhoods"]: '',
        postalCode    :json.containsKey('postalCode') ?  json["postalCode"]: '',
        region        :json.containsKey('region') ?  json["region"]: '',
        route         : json.containsKey('route') ? json["route"]: '',
        street        :json.containsKey('street') ?  json["street"]: '',
        type          :json.containsKey('type') ?  json["type"]: '',
      );

  Map<String, dynamic> toJson() => {
        "placeId": placeId,
        "address": address,
        "addressLine": addressLine,
        "adminArea": adminArea,
        "adminAreaCode": adminAreaCode,
        "countryCode": countryCode,
        "countryName": countryName,
        "latitude": latitude,
        "locality": locality,
        "localityCode": localityCode,
        "subLocality": subLocality,
        "longitude": longitude,
        "neighborhoods": neighborhoods,
        "postalCode": postalCode,
        "region": region,
        "route": route,
        "street": street,
        "type": type,
      };
}
