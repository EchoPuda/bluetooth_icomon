
class FatScaleMsg {
  final double bmi;
  final int bmr;
  final double bodyFatPercent;
  final double boneMass;
  final int electrode;
  final int hr;
  final double imp;
  final bool isStabilized;
  final double moisturePercent;
  final double musclePercent;
  final double physicalAge;
  final double proteinPercent;
  final double smPercent;
  final double subcutaneousFatPercent;
  final double temperature;
  final String time;
  final double visceralFat;
  final double weight_kg;

  FatScaleMsg.fromMap(Map map)
      : bmi = map["bmi"],
        bmr = map["bmr"],
        bodyFatPercent = map["bodyFatPercent"],
        boneMass = map["boneMass"],
        electrode = map["electrode"],
        hr = map["hr"],
        imp = map["imp"],
        isStabilized = map["isStabilized"],
        moisturePercent = map["moisturePercent"],
        musclePercent = map["musclePercent"],
        physicalAge = map["physicalAge"],
        proteinPercent = map["proteinPercent"],
        smPercent = map["smPercent"],
        subcutaneousFatPercent = map["subcutaneousFatPercent"],
        temperature = map["temperature"],
        time = map["time"],
        visceralFat = map["visceralFat"],
        weight_kg = map["weight_kg"];
}