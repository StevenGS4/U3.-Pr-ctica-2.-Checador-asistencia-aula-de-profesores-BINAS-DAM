import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:u3_practica2_controlasistencia/profesor.dart';
import 'package:u3_practica2_controlasistencia/asistencia.dart';
import 'package:u3_practica2_controlasistencia/horario.dart';
import 'package:u3_practica2_controlasistencia/materia.dart';

class DB {
  static Future<Database> _conexion() async {
    return openDatabase(
        join(await getDatabasesPath(), "base1.db"),
        version: 1,
        onConfigure: (db) async {
          await db.execute("PRAGMA foreign_keys = ON");
        },
        onCreate: (db, version) async {
          await db.execute("CREATE TABLE PROFESOR("
              "NPROFESOR TEXT PRIMARY KEY,"
              "NOMBRE TEXT,"
              "CARRERA TEXT"
              ")");

          await db.execute("CREATE TABLE MATERIA("
              "NMAT TEXT PRIMARY KEY,"
              "DESCRIPCION TEXT"
              ")");

          await db.execute("""
              CREATE TABLE HORARIO(
                  NHORARIO INTEGER PRIMARY KEY AUTOINCREMENT,
                  NPROFESOR TEXT,
                  NMAT TEXT,
                  HORA TEXT,
                  EDIFICIO TEXT,
                  SALON TEXT,
                  FOREIGN KEY (NPROFESOR) REFERENCES PROFESOR(NPROFESOR) 
                          ON DELETE CASCADE ON UPDATE CASCADE,
                  FOREIGN KEY (NMAT) REFERENCES MATERIA(NMAT) 
                           ON DELETE CASCADE ON UPDATE CASCADE
              );
          """);


          await db.execute("CREATE TABLE ASISTENCIA("
              "IDASISTENCIA INTEGER PRIMARY KEY AUTOINCREMENT,"
              "NHORARIO INTEGER,"
              "FECHA TEXT,"
              "ASISTENCIA INTEGER,"
              "FOREIGN KEY(NHORARIO) REFERENCES HORARIO(NHORARIO) ON DELETE CASCADE ON UPDATE CASCADE"
              ")");
        }
    );
  }

  // PROFESOR
  static Future<int> insertarProfesor(Profesor p) async {
    Database base = await _conexion();

    return base.insert("PROFESOR", p.toJSON());
  }

  static Future<List<Profesor>> mostrarProfesores() async {
    Database base = await _conexion();

    List<Map<String, dynamic>> temp = await base.query("PROFESOR");

    return List.generate(
        temp.length,
            (contador) {
          return Profesor(
              NPROFESOR: temp[contador]['NPROFESOR'],
              NOMBRE: temp[contador]['NOMBRE'],
              CARRERA: temp[contador]['CARRERA']
          );
        }
    );
  }

  static Future<int> actualizarProfesor(Profesor p) async {
    Database base = await _conexion();

    return base.update("PROFESOR", p.toJSON(), where: "NPROFESOR = ?", whereArgs: [p.NPROFESOR]);
  }

  static Future<int> eliminarProfesor(String NPROFESOR) async {
    Database base = await _conexion();

    return base.delete("PROFESOR", where: "NPROFESOR = ?", whereArgs: [NPROFESOR]);
  }

  // ASISTENCIA
  static Future<int> insertarAsistencia(Asistencia a) async {
    Database base = await _conexion();

    return base.insert("ASISTENCIA", a.toJSON());
  }

  static Future<List<Asistencia>> mostrarAsistencias() async {
    Database base = await _conexion();

    List<Map<String, dynamic>> temp = await base.query("ASISTENCIA");

    return List.generate(
        temp.length,
            (contador) {
          return Asistencia(
              IDASISTENCIA: temp[contador]['IDASISTENCIA'],
              NHORARIO: temp[contador]['NHORARIO'],
              FECHA: temp[contador]['FECHA'],
              ASISTENCIA: temp[contador]['ASISTENCIA']
          );
        }
    );
  }

  static Future<int> actualizarAsistencia(Asistencia a) async {
    Database base = await _conexion();

    return base.update("ASISTENCIA", a.toJSON(), where: "IDASISTENCIA = ?", whereArgs: [a.IDASISTENCIA]);
  }

  static Future<int> eliminarAsistencia(int IDASISTENCIA) async {
    Database base = await _conexion();

    return base.delete("ASISTENCIA", where: "IDASISTENCIA = ?", whereArgs: [IDASISTENCIA]);
  }

  //Materia
  static Future<int> insertarMateria(Materia m) async {
    final db = await _conexion();
    return db.insert("MATERIA", m.toJSON(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Materia>> mostrarMaterias() async {
    final db = await _conexion();
    final data = await db.query("MATERIA");
    return List.generate(data.length, (i) => Materia.fromMap(data[i]));
  }

  static Future<int> eliminarMateria(String nmat) async {
    final db = await _conexion();
    return db.delete("MATERIA", where: "NMAT = ?", whereArgs: [nmat]);
  }

  static Future<int> actualizarMateria(Materia m) async {
    final db = await _conexion();
    return db.update(
      "MATERIA",
      m.toJSON(),
      where: "NMAT = ?",
      whereArgs: [m.NMAT],
    );
  }

  static Future<bool> existeProfesor(String id) async {
    final db = await _conexion();
    final r = await db.query("PROFESOR", where: "NPROFESOR = ?", whereArgs: [id], limit: 1);
    return r.isNotEmpty;
  }
  static Future<bool> existeMateria(String id) async {
    final db = await _conexion();
    final r = await db.query("MATERIA", where: "NMAT = ?", whereArgs: [id], limit: 1);
    return r.isNotEmpty;
  }


  // INSERTAR
  static Future<int> insertarHorario(Horario h) async {
    final db = await _conexion();
    // No mandamos NHORARIO en inserts:
    return db.insert("HORARIO", h.toInsertMap());
  }

// MOSTRAR
  static Future<List<Horario>> mostrarHorarios() async {
    final db = await _conexion();
    final data = await db.query("HORARIO", orderBy: "NHORARIO DESC");
    return List.generate(data.length, (i) => Horario.fromMap(data[i]));
  }

// ACTUALIZAR
  static Future<int> actualizarHorario(Horario h) async {
    final db = await _conexion();
    return db.update(
      "HORARIO",
      h.toJSON(), // aquí sí puede ir NHORARIO (igual al actual)
      where: "NHORARIO = ?",
      whereArgs: [h.NHORARIO],
    );
  }

// ELIMINAR
  static Future<int> eliminarHorario(int id) async {
    final db = await _conexion();
    return db.delete("HORARIO", where: "NHORARIO = ?", whereArgs: [id]);
  }


  // CONSULTA 1: Profesores con clase a las 8:00 en edificio UD
  static Future<List<Map<String, dynamic>>> profesoresClase8UD() async {
    final db = await _conexion();
    return await db.rawQuery('''
    SELECT P.NOMBRE, H.HORA, H.EDIFICIO, H.SALON
    FROM PROFESOR P
    INNER JOIN HORARIO H ON P.NPROFESOR = H.NPROFESOR
    WHERE H.HORA LIKE '%8:00%' AND H.EDIFICIO = 'UD'
  ''');
  }

// CONSULTA 2: Profesores que asistieron en una fecha específica
  static Future<List<Map<String, dynamic>>> profesoresAsistieron(String fecha) async {
    final db = await _conexion();
    return await db.rawQuery('''
    SELECT DISTINCT P.NOMBRE, M.DESCRIPCION, A.FECHA
    FROM PROFESOR P
    INNER JOIN HORARIO H ON P.NPROFESOR = H.NPROFESOR
    INNER JOIN MATERIA M ON M.NMAT = H.NMAT
    INNER JOIN ASISTENCIA A ON A.NHORARIO = H.NHORARIO
    WHERE A.FECHA = ?
    AND A.ASISTENCIA = 1
  ''', [fecha]);
  }

// CONSULTA 3: Materias y horarios por profesor
  static Future<List<Map<String, dynamic>>> materiasPorProfesor() async {
    final db = await _conexion();
    return await db.rawQuery('''
    SELECT P.NOMBRE AS PROFESOR, M.DESCRIPCION AS MATERIA, H.HORA, H.SALON
    FROM PROFESOR P
    INNER JOIN HORARIO H ON P.NPROFESOR = H.NPROFESOR
    INNER JOIN MATERIA M ON M.NMAT = H.NMAT
    ORDER BY P.NOMBRE
  ''');
  }


}