import 'package:flutter/material.dart';

@immutable
class Extras extends StatefulWidget {
  bool _extraPlusPuestoTrabajo = false;
  bool _extraCambioTurno = false;
  bool _extraColaboracion = false;
  bool _extraFormacion = false;
  Extras({Key? key}) : super(key: key);

  bool get extraPlusPuestoTrabajo => _extraPlusPuestoTrabajo;
  bool get extraCambioTurno => _extraCambioTurno;
  bool get extraColaboracion => _extraColaboracion;
  bool get extraFormacion => _extraFormacion;

  @override
  _ExtrasState createState() => _ExtrasState();

  void clearCheckExtras() {
    _extraPlusPuestoTrabajo = false;
    _extraCambioTurno = false;
    _extraColaboracion = false;
    _extraFormacion = false;
  }

  Widget renderizarPlusesMarcaje(setstate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('PLUSES:', style: TextStyle(fontSize: 20.0)),
          SizedBox(width: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform.scale(
                scale: 2,
                child: Checkbox(
                    value: _extraPlusPuestoTrabajo,
                    onChanged: (bool? newValue) {
                      setstate(() {
                        _extraPlusPuestoTrabajo = newValue!;
                      });
                    }),
              ),
              SizedBox(width: 10),
              Text('Puesto trabajo', style: TextStyle(fontSize: 20.0))
            ],
          ),
          SizedBox(width: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform.scale(
                scale: 2,
                child: Checkbox(
                    value: _extraCambioTurno,
                    onChanged: (bool? newValue) {
                      setstate(() {
                        _extraCambioTurno = newValue!;
                      });
                    }),
              ),
              SizedBox(width: 10),
              Text('Cambio de turno', style: TextStyle(fontSize: 20.0))
            ],
          )
        ],
      ),
    );
  }

  Widget renderizarTipoPresencia(setstate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('TIPO:', style: TextStyle(fontSize: 20.0)),
          SizedBox(width: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform.scale(
                scale: 2,
                child: Checkbox(
                    value: _extraColaboracion,
                    onChanged: (bool? newValue) {
                      setstate(() {
                        _extraColaboracion = newValue!;
                      });
                    }),
              ),
              SizedBox(width: 10),
              Text('Colaboración', style: TextStyle(fontSize: 20.0))
            ],
          ),
          SizedBox(width: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform.scale(
                scale: 2,
                child: Checkbox(
                    value: _extraFormacion,
                    onChanged: (bool? newValue) {
                      setstate(() {
                        _extraFormacion = newValue!;
                      });
                    }),
              ),
              SizedBox(width: 10),
              Text('Formación', style: TextStyle(fontSize: 20.0))
            ],
          )
        ],
      ),
    );
  }
}

class _ExtrasState extends State<Extras> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.lightGreen.shade300)),
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
                                          MaterialStateProperty.all<double>(0)),
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
                          //_renderizarOpcionesMarcaje(setstate)
                        ],
                      ));
                },
              );
            },
          );
        });
  }
}
