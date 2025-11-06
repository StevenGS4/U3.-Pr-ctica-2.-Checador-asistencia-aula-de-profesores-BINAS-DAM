import 'package:flutter/material.dart';
import 'package:u3_practica2_controlasistencia/asistencia.dart';
import 'package:u3_practica2_controlasistencia/basedatos.dart';
import 'package:u3_practica2_controlasistencia/horario.dart';

class actualizarasistencia extends StatefulWidget {
  final Asistencia asist;
  const actualizarasistencia({super.key, required this.asist});

  @override
  State<actualizarasistencia> createState() => _actualizarasistenciaState();
}

class _actualizarasistenciaState extends State<actualizarasistencia> {
  final fecha = TextEditingController();
  int asistenciaValue = 1;

  List<Horario> horarios = [];
  int? idSeleccionado;

  @override
  void initState() {
    super.initState();
    cargarHorarios();

    // Precargar los valores actuales de la asistencia
    idSeleccionado = widget.asist.NHORARIO;
    fecha.text = widget.asist.FECHA;
    asistenciaValue = widget.asist.ASISTENCIA;
  }

  void cargarHorarios() async {
    List<Horario> temp = await DB.mostrarHorarios();
    setState(() {
      horarios = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Actualizar Asistencia"),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Actualizar datos de asistencia:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Campo para ID Horario
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
            SizedBox(height: 10),
            DropdownButtonFormField<int>(
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
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Seleccione un horario",
              ),
            ),

            SizedBox(height: 16),

            TextField(
              controller: fecha,
              decoration: InputDecoration(
                labelText: "Fecha (AAAA-MM-DD)",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Asistencia:",
                  style: TextStyle(fontWeight: FontWeight.bold),
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

            SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      if (idSeleccionado == null || fecha.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(
                              "Debe llenar todos los campos",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: Colors.black,
                          ),
                        );
                        return;
                      }

                      Asistencia a = Asistencia(
                        IDASISTENCIA: widget.asist.IDASISTENCIA,
                        NHORARIO: idSeleccionado!,
                        FECHA: fecha.text,
                        ASISTENCIA: asistenciaValue,
                      );

                      DB.actualizarAsistencia(a)
                          .then((res) {
                        if (res > 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(
                                "Asistencia actualizada correctamente",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context, true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(
                                "Error al actualizar asistencia",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      });
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 6),
                        Text("Actualizar asistencia",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              letterSpacing: 1.5),
                        ),
                      ],
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
