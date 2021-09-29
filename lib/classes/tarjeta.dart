class Tarjeta {
  String? codigoMagnetico;
  bool? lecturaActiva;

  String? getcodigoMagnetico() {
    return codigoMagnetico;
  }

  bool? getLecturaActiva() {
    if (lecturaActiva == null) {
      lecturaActiva = false;
    }
    return lecturaActiva;
  }

  void setCodigoMagnetico(String codigoMagnetico) {
    this.codigoMagnetico = codigoMagnetico;
  }

  void setLecturaActiva(bool valor) {
    this.lecturaActiva = valor;
  }

  Tarjeta({this.codigoMagnetico, this.lecturaActiva});
}
