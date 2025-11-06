class Profesor {
  String NPROFESOR;
  String NOMBRE;
  String CARRERA;

  Profesor({
    required this.NPROFESOR,
    required this.NOMBRE,
    required this.CARRERA,
  });

  Map<String, dynamic> toJSON(){
    return {
      'NPROFESOR': NPROFESOR,
      'NOMBRE': NOMBRE,
      'CARRERA': CARRERA
    };
  }
}