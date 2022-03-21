import 'package:presencia2/classes/http.dart';

class Estado {
  final int id;
  final String descri;
  final int orden;
  final String grupo;

  Estado(
      {required this.id,
      required this.descri,
      required this.orden,
      required this.grupo});

  factory Estado.fromMap(Map<String, dynamic> map) {
    return Estado(
        id: map['id'],
        descri: map['descri'],
        grupo: map['grupo'],
        orden: map['orden']);
  }

  static Future<List<Estado>> getListaEstadosPresencia() async {
    List<Estado> listaEstados = [];

    try {
      final resultado = await httpGet('estados');
      if (resultado.ok) {
        final data = List<Map<String, dynamic>>.from(
            resultado.data); //resultado.data as List<dynamic>;
        if (data.isNotEmpty) {
          listaEstados = data.map((e) => Estado.fromMap(e)).toList();
        }
      }
    } catch (e) {
      print(e);
    }

    return listaEstados;
  }
}
