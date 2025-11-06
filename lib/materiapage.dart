import 'dart:math';
import 'package:flutter/material.dart';
import 'package:u3_practica2_controlasistencia/basedatos.dart';
import 'package:u3_practica2_controlasistencia/materia.dart';

class Materiapage extends StatefulWidget {
  const Materiapage({super.key});

  @override
  State<Materiapage> createState() => _MateriapageState();
}

class _MateriapageState extends State<Materiapage> {
  final nmat = TextEditingController();
  final descripcion = TextEditingController();

  List<Materia> materias = [];
  bool modoEdicion = false; // indica si estamos editando o agregando

  void generarID() {
    int id = Random().nextInt(900) + 100;
    nmat.text = id.toString();
  }

  Future<void> actualizarLista() async {
    final temp = await DB.mostrarMaterias();
    setState(() {
      materias = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    generarID();
    actualizarLista();
  }

  @override
  void dispose() {
    nmat.dispose();
    descripcion.dispose();
    super.dispose();
  }

  // Guardar (insertar o actualizar)
  Future<void> guardarMateria() async {
    if (descripcion.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Debe llenar todos los campos."),
          backgroundColor: Colors.black,
        ),
      );
      return;
    }

    final m = Materia(
      NMAT: nmat.text,
      DESCRIPCION: descripcion.text,
    );

    if (modoEdicion) {
      await DB.actualizarMateria(m);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Materia actualizada correctamente."),
          backgroundColor: Colors.blue,
        ),
      );
    } else {
      await DB.insertarMateria(m);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Materia agregada correctamente."),
          backgroundColor: Colors.green,
        ),
      );
    }

    descripcion.clear();
    generarID();
    setState(() => modoEdicion = false);
    actualizarLista();
  }

  void limpiarCampos() {
    descripcion.clear();
    generarID();
    setState(() => modoEdicion = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            modoEdicion ? "Editar Materia" : "Registrar Materia",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 20),

          // ID
          TextField(
            controller: nmat,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: "ID de Materia",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Descripción
          TextField(
            controller: descripcion,
            decoration: const InputDecoration(
              labelText: "Descripción",
              hintText: "Ej. Programación Orientada a Objetos",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: guardarMateria,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        modoEdicion
                            ? Icons.save_as_rounded
                            : Icons.add_circle_outline,
                      ),
                      const SizedBox(width: 6),
                      Text(modoEdicion
                          ? "Guardar cambios"
                          : "Agregar materia", style: TextStyle(
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
                "Lista de Materias:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: actualizarLista,
                icon: const Icon(Icons.refresh, color: Colors.blue),
              ),
            ],
          ),

          Expanded(
            child: ListView.builder(
              itemCount: materias.length,
              itemBuilder: (context, i) {
                final m = materias[i];
                return Card(
                  elevation: 2,
                  child: ListTile(
                    leading:
                    const Icon(Icons.book, color: Colors.deepPurpleAccent),
                    title: Text(m.DESCRIPCION),
                    subtitle: Text("ID: ${m.NMAT}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            setState(() {
                              nmat.text = m.NMAT;
                              descripcion.text = m.DESCRIPCION;
                              modoEdicion = true;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await DB.eliminarMateria(m.NMAT);
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
