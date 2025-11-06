import 'package:flutter/material.dart';
import 'package:u3_practica2_controlasistencia/actualizarasistencia.dart';
import 'package:u3_practica2_controlasistencia/asistencia.dart';
import 'package:u3_practica2_controlasistencia/basedatos.dart';
import 'package:u3_practica2_controlasistencia/horario.dart';

class AsistenciaPage extends StatefulWidget {
  const AsistenciaPage({super.key});

  @override
  State<AsistenciaPage> createState() => _AsistenciaPageState();
}

class _AsistenciaPageState extends State<AsistenciaPage> {
  final nhorario = TextEditingController();
  final fecha = TextEditingController();
  final asistencia = TextEditingController();

  int asistenciaValue = 1;

  List<Asistencia> datos = [];
  List<Horario> horarios = [];

  int? idSeleccionado;

  void actualizarLista() async {
    List<Asistencia> temp = await DB.mostrarAsistencias();

    setState(() {
      datos = temp;
    });
  }

  void cargarHorarios() async {
    List<Horario> temp = await DB.mostrarHorarios();
    setState(() {
      horarios = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    cargarHorarios();
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
          Row(
            children: [
              Text(
                "ID Horario:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          DropdownButtonFormField(
            value: idSeleccionado,
            items: horarios.map((h) {
              return DropdownMenuItem<int>(
                value: h.NHORARIO,
                child: Text("ID: ${h.NHORARIO} | Hora: ${h.HORA} (${h.EDIFICIO})"),
              );
            }).toList(),
            onChanged: (valor) {
              setState(() {
                idSeleccionado = valor;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Seleccione un horario",
            ),
          ),
          SizedBox(height: 16,),
          TextField(
            controller: fecha,
            decoration: InputDecoration(
              labelText: "AAAA-MM-DD",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Asistencia:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  )
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: Text("Sí"),
                      value: 1,
                      groupValue: asistenciaValue,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                          asistenciaValue = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: Text("No"),
                      value: 0,
                      groupValue: asistenciaValue,
                      activeColor: Colors.red,
                      onChanged: (value) {
                        setState(() {
                          asistenciaValue = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 10,),

          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    if (idSeleccionado == null || fecha.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Debe llenar todos los campos",
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.black,
                        ),
                      );
                      return;
                    }

                    Asistencia a = Asistencia(
                      NHORARIO: idSeleccionado!,
                      FECHA: fecha.text,
                      ASISTENCIA: asistenciaValue,
                    );

                    DB.insertarAsistencia(a).then((res) {
                      if(res <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error al registrar asistencia",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Asistencia registrada correctamente",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        actualizarLista();
                        nhorario.clear();
                        fecha.clear();
                        setState(() {
                          asistenciaValue = 1;
                        });
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outlined),
                      SizedBox(width: 6,),
                      Text("Registrar asistencia",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            letterSpacing: 1.5
                        ),),
                    ],
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
              SizedBox(width: 10,),
              FilledButton(
                onPressed: () {
                  nhorario.clear();
                  fecha.clear();
                  setState(() {
                    asistenciaValue = 1;
                  });
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
            children: [
              Text("Registro de Asistencias:",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          SizedBox(height: 8,),
          Expanded(
            child: ListView.builder(
                itemCount: datos.length,
                itemBuilder: (context, i) {
                  return Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.checklist_rtl, color: Colors.black87),
                          backgroundColor: Colors.blueGrey[100],
                          radius: 22,
                        ),
                        title: Text("ID: ${datos[i].IDASISTENCIA ?? '-'}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Horario: ${datos[i].NHORARIO}",
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text("Fecha: ${datos[i].FECHA}",
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text("Asistencia: ${datos[i].ASISTENCIA == 1 ? 'Sí' : 'No'}",
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: (){
                            DB.eliminarAsistencia(datos[i].IDASISTENCIA!)
                                .then((res) {
                              actualizarLista();
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
                                                content: Text("Asistencia eliminado correctamente",
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
                              MaterialPageRoute(builder: (x) => actualizarasistencia(asist: datos[i]))
                          );

                          if (result == true) {
                            actualizarLista();
                          }
                        },
                      ),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}
