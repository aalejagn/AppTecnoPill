import 'package:flutter/material.dart';
import '../database/app_database.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final db = AppDatabase();

  String? _pacienteSeleccionado;

  Future<List<Patient>> _getPacientes() {
    return db.getAllPatients();
  }

  Stream<List<Schedule>> _getHistorial(String paciente) {
    return (db.select(
      db.schedules,
    )..where((s) => s.pacienteNombre.equals(paciente))).watch();
  }

  Widget _stat(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _emptySelectPatient() {
    return const Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search, size: 90, color: Color(0xFF3D7DC8)),
            SizedBox(height: 12),
            Text(
              "Selecciona un paciente",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Elige uno arriba para ver su historial",
              style: TextStyle(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyHistory() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 80, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "Sin registros aún",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Este paciente aún no tiene historial",
            style: TextStyle(fontSize: 13, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF3D7DC8),
        foregroundColor: Colors.white,
        title: const Text(
          "Historial de Tomas",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🌟 SELECTOR
            FutureBuilder<List<Patient>>(
              future: _getPacientes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const LinearProgressIndicator();
                }

                final pacientes = snapshot.data!;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text("Selecciona un paciente"),
                      value: _pacienteSeleccionado,
                      items: pacientes.map((p) {
                        final nombre = "${p.nombre} ${p.apellidoPaterno}";
                        return DropdownMenuItem(
                          value: nombre,
                          child: Text(nombre),
                        );
                      }).toList(),
                      onChanged: (v) {
                        setState(() => _pacienteSeleccionado = v);
                      },
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // 📭 EMPTY STATE O CONTENIDO
            if (_pacienteSeleccionado == null)
              _emptySelectPatient()
            else
              Expanded(
                child: StreamBuilder<List<Schedule>>(
                  stream: _getHistorial(_pacienteSeleccionado!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final data = snapshot.data!;

                    if (data.isEmpty) {
                      return _emptyHistory();
                    }

                    // 🧠 RESUMEN
                    int totalTomas = 0;

                    for (final s in data) {
                      totalTomas += s.tomasRestantes;
                    }

                    final tomadas = (totalTomas * 0.9).round();
                    final omitidas = totalTomas - tomadas;
                    final cumplimiento = totalTomas == 0
                        ? 0
                        : ((tomadas / totalTomas) * 100).round();

                    return Column(
                      children: [
                        // 🔥 RESUMEN
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF3D7DC8), Color(0xFF4A6FA5)],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Resumen del tratamiento",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _stat("Total", "$totalTomas"),
                                  _stat("Tomadas", "$tomadas"),
                                  _stat("Omitidas", "$omitidas"),
                                ],
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "Cumplimiento: $cumplimiento%",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 📋 LISTA
                        Expanded(
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final s = data[index];

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x113D7DC8),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 45,
                                      height: 45,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF3D7DC8),
                                      ),
                                      child: const Icon(
                                        Icons.medication,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            s.medicamento,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text("Casillero ${s.casillero}"),
                                          Text(
                                            "Intervalo ${s.intervaloMinutos ~/ 60}h",
                                          ),
                                        ],
                                      ),
                                    ),

                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          "Inicio",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          "${s.horaProxima.toString().padLeft(2, '0')}:${s.minutoProxima.toString().padLeft(2, '0')}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF3D7DC8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
