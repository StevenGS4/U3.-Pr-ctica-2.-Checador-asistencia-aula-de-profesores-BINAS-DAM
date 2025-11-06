class Materia {
  String NMAT;
  String DESCRIPCION;

  Materia({
    required this.NMAT,
    required this.DESCRIPCION,
  });

  Map<String, dynamic> toJSON() {
    return {
      'NMAT': NMAT,
      'DESCRIPCION': DESCRIPCION,
    };
  }

  factory Materia.fromMap(Map<String, dynamic> map) {
    return Materia(
      NMAT: map['NMAT'],
      DESCRIPCION: map['DESCRIPCION'],
    );
  }
}
