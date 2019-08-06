
class RulerMsg {
  final double distance;
  final String time;

  RulerMsg.fromMap(Map map)
      : distance = map["name"],
        time = map["macAddr"];
}