import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presencia2/classes/notificacion.dart';
import 'package:presencia2/classes/parte.dart';
import 'package:presencia2/widgets/extras.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/persona.dart';
import '../styles/styles.dart';
import 'pinCode.dart';

class ListadoPersonas extends StatefulWidget {
  final List<Persona> _personas;
  final SharedPreferences prefs;
  ListadoPersonas(this._personas, this.prefs);

  @override
  _ListadoPersonasState createState() => _ListadoPersonasState();
}

class _ListadoPersonasState extends State<ListadoPersonas> {
  Extras extras = Extras();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[300],
        title: Text('Presencia', style: Styles.defaultText),
      ),
      body:
          GridView.count(crossAxisCount: 4, children: _buildGridCards(context)),
      //floatingActionButton: extras,
    );
  }

  List<Widget> _buildGridCards(BuildContext context) {
    return List.generate(widget._personas.length, (index) {
      var persona = this.widget._personas[index];
      return InkResponse(
          onTap: () => !persona.isLogged
              ? _navegarPinCode(context, persona)
              : _showExtras(persona),
          child: Card(
            color: persona.isLogged ? Colors.lightGreen[100] : Colors.white,
            clipBehavior: Clip.antiAlias,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 5 / 2,
                    child: Image.asset('assets/images/user_solid.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${persona.descripcion}',
                          style: Styles.cardText,
                        ),
                        SizedBox(height: 1.0),
                      ],
                    ),
                  ),
                ]),
          )

          /*
          Column(
                children: [
                  Checkbox(onChanged: (bool? newValue) {}, value: false),
                  Checkbox(onChanged: (bool? newValue) {}, value: false)
                ],
              )
          */
          /*child: Card(            
            clipBehavior: Clip.antiAlias,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 5 / 2,
                    child: Image.asset('assets/images/user_solid.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${persona.descripcion}',
                          style: Styles.cardText,
                        ),
                        SizedBox(height: 1.0),
                      ],
                    ),
                  ),
                ]),
          )*/
          );
    });
  }

  void _navegarPinCode(BuildContext context, Persona persona) async {
    final resultado = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PinCode(persona.password.toString())));
    if (resultado) {
      var resultado = await Parte.registrarLectura(
          persona,
          313,
          widget.prefs,
          extras.extraPlusPuestoTrabajo,
          extras.extraCambioTurno,
          extras.extraColaboracion,
          extras.extraFormacion);
      print(resultado.toString());
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
              if (resultado.toLowerCase().contains('salida'))
                Navigator.of(context).pop(true);
            });
            return Notificacion(
                tipo: resultado.toLowerCase().contains('salida')
                    ? Notificacion.logout
                    : Notificacion.login,
                titulo: 'Registrado',
                mensaje: resultado);
          });

      cerrarListadoPersonas(context);
    }
  }

  void _showExtras(Persona persona) {
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${persona.descripcion} marca los extras necesarios antes de desconectar.',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                elevation:
                                    MaterialStateProperty.all<double>(0)),
                            child: Icon(Icons.close_rounded,
                                size: 30.0, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ]),
                    SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            extras.renderizarTipoPresencia(setstate),
                            Divider(
                              color: Colors.black54,
                              indent: 0,
                            ),
                            extras.renderizarPlusesMarcaje(setstate),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                      EdgeInsets.symmetric(
                                          vertical: 30, horizontal: 20)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.lightGreen.shade300)),
                              child: Text(
                                'Desconectar',
                                style: TextStyle(fontSize: 30.0),
                              ),
                              onPressed: () =>
                                  _navegarPinCode(context, persona)),
                        )
                      ],
                    )
                  ],
                ));
          },
        );
      },
    );
  }

  cerrarListadoPersonas(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
  }
}
