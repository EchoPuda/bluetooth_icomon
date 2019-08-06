
class ScanResult {
  final String name;
  final String macAddr;
  final String type;

  ScanResult.fromMap(Map map)
      : name = map["name"],
        macAddr = map["macAddr"],
        type = map["type"];
}