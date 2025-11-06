class Horario {
  int? NHORARIO;
  String NPROFESOR;
  String NMAT;
  String HORA;
  String EDIFICIO;
  String SALON;

  Horario({
    this.NHORARIO,
    required this.NPROFESOR,
    required this.NMAT,
    required this.HORA,
    required this.EDIFICIO,
    required this.SALON,
  });

  Map<String, dynamic> toJSON() => {
    'NHORARIO': NHORARIO,
    'NPROFESOR': NPROFESOR,
    'NMAT': NMAT,
    'HORA': HORA,
    'EDIFICIO': EDIFICIO,
    'SALON': SALON,
  };

  // <-- Úsalo al insertar: NO incluye NHORARIO
  Map<String, dynamic> toInsertMap() => {
    'NPROFESOR': NPROFESOR,
    'NMAT': NMAT,
    'HORA': HORA,
    'EDIFICIO': EDIFICIO,
    'SALON': SALON,
  };

  factory Horario.fromMap(Map<String, dynamic> map) => Horario(
    NHORARIO: map['NHORARIO'],
    NPROFESOR: map['NPROFESOR'],
    NMAT: map['NMAT'],
    HORA: map['HORA'],
    EDIFICIO: map['EDIFICIO'],
    SALON: map['SALON'],
  );
}
