import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../classes/notificacion.dart';
import '../styles/styles.dart';

class PinCode extends StatefulWidget {
  final String pin;
  final bool ok = false;
  PinCode(this.pin);

  @override
  _PinCodeState createState() => _PinCodeState(pin);
}

class _PinCodeState extends State<PinCode> {
  final String pin;
  _PinCodeState(this.pin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0xFFDCEDC8),
        Color(0xFFAED581),
      ], begin: Alignment.topRight)),
      child: PinCodeScreen(pin),
    ));
  }
}

class PinCodeScreen extends StatefulWidget {
  final String pin;
  final bool ok = false;

  PinCodeScreen(this.pin);

  @override
  _PinCodeScreenState createState() => _PinCodeScreenState(pin);
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  final String pin;
  _PinCodeScreenState(this.pin);

  List<String> pinActual = ['', '', '', ''];
  TextEditingController controlPinUno = TextEditingController();
  TextEditingController controlPinDos = TextEditingController();
  TextEditingController controlPinTres = TextEditingController();
  TextEditingController controlPinCuatro = TextEditingController();
  int pinIndex = 0;

  var bordeExteriorEntrada = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.transparent),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          construirBotonSalir(),
          Container(
              //color: Colors.orange,
              height: 250,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: 200,
                        alignment: Alignment.topCenter,
                        //color: Colors.blueGrey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            construirTextoPin(),
                            SizedBox(height: 40.0),
                            construirFilaPIN(),
                          ],
                        )),
                    Container(
                        width: 250,
                        alignment: Alignment.topCenter,
                        child: construirPanelNumerico())
                    /*Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[construirPanelNumerico()])*/
                  ])),
        ],
      ),
    );
  }

  construirBotonSalir() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              onPressed: () {
                cerrarPinCode(false);
              },
              height: 50.0,
              minWidth: 50.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Icon(
                Icons.clear,
                color: Colors.black,
              ),
            ))
      ],
    );
  }

  cerrarPinCode(bool ok) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context, ok);
    } else {
      SystemNavigator.pop();
    }
  }

  construirTextoPin() {
    return Text(
      "PIN Seguridad",
      style: Styles.defaultText,
    );
  }

  construirFilaPIN() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        NumeroPIN(
          outlineInputBorder: bordeExteriorEntrada,
          textEditingController: controlPinUno,
        ),
        NumeroPIN(
          outlineInputBorder: bordeExteriorEntrada,
          textEditingController: controlPinDos,
        ),
        NumeroPIN(
          outlineInputBorder: bordeExteriorEntrada,
          textEditingController: controlPinTres,
        ),
        NumeroPIN(
          outlineInputBorder: bordeExteriorEntrada,
          textEditingController: controlPinCuatro,
        )
      ],
    );
  }

  construirPanelNumerico() {
    return Container(
        //color: Colors.red,
        height: 250,
        alignment: Alignment.center,
        child: Container(
            //color: Colors.blue,
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TeclaNumerica(
                  numero: 1,
                  onPressed: () {
                    gestionarNotificacion(pinIndexSetup('1', pin));
                  },
                ),
                TeclaNumerica(
                  numero: 2,
                  onPressed: () {
                    gestionarNotificacion(pinIndexSetup('2', pin));
                  },
                ),
                TeclaNumerica(
                  numero: 3,
                  onPressed: () {
                    gestionarNotificacion(pinIndexSetup('3', pin));
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TeclaNumerica(
                  numero: 4,
                  onPressed: () {
                    gestionarNotificacion(pinIndexSetup('4', pin));
                  },
                ),
                TeclaNumerica(
                  numero: 5,
                  onPressed: () {
                    gestionarNotificacion(pinIndexSetup('5', pin));
                  },
                ),
                TeclaNumerica(
                  numero: 6,
                  onPressed: () {
                    gestionarNotificacion(pinIndexSetup('6', pin));
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TeclaNumerica(
                  numero: 7,
                  onPressed: () {
                    gestionarNotificacion(pinIndexSetup('7', pin));
                  },
                ),
                TeclaNumerica(
                  numero: 8,
                  onPressed: () {
                    gestionarNotificacion(pinIndexSetup('8', pin));
                  },
                ),
                TeclaNumerica(
                  numero: 9,
                  onPressed: () {
                    gestionarNotificacion(pinIndexSetup('9', pin));
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 60.0,
                  child: MaterialButton(
                    onPressed: null,
                    child: SizedBox(),
                  ),
                ),
                TeclaNumerica(
                  numero: 0,
                  onPressed: () {
                    gestionarNotificacion(pinIndexSetup('0', pin));
                  },
                ),
                Container(
                  width: 60.0,
                  child: MaterialButton(
                      height: 50.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      onPressed: () {
                        removeLastPin();
                      },
                      child: Icon(Icons.backspace, size: 36)),
                )
              ],
            )
          ],
        )));
  }

  int gestionarNotificacion(int resultado) {
    int _resultado = resultado;
    if (resultado < 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return Notificacion(
                tipo: 1,
                titulo: 'Error',
                mensaje: 'PIN Incorrecto. Vuelva a intentarlo.');
          });
      clearPin();
    }
    return _resultado;
  }

  int pinIndexSetup(String text, String pin) {
    int resultado = 0;
    print('Indice actual: $pinIndex');
    if (pinIndex == 0) {
      pinIndex = 1;
    } else if (pinIndex < 4) {
      pinIndex++;
    }

    setPin(pinIndex, text);
    pinActual[pinIndex - 1] = text;
    String strPin = '';
    pinActual.forEach((e) {
      strPin += e;
    });
    if (pinIndex == 4) {
      print('Pin introducido: $strPin');
      if (pin == strPin) {
        print('Pin correcto');
        resultado = 1;
        cerrarPinCode(true);
      } else {
        print('Pin incorrecto');
        resultado = -1;
      }
    }
    return resultado;
  }

  removeLastPin() {
    print('removeLastPin inicio -> Indice actual: $pinIndex');
    if (pinIndex == 0) {
      pinIndex = 0;
    } else if (pinIndex <= 4) {
      setPin(pinIndex, '');
      pinActual[pinIndex - 1] = '';
      pinIndex--;
    } else {
      setPin(pinIndex, '');
      pinActual[pinIndex - 1] = '';
    }
    print('removeLastPin fin -> Indice actual: $pinIndex');
  }

  clearPin() {
    int i = 4;
    for (i = 4; i > 0; i--) {
      setPin(i, '');
      pinActual[i - 1] = '';
    }
    pinIndex = 0;
  }

  setPin(int n, String text) {
    switch (n) {
      case 1:
        controlPinUno.text = text;
        break;
      case 2:
        controlPinDos.text = text;
        break;
      case 3:
        controlPinTres.text = text;
        break;
      case 4:
        controlPinCuatro.text = text;
        break;
    }
    print('Pin introducido -> pos: $n, valor: $text');
  }
}

class NumeroPIN extends StatelessWidget {
  final TextEditingController textEditingController;
  final OutlineInputBorder outlineInputBorder;

  NumeroPIN(
      {required this.textEditingController, required this.outlineInputBorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      child: TextField(
          controller: textEditingController,
          enabled: false,
          obscureText: true,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16.0),
            border: outlineInputBorder,
            filled: true,
            fillColor: Colors.white30,
          ),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21.0,
            color: Colors.white,
          )),
    );
  }
}

class TeclaNumerica extends StatelessWidget {
  final int numero;
  final Function() onPressed;
  TeclaNumerica({required this.numero, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.lightGreen[50]!.withOpacity(0.5),
      ),
      alignment: Alignment.center,
      child: MaterialButton(
        padding: EdgeInsets.all((2.0)),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        height: 70.0,
        child: Text('$numero',
            textAlign: TextAlign.center, style: Styles.pinCodeButtonText),
      ),
    );
  }
}
