import 'package:flutter/material.dart';

class Styles {
  //const String defaultFontFamily = '';

  static final defaultText = TextStyle(fontSize: 45, color: Colors.grey[800]);
  static final cardText = TextStyle(fontSize: 25);

  static final mensajeBandaMagneticaText =
      TextStyle(fontFamily: 'BebasNeue', fontSize: 45, color: Colors.grey[600]);
  static final mensajeFechaHoraText =
      TextStyle(fontFamily: 'BebasNeue', fontSize: 35);

//Pin Code
  static final pinCodeButtonText = TextStyle(fontSize: 25);

//Notificaciones
  static final tituloNotificacion = TextStyle(
      fontFamily: 'BebasNeue', fontSize: 20, fontWeight: FontWeight.w600);
  static final mensajeNotificacion =
      TextStyle(fontFamily: 'BebasNeue', fontSize: 15);
}
