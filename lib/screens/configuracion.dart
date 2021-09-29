import 'package:flutter/material.dart';
import '../styles/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Configuracion extends StatefulWidget {
  final SharedPreferences prefs;
  final bool inicial;
  Configuracion(this.prefs, this.inicial);

  @override
  _ConfiguracionState createState() => _ConfiguracionState(prefs, inicial);
}

class _ConfiguracionState extends State<Configuracion> {
  final SharedPreferences prefs;
  final bool inicial;

  _ConfiguracionState(this.prefs, this.inicial);
  @override
  Widget build(BuildContext context) {
    final int? deviceID = prefs.getInt('DeviceID');
    final String? deviceName = prefs.getString('DeviceName');
    final String? apiServer = prefs.getString('APIServer');
    const String deviceIDLabel = 'ID Dispositivo';
    const String deviceNameLabel = 'Nombre Dispositivo';
    const String apiServerLabel = 'Dirección Servidor API';
    const String deviceIDTooltip = 'ej.: 75';
    const String deviceNameTooltip = 'ej.: PDP01';
    const String apiServerTooltip = 'ej.: 192.168.123.200:8001';

    return Scaffold(
        appBar: AppBar(
          title: Text('Configuración', style: Styles.defaultText),
          actions: [
            MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.check)),
            MaterialButton(onPressed: () {}, child: Icon(Icons.close)),
          ],
        ),
        body: ListView(children: <Widget>[
          Card(
              child: ListTile(
                  leading:
                      const Icon(Icons.perm_device_info, color: Colors.blue),
                  title: const Text('ID Dispositivo'),
                  subtitle: Text(deviceID == null ? '' : deviceID.toString()),
                  onTap: () async {
                    final int resultado = await _configurarPropiedadInt(
                        context, deviceIDLabel, deviceID, deviceIDTooltip);
                    if (resultado > 0) {
                      prefs.setInt('DeviceID', resultado);
                    }
                  })),
          Card(
              child: ListTile(
                  leading:
                      const Icon(Icons.perm_device_info, color: Colors.blue),
                  title: const Text(deviceNameLabel),
                  subtitle: Text(deviceName == null ? '' : deviceName),
                  onTap: () async {
                    final String resultado = await _configurarPropiedadString(
                        context,
                        deviceNameLabel,
                        deviceName == null ? '' : deviceName,
                        deviceNameTooltip);
                    if (resultado.isNotEmpty) {
                      prefs.setString('DeviceName', resultado);
                    }
                  })),
          Card(
              child: ListTile(
                  leading: const Icon(Icons.api, color: Colors.green),
                  title: const Text(apiServerLabel),
                  subtitle: Text(apiServer == null ? '' : apiServer),
                  onTap: () async {
                    final String resultado = await _configurarPropiedadString(
                        context,
                        apiServerLabel,
                        apiServer == null ? '' : apiServer,
                        apiServerTooltip);
                    if (resultado.isNotEmpty) {
                      prefs.setString('APIServer', resultado);
                    }
                  })),
          mensajeReiniciarDispositivo()
        ]));
  }

  Card mensajeReiniciarDispositivo() {
    return Card(
        color: Colors.red[100],
        child: ListTile(
            leading: const Icon(
              Icons.warning,
              color: Colors.red,
            ),
            title:
                const Text('Reinicie el dispostivo para aplicar los cambios')));
  }

  Future<int> _configurarPropiedadInt(BuildContext context,
      String descripcionPropiedad, int? valorActual, String toolTip) async {
    TextEditingController inputController = new TextEditingController();
    int resultado = 0;
    inputController.text = valorActual == null ? '' : valorActual.toString();

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              contentPadding: const EdgeInsets.all(4.0),
              content: new Column(children: <Widget>[
                new TextField(
                    controller: inputController,
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: descripcionPropiedad, hintText: toolTip)),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new MaterialButton(
                          child: const Text('CANCELAR'),
                          onPressed: () {
                            Navigator.pop(context, '0');
                          }),
                      new MaterialButton(
                          child: const Text('GUARDAR'),
                          onPressed: () {
                            Navigator.pop(context, inputController.text);
                          }),
                    ])
              ]));
        }).then((valor) {
      setState(() {
        if (valor == null || valor == '') {
          valor = '0';
        }
        resultado = int.parse(valor);
      });
    });

    return resultado;
  }

  Future<String> _configurarPropiedadString(BuildContext context,
      String descripcionPropiedad, String valorActual, String toolTip) async {
    TextEditingController inputController = new TextEditingController();
    String resultado = '';
    inputController.text = valorActual;

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: const EdgeInsets.all(4.0),
              content: new Column(children: <Widget>[
                new TextField(
                    controller: inputController,
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: descripcionPropiedad, hintText: toolTip)),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new MaterialButton(
                          child: const Text('CANCELAR'),
                          onPressed: () {
                            Navigator.pop(context, '');
                          }),
                      new MaterialButton(
                          child: const Text('GUARDAR'),
                          onPressed: () {
                            Navigator.pop(context, inputController.text);
                          }),
                    ])
              ]));
        }).then((valor) {
      setState(() {
        if (valor == null) {
          valor = '';
        }
        resultado = valor.toString();
      });
    });

    return resultado;
  }
}
