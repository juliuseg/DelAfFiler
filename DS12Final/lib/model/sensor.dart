// model/sensor.dart
abstract class Sensor {
  String get name;
  String get address; 
  Stream<String> get batteryStatus;
  bool get isConnected;
  Stream<int> get heartRate;
  Stream<bool> get isActive;

  void start();
  void stop();

  Future<bool> get hasPermissions;

  Future<void> requestPermissions();

  Future<void> connect();

  Future<void> disconnect(String deviceId);

}