class City {
  String? cityId;
  String? provinceId;
  String? province;
  String? type;
  String? cityName;
  String? postalCode;

  City(
      {this.cityId,
      this.provinceId,
      this.province,
      this.type,
      this.cityName,
      this.postalCode});

  City.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    provinceId = json['province_id'];
    province = json['province'];
    type = json['type'];
    cityName = json['city_name'];
    postalCode = json['postal_code'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['city_id'] = cityId;
    data['province_id'] = provinceId;
    data['province'] = province;
    data['type'] = type;
    data['city_name'] = cityName;
    data['postal_code'] = postalCode;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cityId': cityId,
      'provinceId': provinceId,
      'province': province,
      'type': type,
      'cityName': cityName,
      'postalCode': postalCode,
    };
  }

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      cityId: map['cityId'] != null ? map['cityId'] as String : null,
      provinceId:
          map['provinceId'] != null ? map['provinceId'] as String : null,
      province: map['province'] != null ? map['province'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      cityName: map['cityName'] != null ? map['cityName'] as String : null,
      postalCode:
          map['postalCode'] != null ? map['postalCode'] as String : null,
    );
  }

  @override
  String toString() {
    return 'City(cityId: $cityId, provinceId: $provinceId, province: $province, type: $type, cityName: $cityName, postalCode: $postalCode)';
  }

  static List<City> fromJsonList(List<dynamic>? json) {
    if (json == null || json.isEmpty) return [];
    return json.map((item) => City.fromJson(item)).toList();
  }

  String asString() {
    return '$type $cityName';
  }

  bool isEqual(City model) {
    return cityId == model.cityId;
  }
}
