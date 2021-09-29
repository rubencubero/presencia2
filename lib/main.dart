import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mocks/mock_personas.dart';
import 'screens/lecturaTarjeta.dart';
import 'screens/configuracion.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasDeviceID = prefs.containsKey('DeviceID');
  bool hasDeviceName = prefs.containsKey('DeviceName');
  bool hasAPIServer = prefs.containsKey('APIServer');

  if (!hasDeviceID) {
    prefs.setInt('DeviceID', 75);
  }
  if (!hasDeviceName) {
    prefs.setString('DeviceName', 'PDP01');
  }
  if (!hasAPIServer) {
    prefs.setString('APIServer', '192.168.123.203:8001');
  }

  final mockPersonas = await MockPersonas.getPersonas(prefs.getInt('DeviceID'));

  if (mockPersonas.isNotEmpty) {
    return runApp(MaterialApp(
        theme:
            ThemeData(primaryColor: Colors.lightGreen, fontFamily: 'BebasNeue'),
        home: LecturaTarjeta(mockPersonas, prefs)));
  } else {
    return runApp(MaterialApp(
        theme:
            ThemeData(primaryColor: Colors.lightGreen, fontFamily: 'BebasNeue'),
        home: Configuracion(prefs, true)));
  }
}
