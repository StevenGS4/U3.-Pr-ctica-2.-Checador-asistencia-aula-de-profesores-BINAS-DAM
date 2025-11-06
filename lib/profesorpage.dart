import 'dart:math';
import 'package:flutter/material.dart';
import 'package:u3_practica2_controlasistencia/actualizarprofesor.dart';
import 'package:u3_practica2_controlasistencia/basedatos.dart';
import 'package:u3_practica2_controlasistencia/profesor.dart';

class ProfesorPage extends StatefulWidget {
  const ProfesorPage({super.key});

  @override
  State<ProfesorPage> createState() => _ProfesorPageState();
}

class _ProfesorPageState extends State<ProfesorPage> {
  final nprofesor = TextEditingController();
  final nombre = TextEditingController();
  final carrera = TextEditingController();

  List<Profesor> datos = [];

  void actualizarLista() async {
    List<Profesor> temp = await DB.mostrarProfesores();

    setState(() {
      datos = temp;
    });
  }

  void generarID() {
    int id = Random().nextInt(90000) + 10000;
    setState(() {
      nprofesor.text = id.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    generarID();
    actualizarLista();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          Row(
            children: [
              Text("Ingrese los datos siguientes:",
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
              labelStyle: TextStyle(
                color: Colors.black
              ),
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
            controller: nombre,
            decoration: InputDecoration(
              labelText: "Nombre:",
              labelStyle: TextStyle(
                color: Colors.black
              ),
              hintText: "Nombre de Profesor",
              hintStyle: TextStyle(
                color: Colors.grey
              ),
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
                labelStyle: TextStyle(
                  color: Colors.black
                ),
                hintText: "Carrera que imparte",
                hintStyle: TextStyle(
                    color: Colors.grey
                ),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.3
                    )
                )
            ),
          ),
          SizedBox(height: 20,),

          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: (){
                    if (nombre.text.trim().isEmpty || carrera.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
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
                
                    DB.insertarProfesor(p).then(
                            (res) {
                          if(res <= 0) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text("Error al agregar al profesor",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              backgroundColor: Colors.redAccent,
                            )
                            );
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text("Profesor agregado correctamente",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),),
                              backgroundColor: Colors.green,
                            )
                            );
                            actualizarLista();
                            generarID();
                            nombre.clear();
                            carrera.clear();
                          }
                        }
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outlined),
                      SizedBox(width: 6,),
                      Text("Agregar profesor",
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
              SizedBox(width: 10,),
              FilledButton(
                  onPressed: (){
                    nombre.clear();
                    carrera.clear();
                  },
                  child: Icon(Icons.cleaning_services_rounded),
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.black
                  ),
              )
            ],
          ),

          SizedBox(height: 10,),
          Divider(),
          SizedBox(height: 10,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Lista de Profesores:",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
              IconButton(
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (x) {
                          return AlertDialog(
                            title: Row(
                              children: [
                                Icon(Icons.info, color: Colors.blue,),
                                SizedBox(width: 8,),
                                Text("Información",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            content: Text("Toca una tarjeta para editar los datos del profesor.",
                              style: TextStyle(
                                  fontSize: 16,
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  child: Text("Aceptar",
                                    style: TextStyle(color: Colors.black),)
                              )
                            ],
                          );
                        }
                    );
                  },
                  icon: CircleAvatar(
                    child: Icon(Icons.question_mark, size: 20, color: Colors.white,),
                    radius: 18,
                    backgroundColor: Colors.black,
                  )
              )
            ],
          ),
          SizedBox(height: 8,),
          Expanded(
              child: ListView.builder(
                itemCount: datos.length,
                  itemBuilder: (context, contador) {
                  return Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.person, color: Colors.black87),
                          backgroundColor: Colors.blueGrey[100],
                          radius: 22,
                        ),
                        title: Text("ID: " + datos[contador].NPROFESOR,
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nombre: " + datos[contador].NOMBRE,
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold
                              ),),
                            Text("Carrera: " + datos[contador].CARRERA,
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold
                              ),)
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: (){
                            DB.eliminarProfesor(datos[contador].NPROFESOR)
                                .then((res) {
                                  showDialog(
                                      context: context,
                                      builder: (x) {
                                        return AlertDialog(
                                          title: Row(
                                            children: [
                                              Icon(Icons.warning, color: Colors.yellow[800],),
                                              SizedBox(width: 6,),
                                              Text("¡Advertencia!",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: Text("¿Estas seguro de eliminar este registro?",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          actions: [
                                            FilledButton(
                                                onPressed: (){
                                                  actualizarLista();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text("Profesor eliminado correctamente",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                    backgroundColor: Colors.redAccent,
                                                  )
                                                  );
                                                  Navigator.pop(context);
                                                },
                                                style: FilledButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  padding: EdgeInsets.only(left: 15, right: 15)
                                                ),
                                                child: Text("Aceptar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                                            ),
                                            TextButton(
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Cancelar", style: TextStyle(color: Colors.black87))
                                            ),
                                          ],
                                        );
                                      }
                                  );
                            });
                          },
                          icon: Icon(Icons.delete), color: Colors.red,
                        ),

                        onTap: () async {
                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (x) => actualizarprofesor(profe: datos[contador]))
                          );

                          if (result == true) {
                            actualizarLista();
                          }
                        },
                      ),
                    )
                  );
                }
              )
          ),
        ],
      ),
    );
  }
}

