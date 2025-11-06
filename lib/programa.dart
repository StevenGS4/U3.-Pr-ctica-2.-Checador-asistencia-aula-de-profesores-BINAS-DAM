import 'package:flutter/material.dart';
import 'package:u3_practica2_controlasistencia/asistenciapage.dart';
import 'package:u3_practica2_controlasistencia/horariopage.dart';
import 'package:u3_practica2_controlasistencia/materiapage.dart';
import 'package:u3_practica2_controlasistencia/profesorpage.dart';
import 'package:u3_practica2_controlasistencia/basedatos.dart';

class programa extends StatefulWidget {
  const programa({super.key});

  @override
  State<programa> createState() => _programaState();
}

class _programaState extends State<programa> {
  int index = 2;
  List titulosAppBar = [
    "Materias",
    "Horario de clases",
    "Inicio",
    "Profesores",
    "Asistencia",
  ];

  List<Map<String, dynamic>> resultados = [];
  bool cargandoConsulta = false;

  Future<void> ejecutarConsulta1() async {
    setState(() => cargandoConsulta = true);
    final res = await DB.profesoresClase8UD();
    setState(() {
      resultados = res;
      cargandoConsulta = false;
    });
  }

  Future<void> ejecutarConsulta2() async {
    setState(() => cargandoConsulta = true);
    final res = await DB.profesoresAsistieron("08/02/2022");
    setState(() {
      resultados = res;
      cargandoConsulta = false;
    });
  }

  Future<void> ejecutarConsulta3() async {
    setState(() => cargandoConsulta = true);
    final res = await DB.materiasPorProfesor();
    setState(() {
      resultados = res;
      cargandoConsulta = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulosAppBar[index]),
        centerTitle: true,
      ),
      body: contenido(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (x) => setState(() => index = x),
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              activeIcon: Icon(Icons.book),
              label: "Materia"),
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule_outlined),
              activeIcon: Icon(Icons.access_time_filled_sharp),
              label: "Horario"),
          BottomNavigationBarItem(
              icon: CircleAvatar(
                child: Icon(Icons.home_outlined, color: Colors.grey),
                backgroundColor: Colors.white,
              ),
              activeIcon: CircleAvatar(
                child: Icon(Icons.home_outlined, color: Colors.white),
                backgroundColor: Colors.blue,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Profesor"),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              activeIcon: Icon(Icons.check_circle),
              label: "Asistencia"),
        ],
      ),
    );
  }

  Widget? contenido() {
    switch (index) {
      case 0:
        return const Materiapage();
      case 1:
        return const HorarioPage();
      case 2:
        return StatefulBuilder(
          builder: (context, setStateLocal) => ListView(
            padding: const EdgeInsets.all(25),
            children: [
              const Text(
                "¡Bienvenido al sistema de control de asistencia!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Administra profesores, horarios y asistencias desde un solo lugar.",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Sección de tarjetas
              seccionTarjetas(context),

              const SizedBox(height: 15),
              const Divider(thickness: 1.5),
              const SizedBox(height: 8),

              const Text(
                "Consultas avanzadas:",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 8),

              ElevatedButton.icon(
                onPressed: () async {
                  setState(() => cargandoConsulta = true);
                  final res = await DB.profesoresClase8UD();
                  setState(() {
                    resultados = res;
                    cargandoConsulta = false;
                  });
                  setStateLocal(() {});
                },
                icon: const Icon(Icons.search, color: Colors.blue,),
                label: const Text(
                    "Profesores que tienen clase a las 8:00 am en el edificio UD",
                  style: TextStyle(
                    color: Colors.black
                  ),
                ),
              ),

              const SizedBox(height: 6),
              ElevatedButton.icon(
                onPressed: () async {
                  setState(() => cargandoConsulta = true);
                  final res = await DB.profesoresAsistieron("2022-02-08");
                  setState(() {
                    resultados = res;
                    cargandoConsulta = false;
                  });
                  setStateLocal(() {});
                },
                icon: const Icon(Icons.person_search, color: Colors.blue,),
                label: const Text(
                    "Profesores que asistieron el 08/02/2022 a clase",
                  style: TextStyle(
                    color: Colors.black
                  ),
                ),
              ),

              const SizedBox(height: 6),
              ElevatedButton.icon(
                onPressed: () async {
                  setState(() => cargandoConsulta = true);
                  final res = await DB.materiasPorProfesor();
                  setState(() {
                    resultados = res;
                    cargandoConsulta = false;
                  });
                  setStateLocal(() {});
                },
                icon: const Icon(Icons.menu_book, color: Colors.blue,),
                label:
                const Text("Materias y horarios asignados por profesor",
                  style: TextStyle(
                    color: Colors.black
                  ),
                ),
              ),

              const SizedBox(height: 16),

              cargandoConsulta
                  ? const Center(child: CircularProgressIndicator())
                  : resultados.isEmpty
                  ? const Text(
                "Sin resultados por ahora.",
                style: TextStyle(color: Colors.black54),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: resultados.length,
                itemBuilder: (context, i) {
                  final fila = resultados[i];
                  return Card(
                    color: Colors.white,
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                        fila['NOMBRE'] ??
                            fila['PROFESOR'] ??
                            "Sin nombre",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        fila.entries
                            .map((e) => "${e.key}: ${e.value}")
                            .join("\n"),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      case 3:
        return const ProfesorPage();
      case 4:
        return const AsistenciaPage();
      default:
        return const Center(child: Text("No existe esta página."));
    }
  }

  Widget seccionTarjetas(BuildContext context) {
    return Column(
      children: [
        tarjetaInicio("Ver materias", "Consulta y edita", "assets/materias.png",
                () => setState(() => index = 0)),
        const SizedBox(height: 8),
        tarjetaInicio("Ver horarios", "Consulta y modifica",
            "assets/horario.png", () => setState(() => index = 1)),
        const SizedBox(height: 8),
        tarjetaInicio("Ver profesores", "Consulta y actualiza",
            "assets/profesor.png", () => setState(() => index = 3)),
        const SizedBox(height: 8),
        tarjetaInicio("Ver asistencias", "Consulta y registra",
            "assets/asistencia.png", () => setState(() => index = 4)),
      ],
    );
  }

  Widget tarjetaInicio(
      String titulo, String subtitulo, String img, VoidCallback onTap) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Text(subtitulo,
                    style: const TextStyle(fontSize: 14, color: Colors.black87)),
                IconButton(
                  onPressed: onTap,
                  icon: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.arrow_forward_outlined,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            Container(
              width: 140,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                onPressed: onTap,
                icon: Image.asset(img, width: 85, height: 85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
