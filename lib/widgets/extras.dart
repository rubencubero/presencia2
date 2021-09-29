import 'package:flutter/material.dart';

class Extras extends StatefulWidget {
  bool _extraPlusPuestoTrabajo = false;
  bool _extraCambioTurno = false;
  Extras({Key? key}) : super(key: key);

  bool get extraPlusPuestoTrabajo => _extraPlusPuestoTrabajo;
  bool get extraCambioTurno => _extraCambioTurno;

  @override
  _ExtrasState createState() => _ExtrasState();
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
                          _renderizarOpcionesMarcaje(setstate)
                        ],
                      ));
                },
              );
            },
          );
        });
  }

  _renderizarOpcionesMarcaje(setstate) {
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
                    value: widget._extraPlusPuestoTrabajo,
                    onChanged: (bool? newValue) {
                      setstate(() {
                        widget._extraPlusPuestoTrabajo = newValue!;
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
                    value: widget._extraCambioTurno,
                    onChanged: (bool? newValue) {
                      setstate(() {
                        widget._extraCambioTurno = newValue!;
                      });
                    }),
              ),
              Text('Cambio de turno', style: TextStyle(fontSize: 20.0))
            ],
          ),
        )
      ],
    );
  }
}
