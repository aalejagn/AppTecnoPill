import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart'; // Para formatear la hora bonito
import '../main.dart';
import '../models/schedule.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Stream<List<Schedule>> _escucharHorarios() {
    return isar.schedules.where().watch(fireImmediately: true);
  }

  // Función mágica para calcular la siguiente toma
  String _calcularProximaHora(Schedule s) {
    final ahora = DateTime.now();
    // Creamos un objeto DateTime con la hora programada de hoy
    DateTime proxima = DateTime(
      ahora.year,
      ahora.month,
      ahora.day,
      s.horaProxima ?? 0,
      s.minutoProxima ?? 0,
    );

    // Si la hora ya pasó, le sumamos el intervalo hasta que sea una hora futura
    while (proxima.isBefore(ahora)) {
      proxima = proxima.add(Duration(minutes: s.intervaloMinutos ?? 480));
    }

    return DateFormat.jm().format(proxima); // Retorna algo como "9:00 PM"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: CustomScrollView(
        slivers: [
          // Cabecera superior simple
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                "Horarios Programados",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
            ),
          ),

          StreamBuilder<List<Schedule>>(
            stream: _escucharHorarios(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );

              final horarios = snapshot.data!;
              if (horarios.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text("No hay medicamentos activos")),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final s = horarios[index];
                    final horaToma = _calcularProximaHora(s);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7B61FF).withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Icono del Casillero
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF7B61FF).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.medication_liquid,
                              color: Color(0xFF7B61FF),
                            ),
                          ),
                          const SizedBox(width: 15),

                          // Información del medicamento
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.medicamento ?? "Sin nombre",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Casillero ${s.casillero}",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Hora de la toma (A la derecha)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "Próxima toma",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                horaToma,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7B61FF),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }, childCount: horarios.length),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
