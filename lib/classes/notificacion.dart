import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../styles/styles.dart';

class Notificacion extends StatefulWidget {
  final int? tipo;
  final String? titulo;
  final String? mensaje;

  static const int error = 1;
  static const int warning = 2;
  static const int info = 3;
  static const int logout = 4;
  static const int login = 5;

  const Notificacion({Key? key, this.tipo, this.titulo, this.mensaje})
      : super(key: key);

  @override
  _NotificacionState createState() => _NotificacionState();

  static AlertDialog mostrarMensajeInformacion(
      String mensaje, String submensaje) {
    return AlertDialog(title: Text(mensaje), content: Text(submensaje));
  }
}

class _NotificacionState extends State<Notificacion> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: contentBox(context));
  }

  contentBox(context) {
    return Stack(children: <Widget>[
      Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10)
              ]),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(children: [
                  _notificacionErrorIcono(widget.tipo),
                  Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Text(widget.titulo.toString(),
                          style: Styles.tituloNotificacion))
                ]),
                Row(children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(80, 0, 0, 0),
                      child: Text(widget.mensaje.toString(),
                          style: Styles.mensajeNotificacion,
                          textAlign: TextAlign.left)),
                ])
              ]))
    ]);
  }

  Icon _notificacionErrorIcono(int? tipo) {
    const double size = 65.0;
    Icon icono = Icon(Icons.error);
    switch (tipo) {
      case 1:
        icono = Icon(Icons.error, color: Colors.red, size: size);
        break;
      case 2:
        icono = Icon(Icons.warning, color: Colors.orange[700], size: size);
        break;
      case 3:
        icono = Icon(Icons.info, color: Colors.blue, size: size);
        break;
      case 4:
        icono = Icon(Icons.logout, color: Colors.red, size: size);
        break;
      case 5:
        icono = Icon(Icons.login, color: Colors.green, size: size);
        break;
    }

    return icono;
  }
}
