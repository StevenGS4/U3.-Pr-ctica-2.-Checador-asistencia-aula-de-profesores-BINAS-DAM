import 'package:flutter/material.dart';
import 'package:u3_practica2_controlasistencia/basedatos.dart';
import 'package:u3_practica2_controlasistencia/profesor.dart';

class actualizarprofesor extends StatefulWidget {
  final Profesor profe;
  const actualizarprofesor({super.key, required this.profe});

  @override
  State<actualizarprofesor> createState() => _actualizarprofesorState();
}

class _actualizarprofesorState extends State<actualizarprofesor> {
  final nprofesor = TextEditingController();
  final nombre = TextEditingController();
  final carrera = TextEditingController();

  @override
  void initState() {
    super.initState();
    nprofesor.text = widget.profe.NPROFESOR;
    nombre.text = widget.profe.NOMBRE;
    carrera.text = widget.profe.CARRERA;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Actualizar Profesor"),
      ),

      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Actualizar datos del profesor:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                ),
              ],
            ),
            SizedBox(height: 16,),
      
            TextField(
              controller: nprofesor,
              readOnly: true,
              decoration: InputDecoration(
                  labelText: "ID Profesor",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.3)
                  )
              ),
            ),
      
            SizedBox(height: 16,),
            TextField(
              controller: nombre,
              decoration: InputDecoration(
                  labelText: "Nombre:",
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: "Nombre de profesor",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.3
                      )
                  )
              ),
            ),
      
            SizedBox(height: 16,),
            TextField(
              controller: carrera,
              decoration: InputDecoration(
                  labelText: "Carrera:",
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: "Carrera que imparte",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.3)
                  )
              ),
            ),
      
            SizedBox(height: 20,),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      if (nombre.text.trim().isEmpty || carrera.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Debe llenar todos los campos",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            backgroundColor: Colors.black,
                          ),
                        );
                        return;
                      }
      
                      Profesor p = Profesor(
                          NPROFESOR: nprofesor.text,
                          NOMBRE: nombre.text,
                          CARRERA: carrera.text
                      );
      
                      DB.actualizarProfesor(p).then((res) {
                        if (res > 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Profesor actualizado correctamente",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.green,
                              )
                          );
      
                          Navigator.pop(context, true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error al actualizar profesor",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.redAccent,
                              )
                          );
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 6),
                        Text(
                          "Actualizar profesor",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              letterSpacing: 1.5
                          ),
                        )
                      ],
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
