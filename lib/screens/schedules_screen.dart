import 'package:flutter/material.dart';
import '../database/app_database.dart';
import 'add_schedule_screen.dart';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({super.key});

  @override
  State<SchedulesScreen> createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {

  Stream<List<Schedule>> _getSchedules() {
    return db.select(db.schedules).watch();
  }

  Future<void> _eliminar(int id) async {
    await db.deleteSchedule(id);
  }

  void _opciones(Schedule s) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: [

              ListTile(
                leading: const Icon(Icons.edit, color: Color(0xFF7B61FF)),
                title: const Text("Editar"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddScheduleScreen(schedule: s),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.lock_open, color: Colors.orange),
                title: const Text("Liberar casillero"),
                subtitle: const Text("Quita el medicamento pero conserva historial"),
                onTap: () async {
                  Navigator.pop(context);

                  await db.deleteSchedule(s.id);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(
                              Icons.lock_open_rounded,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text("Casillero liberado"),
                          ],
                        ),
                        backgroundColor: const Color(0xFF7B61FF),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),

              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Eliminar definitivamente"),
                onTap: () async {
                  Navigator.pop(context);
                  await _eliminar(s.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        title: const Text("Horarios"),
        backgroundColor: const Color(0xFF7B61FF),
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7B61FF),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddScheduleScreen()),
          ).then((_) => setState(() {}));
        },
      ),

      body: StreamBuilder<List<Schedule>>(
        stream: _getSchedules(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final lista = snapshot.data!;

          if (lista.isEmpty) {
            return const Center(child: Text("No hay horarios"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final s = lista[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7B61FF).withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.medicamento,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Paciente: ${s.pacienteNombre}"),
                          Text("Casillero: ${s.casillero}"),
                          Text("Intervalo: ${s.intervaloMinutos} min"),
                        ],
                      ),
                    ),

                    // 👇 botón de 3 puntitos
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.grey),
                      onPressed: () => _opciones(s),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}