class Province {
  String? provinceId;
  String? province;

  Province({
    this.provinceId,
    this.province,
  });

  Province.fromJson(Map<String, dynamic> json) {
    provinceId = json['province_id'];
    province = json['province'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['province_id'] = provinceId;
    data['province'] = province;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'provinceId': provinceId,
      'province': province,
    };
  }

  factory Province.fromMap(Map<String, dynamic> map) {
    return Province(
      provinceId:
          map['provinceId'] != null ? map['provinceId'] as String : null,
      province: map['province'] != null ? map['province'] as String : null,
    );
  }

  @override
  String toString() => 'Province(provinceId: $provinceId, province: $province)';

  static List<Province> fromJsonList(List<dynamic>? json) {
    if (json == null || json.isEmpty) return [];
    return json.map((item) => Province.fromJson(item)).toList();
  }

  String asString() {
    return '$province';
  }

  bool isEqual(Province model) {
    return provinceId == model.provinceId;
  }
}
