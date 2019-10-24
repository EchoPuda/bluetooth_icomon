
class RulerMsg {
  final double distance;
  final String time;

  RulerMsg.fromMap(Map map)
      : distance = map["distance"],
        time = map["time"];
}