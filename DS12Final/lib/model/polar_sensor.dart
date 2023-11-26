import 'sensor.dart';
import 'dart:async';
import 'package:polar/polar.dart';
import 'package:permission_handler/permission_handler.dart';

class PolarSensor extends Sensor {
  final _heartRateController = StreamController<int>.broadcast();
  final _batteryController = StreamController<String>.broadcast();

  StreamSubscription<PolarHrData>? _hrSubscription;

  final polar = Polar();
  String id;

  PolarSensor(this.id);

  @override
  String get name => 'Polar Heart Rate Sensor';

  @override
  String get address => id; 

  StreamSubscription<PolarBatteryLevelEvent>? _batterySubscription;
  @override
  Stream<String> get batteryStatus => _batteryController.stream; 

  bool _isConnected = false;
  @override
  bool get isConnected => _isConnected;


  final _activeStatusController = StreamController<bool>.broadcast();
  @override
  Stream<bool> get isActive => _activeStatusController.stream;

  @override
  Stream<int> get heartRate => _heartRateController.stream;

  @override
  Future<bool> get hasPermissions async =>
      await Permission.bluetoothScan.isGranted &&
      await Permission.bluetoothConnect.isGranted;

  @override
  Future<void> requestPermissions() async => await [
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request();

  @override
  Future<void> connect() async {
    if (!(await hasPermissions)) await requestPermissions();

    polar
        .searchForDevice()
        .listen((event) => print('Found device in scan: ${event.deviceId}'));

    polar.deviceConnecting.listen(
        (event) => print('Connecting to device - id:${event.deviceId}'));
    polar.deviceConnected.listen((event) {
        print('Device connected');
        _isConnected = true;
        batteryStream();
    });

    polar.deviceDisconnected.listen((event) {
        print('Device disconnected');
        _isConnected = false;
    });

    polar.batteryLevel.listen((event) => print('Battery: ${event.level}'));
    polar.blePowerState.listen((event) => print('BLE Power State is: $event'));
    polar.disInformation
        .listen((event) => print('Device DIS info: ${event.info}'));
    polar.sdkFeatureReady
        .listen((event) => print('Device SDK Feature: ${event.feature}'));

    print('Connecting to device, id: $id');
    await polar.connectToDevice(id);
    
  }
  @override
  Future<void> disconnect(String deviceId) async{
    polar.disconnectFromDevice(deviceId).then((_) {
      print('Disconnected from the device');
      _isConnected = false;
      _batterySubscription?.cancel();
      _batteryController.add("no data");
    }).catchError((error) {
      print('Failed to disconnect: $error');
    });
  }

  void batteryStream() async {
    if (!_isConnected) {
      return;
    }

    _batterySubscription?.cancel(); 

    _batterySubscription = polar.batteryLevel.listen(
      (event) { 
        print('Battery: ${event.level}');
        _batteryController.add("${event.level}%");
      },
      onError: (e) {
        print('Error listening to battery level: $e');
      }
    );
    print("battery subbed");
  }

  @override
  void start() async {
    if (isConnected){
      _activeStatusController.add(true);

      _hrSubscription?.cancel();
      _batterySubscription?.cancel(); 

      _hrSubscription = polar
          .startHrStreaming(id)
          .listen((PolarHrData event) { 
            _heartRateController.add(event.samples.first.hr);
            print('hr: ${event.samples.first.hr}');
          });


      _batterySubscription =  polar.batteryLevel.listen(
          (PolarBatteryLevelEvent event) {
            print('Battery Level Event: $event');
            
            _batteryController.add('${event.level}%');
            
          },
          onError: (e) {
            print('Error listening to battery level: $e');
          }
            );   
    }
  }

  @override
  void stop() {
    _hrSubscription?.cancel();
    _hrSubscription = null;

    _batterySubscription?.cancel();
    _batterySubscription = null;
  
    _activeStatusController.add(false);
  }

}
