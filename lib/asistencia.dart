class Asistencia {
  int? IDASISTENCIA;
  int NHORARIO;
  String FECHA;
  int ASISTENCIA;

  Asistencia({
    this.IDASISTENCIA,
    required this.NHORARIO,
    required this.FECHA,
    required this.ASISTENCIA
  });

  Map<String, dynamic> toJSON() {
    return {
      'NHORARIO': NHORARIO,
      'FECHA': FECHA,
      'ASISTENCIA': ASISTENCIA
    };
  }
}