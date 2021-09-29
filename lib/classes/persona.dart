class Persona {
  final String? id;
  final String? idTarjeta;
  final String? descripcion;
  final String? password;

  Persona({this.id, this.idTarjeta, this.descripcion, this.password});

  Future<void> funcionPruebas() async {
    await Future.delayed(Duration(seconds: 3), () {
      print('OK!');
    });
  }
}
