class Medicine {
  final String? id;
  final String? name;
  final String? dosage;
  final int? frequency;
  final String? frequencyType;
  final String? additionalInfo;
  final List<DoseSchedules>? doseSchedules;
  final String? timezone;
  final int? price;
  final String? currency;
  final int? v;

  Medicine({
    this.id,
    this.name,
    this.dosage,
    this.frequency,
    this.frequencyType,
    this.additionalInfo,
    this.doseSchedules,
    this.timezone,
    this.price,
    this.currency,
    this.v,
  });

  Medicine.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        name = json['name'] as String?,
        dosage = json['dosage'] as String?,
        frequency = json['frequency'] as int?,
        frequencyType = json['frequencyType'] as String?,
        additionalInfo = json['additionalInfo'] as String?,
        doseSchedules = (json['doseSchedules'] as List?)?.map((dynamic e) => DoseSchedules.fromJson(e as Map<String,dynamic>)).toList(),
        timezone = json['timezone'] as String?,
        price = json['price'] as int?,
        currency = json['currency'] as String?,
        v = json['__v'] as int?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'name' : name,
    'dosage' : dosage,
    'frequency' : frequency,
    'frequencyType' : frequencyType,
    'additionalInfo' : additionalInfo,
    'doseSchedules' : doseSchedules?.map((e) => e.toJson()).toList(),
    'timezone' : timezone,
    'price' : price,
    'currency' : currency,
    '__v' : v
  };
}

class DoseSchedules {
  final String? time;
  final String? id;

  DoseSchedules({
    this.time,
    this.id,
  });

  DoseSchedules.fromJson(Map<String, dynamic> json)
      : time = json['time'] as String?,
        id = json['_id'] as String?;

  Map<String, dynamic> toJson() => {
    'time' : time,
    '_id' : id
  };
}