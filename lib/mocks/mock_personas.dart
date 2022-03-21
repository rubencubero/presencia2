import 'package:presencia2/classes/persona.dart';
import '../classes/http.dart';

class MockPersonas extends Persona {
  static final List<Persona> personas = [];

  MockPersonas() : super(isLogged: false);

  static Future<List<Persona>> getPersonas(int? puntoAcceso) async {
    try {
      personas.clear();
      var result = await httpGet('personas/' + puntoAcceso.toString());
      if (result.ok) {
        var listaPersonas = result.data as List<dynamic>;
        listaPersonas.forEach((persona) {
          personas.add(Persona(
              id: persona['id'].toString(),
              idTarjeta: persona['idtarjeta'].toString(),
              descripcion: persona['descri'].toString(),
              password: persona['pwd'].toString(),
              isLogged: persona['isLogged'] == 1 ? true : false));
        });
      }
    } catch (e) {
      print(e);
    }

    return personas;
  }

  static Persona encontrarPersonaIdTarjeta(
      List<Persona> listaPersonas, String idTarjeta) {
    return listaPersonas.firstWhere((p) => p.idTarjeta == idTarjeta,
        orElse: () {
      return Persona(isLogged: false);
    });
  }
}
