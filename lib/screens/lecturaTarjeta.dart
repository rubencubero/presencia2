import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:presencia2/mocks/mock_personas.dart';
import 'package:presencia2/screens/pinCode.dart';
import 'package:presencia2/widgets/extras.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'listadoPersonas.dart';
import 'configuracion.dart';
import '../classes/persona.dart';
import '../classes/tarjeta.dart';
import '../classes/parte.dart';
import '../classes/notificacion.dart';
import '../styles/styles.dart';

class LecturaTarjeta extends StatefulWidget {
  List<Persona> _personas;
  final SharedPreferences prefs;

  LecturaTarjeta(this._personas, this.prefs);

  @override
  _LecturaTarjetaState createState() => _LecturaTarjetaState();
}

class _LecturaTarjetaState extends State<LecturaTarjeta> {
  final Tarjeta _tarjeta = Tarjeta(codigoMagnetico: '', lecturaActiva: false);

  late List<Persona> _personas;
  //bool extraPlusPuestoTrabajo = false;
  //bool extraCambioTurno = false;

  late Timer timer;
  late Timer timerReloj;
  late FocusNode myFocusNode;
  late DateTime hora = DateTime.now();
  Extras extras = Extras();

  void updateListPersonas() async {
    widget._personas.clear();
    _personas = await MockPersonas.getPersonas(widget.prefs.getInt('DeviceID'));
    print('updated list personas');
  }

  void initState() {
    super.initState();
    timer =
        Timer.periodic(Duration(hours: 1), (Timer t) => updateListPersonas());
    timerReloj = Timer.periodic(
        Duration(seconds: 1),
        (Timer t) => setState(() {
              hora = DateTime.now();
            }));
    myFocusNode = FocusNode();
  }

  void dispose() {
    timer.cancel();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Presencia',
              style: Styles.defaultText,
            ),
            actions: _renderizarOpcionesAppBar(context)),
        body: RawKeyboardListener(
            autofocus: true,
            focusNode: myFocusNode,
            onKey: (RawKeyEvent event) async {
              String resultado =
                  await _capturarTeclaPulsada(event, context, _tarjeta);
              if (resultado.length != 0) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Notificacion(
                          tipo: Notificacion.warning,
                          titulo: 'Alerta',
                          mensaje: resultado);
                    });
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _renderizarMensajeTarjeta('Pase la tarjeta para identificarse'),
              ],
            )),
        floatingActionButton: extras
        /*ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.lightGreen.shade300)),
            child: Text(
              'Extras',
              style: TextStyle(fontSize: 30.0),
            ),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (builder) {
                  return StatefulBuilder(
                    builder: (context, setstate) {
                      return Container(
                          height: 300,
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          elevation:
                                              MaterialStateProperty.all<double>(
                                                  0)),
                                      child: Icon(Icons.close_rounded,
                                          size: 30.0, color: Colors.black)
                                      /*const Text(
                                        'X',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 35.0),
                                      )*/
                                      ,
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ]),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text(
                                      'Marcar extras antes de pasar la tarjeta al registrar la salida.',
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                  ),
                                ],
                              ),
                              _renderizarOpcionesMarcaje(setstate)
                            ],
                          ));
                    },
                  );
                },
              );
            })*/
        );
  }

  List<Widget> _renderizarOpcionesAppBar(BuildContext context) {
    return <Widget>[
      Padding(
          padding: EdgeInsets.only(right: 20),
          child: Container(
              width: 500,
              child: Row(children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateFormat(' HH:mm:ss dd/MM/yy').format(hora),
                          style: TextStyle(fontSize: 25.0)),
                    ],
                  ),
                ),
                MaterialButton(
                    onPressed: () {
                      updateListPersonas();
                      myFocusNode.requestFocus();
                    },
                    child: Icon(
                      Icons.refresh,
                      size: 46.0,
                    )),
                _navBarIconoListadoPersonas(context),
                _navBarIconoConfiguracion(context, widget.prefs)
              ])))
    ];
  }

  Widget _navBarIconoListadoPersonas(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _navegarListadoPersonas(context);
          myFocusNode.requestFocus();
        },
        child: Icon(Icons.perm_identity_rounded, size: 46.0));
  }

  Widget _navBarIconoConfiguracion(
      BuildContext context, SharedPreferences prefs) {
    return GestureDetector(
        onTap: () {
          _navegarConfiguracion(context, prefs, '5738');
          myFocusNode.requestFocus();
        },
        child: Icon(Icons.settings, size: 46.0));
  }

  Widget _renderizarMensajeTarjeta(String texto) {
    return Container(
        alignment: Alignment(0, 0),
        child: Text(texto, style: Styles.mensajeBandaMagneticaText));
  }

  void _navegarListadoPersonas(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ListadoPersonas(widget._personas, widget.prefs)));
  }

  void _navegarConfiguracion(
      BuildContext context, SharedPreferences prefs, String pin) async {
    final resultado = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => PinCode(pin)));
    if (resultado) {
      await Navigator.push(context,
          MaterialPageRoute(builder: (context) => Configuracion(prefs, true)));
      updateListPersonas();
    }
  }

  Future<String> _capturarTeclaPulsada(
      RawKeyEvent event, BuildContext context, Tarjeta tarjeta) async {
    String mensaje = '';
    //Captura solo el keydown para evitar duplicaciones
    if (event.runtimeType.toString() == 'RawKeyDownEvent') {
      print('- Estado lectura: ${tarjeta.getLecturaActiva()}');

      //** NOTA IMPORTANTE, el teclado configurado en el dispositivo tiene que ser QWERTY UK para que el caracter inicial sea
      //; y el final  ? pero el sistema lo detectará como un / con un SHIFT delante*/
      print('- Tecla pulsada: ' + event.logicalKey.keyLabel.toString());

      //Activamos la lectura
      if (event.isKeyPressed(LogicalKeyboardKey.semicolon)) {
        print('- [#CB activado]');
        tarjeta.setLecturaActiva(true);
      }

      //Capturamos la tecla si la lectura esta activada
      if (tarjeta.getLecturaActiva() == true) {
        tarjeta.setCodigoMagnetico(
            tarjeta.getcodigoMagnetico()! + event.logicalKey.keyLabel);
        print('- Código actual: ${tarjeta.getcodigoMagnetico()}');
      }

      //Capturamos el final del código mágnetico
      if (event.isKeyPressed(LogicalKeyboardKey.shiftLeft) &&
          event.isKeyPressed(LogicalKeyboardKey.slash) &&
          tarjeta.getLecturaActiva() == true) {
        //Analizamos el CB y buscamos al usuario en el listado por el id de tarjeta pos:10 len:4
        if (tarjeta.getcodigoMagnetico()!.length > 14) {
          String idTarjeta =
              tarjeta.getcodigoMagnetico().toString().substring(10, 14);
          //if (tarjeta.getcodigoMagnetico().length > 5) {
          //String idTarjeta = tarjeta.getcodigoMagnetico().substring(1, 5);
          if (idTarjeta.length > 0) {
            Persona? personaLeida =
                validarUsuarioTarjeta(idTarjeta, widget._personas);
            if (personaLeida!.id != null) {
              /*Parte parte = await Parte.getParteActivo(personaLeida);
                                mensaje = await registrarLectura(parte, personaLeida);*/
              var resultado = await Parte.registrarLectura(
                  personaLeida,
                  282,
                  widget.prefs,
                  extras.extraPlusPuestoTrabajo,
                  extras.extraCambioTurno);
              extras.clearCheckExtras();
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.of(context).pop(true);
                    });
                    return Notificacion(
                        tipo: resultado.toLowerCase().contains('salida')
                            ? Notificacion.logout
                            : Notificacion.login,
                        titulo: 'Registrado',
                        mensaje: resultado);
                  });
            } else {
              /*mensaje =
                                    'ERROR. Persona con tarjeta $idTarjeta no encontrada. Avisar a informática.';*/
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    Future.delayed(Duration(seconds: 3), () {
                      Navigator.of(context).pop(true);
                    });
                    return Notificacion(
                        tipo: Notificacion.error,
                        titulo: 'Error',
                        mensaje:
                            'Persona con tarjeta $idTarjeta no encontrada. Avisar a informática.');
                  });
            }
          }
        }

        print(
            '- Código magnetico capturado: ${tarjeta.getcodigoMagnetico.toString()}');
        tarjeta.setLecturaActiva(false);
        tarjeta.setCodigoMagnetico('');
        print('- Resultado lectura: $mensaje');
      }
    }
    return mensaje;
  }

  /*_renderizarOpcionesMarcaje(setstate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform.scale(
                scale: 2,
                child: Checkbox(
                    value: extraPlusPuestoTrabajo,
                    onChanged: (bool? newValue) {
                      setstate(() {
                        extraPlusPuestoTrabajo = newValue!;
                        myFocusNode.requestFocus();
                      });
                    }),
              ),
              Text('Plus puesto trabajo', style: TextStyle(fontSize: 20.0))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform.scale(
                scale: 2,
                child: Checkbox(
                    value: extraCambioTurno,
                    onChanged: (bool? newValue) {
                      setstate(() {
                        extraCambioTurno = newValue!;
                        myFocusNode.requestFocus();
                      });
                    }),
              ),
              Text('Cambio de turno', style: TextStyle(fontSize: 20.0))
            ],
          ),
        )
      ],
    );
  }*/

  /*_renderizarOpcionMarcaje(String texto, bool valor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Transform.scale(
            scale: 2,
            child: Checkbox(
                value: extraPlusPuestoTrabajo,
                onChanged: (bool? newValue) {
                  setState(() {
                    extraPlusPuestoTrabajo = newValue!;
                  });
                }),
          ),
          Text('Plus puesto trabajo', style: TextStyle(fontSize: 20.0))
        ],
      ),
    );
  }*/

  /*void clearCheckExtras() {
    setState(() {
      extraCambioTurno = false;
      extraPlusPuestoTrabajo = false;
    });
  }*/
}

Persona? validarUsuarioTarjeta(String idTarjeta, List<Persona> personas) {
  return MockPersonas.encontrarPersonaIdTarjeta(personas, idTarjeta);
}
