class Ongkir {
  String? service;
  String? description;
  List<Cost>? cost;

  Ongkir({
    this.service,
    this.description,
    this.cost,
  });

  Ongkir.fromJson(Map<String, dynamic> json) {
    service = json['service'];
    description = json['description'];
    if (json['cost'] != null) {
      cost = <Cost>[];
      json['cost'].forEach((v) {
        cost?.add(Cost.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['service'] = service;
    data['description'] = description;
    if (cost != null) {
      data['cost'] = cost?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'service': service,
      'description': description,
      'cost': cost?.map((x) => x.toMap()).toList(),
    };
  }

  factory Ongkir.fromMap(Map<String, dynamic> map) {
    return Ongkir(
      service: map['service'] != null ? map['service'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      cost: map['cost'] != null
          ? List<Cost>.from(
              (map['cost'] as List<int>).map<Cost?>(
                (x) => Cost.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  @override
  String toString() =>
      'Ongkir(service: $service, description: $description, cost: $cost)';

  static List<Ongkir> fromJsonList(List<dynamic>? json) {
    if (json == null || json.isEmpty) return [];
    return json.map((item) => Ongkir.fromJson(item)).toList();
  }
}

class Cost {
  int? value;
  String? etd;
  String? note;

  Cost({
    this.value,
    this.etd,
    this.note,
  });

  Cost.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    etd = json['etd'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['value'] = value;
    data['etd'] = etd;
    data['note'] = note;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': value,
      'etd': etd,
      'note': note,
    };
  }

  factory Cost.fromMap(Map<String, dynamic> map) {
    return Cost(
      value: map['value'] != null ? map['value'] as int : null,
      etd: map['etd'] != null ? map['etd'] as String : null,
      note: map['note'] != null ? map['note'] as String : null,
    );
  }

  @override
  String toString() => 'Cost(value: $value, etd: $etd, note: $note)';
}
