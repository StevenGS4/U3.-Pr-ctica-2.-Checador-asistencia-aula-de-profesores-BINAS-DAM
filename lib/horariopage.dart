import 'package:flutter/material.dart';
import 'package:u3_practica2_controlasistencia/basedatos.dart';
import 'package:u3_practica2_controlasistencia/horario.dart';

class HorarioPage extends StatefulWidget {
  const HorarioPage({super.key});

  @override
  State<HorarioPage> createState() => _HorarioPageState();
}

class _HorarioPageState extends State<HorarioPage> {
  final nprofesor = TextEditingController();
  final nmat = TextEditingController();
  final hora = TextEditingController();
  final edificio = TextEditingController();
  final salon = TextEditingController();

  List<Horario> horarios = [];
  bool modoEdicion = false;
  int? idEdicion;

  @override
  void initState() {
    super.initState();
    actualizarLista();
  }

  @override
  void dispose() {
    nprofesor.dispose();
    nmat.dispose();
    hora.dispose();
    edificio.dispose();
    salon.dispose();
    super.dispose();
  }

  Future<void> actualizarLista() async {
    final lista = await DB.mostrarHorarios();
    setState(() {
      horarios = lista;
    });
  }

  void limpiarCampos() {
    nprofesor.clear();
    nmat.clear();
    hora.clear();
    edificio.clear();
    salon.clear();
    setState(() {
      modoEdicion = false;
      idEdicion = null;
    });
  }

  Future<void> guardarHorario() async {
    if (nprofesor.text.isEmpty ||
        nmat.text.isEmpty ||
        hora.text.isEmpty ||
        edificio.text.isEmpty ||
        salon.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Debe llenar todos los campos."),
          backgroundColor: Colors.black,
        ),
      );
      return;
    }

    final nuevo = Horario(
      NHORARIO: idEdicion,
      NPROFESOR: nprofesor.text.trim(),
      NMAT: nmat.text.trim(),
      HORA: hora.text.trim(),
      EDIFICIO: edificio.text.trim(),
      SALON: salon.text.trim(),
    );

    try {
      if (modoEdicion) {
        await DB.actualizarHorario(nuevo);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Horario actualizado correctamente."),
            backgroundColor: Colors.blue,
          ),
        );
      } else {
        await DB.insertarHorario(nuevo);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Horario agregado correctamente."),
            backgroundColor: Colors.green,
          ),
        );
      }

      limpiarCampos();
      await actualizarLista();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            modoEdicion ? "Editar Horario" : "Registrar Horario",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 20),

          // Campo: ID Profesor
          TextField(
            controller: nprofesor,
            decoration: const InputDecoration(
              labelText: "ID Profesor",
              hintText: "Ej. 101",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Campo: ID Materia
          TextField(
            controller: nmat,
            decoration: const InputDecoration(
              labelText: "ID Materia",
              hintText: "Ej. 202",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Campo: Hora
          TextField(
            controller: hora,
            decoration: const InputDecoration(
              labelText: "Hora",
              hintText: "Ej. 08:00 - 09:00",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Campo: Edificio
          TextField(
            controller: edificio,
            decoration: const InputDecoration(
              labelText: "Edificio",
              hintText: "Ej. UD",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Campo: Salón
          TextField(
            controller: salon,
            decoration: const InputDecoration(
              labelText: "Salón",
              hintText: "Ej. 201",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: guardarHorario,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(modoEdicion
                          ? Icons.save_as_rounded
                          : Icons.add_circle_outline),
                      const SizedBox(width: 6),
                      Text(modoEdicion
                          ? "Guardar cambios"
                          : "Agregar horario", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          letterSpacing: 1.5
                      ),
                      ),
                    ],
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              FilledButton(
                onPressed: limpiarCampos,
                style: FilledButton.styleFrom(backgroundColor: Colors.black),
                child: const Icon(Icons.cleaning_services_rounded),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Lista de Horarios:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black),
              ),
              IconButton(
                onPressed: actualizarLista,
                icon: const Icon(Icons.refresh, color: Colors.blue),
              ),
            ],
          ),

          // Lista de horarios
          Expanded(
            child: ListView.builder(
              itemCount: horarios.length,
              itemBuilder: (context, i) {
                final h = horarios[i];
                return Card(
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.schedule,
                        color: Colors.deepPurpleAccent),
                    title: Text(
                        "Profesor: ${h.NPROFESOR} | Materia: ${h.NMAT}"),
                    subtitle: Text(
                        "Hora: ${h.HORA}\nEdificio: ${h.EDIFICIO} | Salón: ${h.SALON}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botón editar
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            setState(() {
                              modoEdicion = true;
                              idEdicion = h.NHORARIO;
                              nprofesor.text = h.NPROFESOR;
                              nmat.text = h.NMAT;
                              hora.text = h.HORA;
                              edificio.text = h.EDIFICIO;
                              salon.text = h.SALON;
                            });
                          },
                        ),
                        // Botón eliminar
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await DB.eliminarHorario(h.NHORARIO!);
                            actualizarLista();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
