import 'package:flutter/material.dart';

import '../database/app_database.dart';

import 'add_schedule_screen.dart';

import '../services/wifi_servicio.dart';

import 'dart:async';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({super.key});

  @override
  State<SchedulesScreen> createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  Timer? _timer;

  Stream<List<Schedule>> _getSchedules() {
    return db.select(db.schedules).watch();
  }

  Future<void> _eliminar(int id) async {
    await db.deleteSchedule(id);
  }

  Widget _infoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),

        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,

          style: TextStyle(
            fontSize: 18,

            fontWeight: FontWeight.bold,

            color: color,
          ),
        ),

        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  // Vista previa de horarios (puedes mejorar esta lógica después)

  Widget _buildSchedulePreview(Schedule s) {
    // Por ahora mostramos la primera toma y el patrón

    final hora = s.horaProxima.toString().padLeft(2, '0');

    final minuto = s.minutoProxima.toString().padLeft(2, '0');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text("Primera toma: $hora:$minuto"),

        const SizedBox(height: 4),

        Text(
          "Cada ${s.intervaloMinutos ~/ 60} horas • ${s.tomasRestantes} tomas restantes",

          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),

        // Aquí puedes poner más tomas si quieres (ej: las

        //próximas 3-4)
      ],
    );
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
                leading: const Icon(Icons.edit, color: Color(0xFF4A6FA5)),

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

                subtitle: const Text(
                  "Quita el medicamento pero conserva historial",
                ),

                onTap: () async {
                  Navigator.pop(context);

                  await db.deleteSchedule(s.id);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.lock_open_rounded, color: Colors.white),

                            SizedBox(width: 10),

                            Text("Casillero liberado"),
                          ],
                        ),

                        backgroundColor: const Color(0xFF4A6FA5),

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
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      WifiServicio().escucharESP32();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),

      appBar: AppBar(
        title: const Text("Horarios"),

        backgroundColor: const Color(0xFF4A6FA5),

        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A6FA5),

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

              // Cálculo de tomas totales (igual que en AddScheduleScreen)

              int horasIntervalo = s.intervaloMinutos ~/ 60;

              int dias = (s.tomasRestantes / ((24 * 60) ~/ s.intervaloMinutos))
                  .ceil(); // aproximado

              int tomasTotales = s.tomasRestantes + s.tomadas + s.omitidas;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4A6FA5).withOpacity(0.1),

                      blurRadius: 12,

                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // Cabecera
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,

                            vertical: 6,
                          ),

                          decoration: BoxDecoration(
                            color: const Color(0xFF4A6FA5).withOpacity(0.1),

                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Text(
                            "Casillero ${s.casillero}",

                            style: const TextStyle(
                              fontWeight: FontWeight.bold,

                              color: Color(0xFF4A6FA5),
                            ),
                          ),
                        ),

                        const Spacer(),

                        IconButton(
                          icon: const Icon(Icons.more_vert),

                          onPressed: () => _opciones(s),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      s.medicamento,

                      style: const TextStyle(
                        fontSize: 18,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Dosis: ${s.dosis}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      "Paciente: ${s.pacienteNombre}",

                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 12),

                    // Información principal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        _infoColumn("Total de tomas", "$tomasTotales"),

                        _infoColumn("Intervalo", "Cada $horasIntervalo hrs"),

                        _infoColumn("Restantes", "${s.tomasRestantes}"),
                      ],
                    ),

                    const Divider(height: 24),

                    // Próximas tomas (ejemplo de visualización)
                    const Text(
                      "Próximas tomas:",

                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),

                    const SizedBox(height: 8),

                    _buildSchedulePreview(s), // ← Aquí va la magia

                    const SizedBox(height: 16),

                    // Estadísticas de tomas
                    Container(
                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,

                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //Nuevos cambios, llenado automatico
                        children: [
                          _statItem(
                            "Completadas",
                            "${s.tomadas}",
                            Colors.green,
                          ),

                          _statItem("Omitidas", "${s.omitidas}", Colors.orange),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    if (s.omitidas > 0)
                      ElevatedButton.icon(
                        onPressed: () async {
                          await db.confirmarTomaManual(s.casillero);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Toma corregida manualmente"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        icon: Icon(Icons.check_circle),
                        label: Text("Confirmar toma tardía"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 45),
                        ),
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
