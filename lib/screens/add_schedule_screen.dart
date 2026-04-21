import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column;
import '../database/app_database.dart';
import '../services/wifi_servicio.dart';

class AddScheduleScreen extends StatefulWidget {
  final Schedule? schedule;

  const AddScheduleScreen({super.key, this.schedule});

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _nombreController = TextEditingController();
  final _intervaloController = TextEditingController();
  final _diasController = TextEditingController();

  int? _casilleroSeleccionado;
  TimeOfDay _horaSeleccionada = TimeOfDay.now();

  List<int> _casillerosOcupados = [];
  List<Patient> _pacientesDisponibles = [];
  String? _pacienteSeleccionado;

  @override
  void initState() {
    super.initState();
    _obtenerCasillerosEnUso();

    // 🔥 EDIT MODE
    if (widget.schedule != null) {
      final s = widget.schedule!;

      _nombreController.text = s.medicamento;
      _intervaloController.text = (s.intervaloMinutos ~/ 60).toString();
      _diasController.text = (s.tomasRestantes ~/ (s.intervaloMinutos ~/ 60))
          .toString();

      _casilleroSeleccionado = s.casillero;
      _horaSeleccionada = TimeOfDay(
        hour: s.horaProxima,
        minute: s.minutoProxima,
      );

      _pacienteSeleccionado = s.pacienteNombre;
    }
  }

  Future<void> _obtenerCasillerosEnUso() async {
    final registros = await db.getAllSchedules();
    final pacientes = await db.getAllPatients();

    setState(() {
      _casillerosOcupados = registros
          .where((s) => widget.schedule == null || s.id != widget.schedule!.id)
          .map((s) => s.casillero)
          .toList();

      _pacientesDisponibles = pacientes;
    });
  }

  final WifiServicio _wifiServicio = WifiServicio();
  void _procesarGuardado() async {
    if (_pacienteSeleccionado == null ||
        _casilleroSeleccionado == null ||
        _nombreController.text.isEmpty) {
      _mostrarAlerta("Faltan datos", "Completa todos los campos");
      return;
    }

    final existe = await db.getScheduleByCasillero(_casilleroSeleccionado!);
    if (existe != null && widget.schedule == null) {
      _mostrarAlerta("Casillero ocupado", "Ya tiene un medicamento");
      return;
    }

    // LOGICA PARA EVITAR COLISIÓN DE HORARIOS
    int horaFinal = _horaSeleccionada.hour;
    int minutoFinal = _horaSeleccionada.minute;

    //Obtenemos todos los horarios actuales (excepto el que estamos editando)

    final todosLosHorarios = await db.getAllSchedules();
    for (var s in todosLosHorarios) {
      //Si estamos editando, no comparamos con sigomismo
      if (widget.schedule != null && s.id == widget.schedule!.id) continue;

      //Si la hora y el minuto coniciden con cualquier casillero guardado
      if (s.horaProxima == horaFinal && s.minutoProxima == minutoFinal) {
        minutoFinal += 1; //sumamos el minuto para que sea diferente

        if (minutoFinal >= 60) {
          minutoFinal = 0;
          horaFinal = (horaFinal + 1) % 24;
        }
        print(
          "COLISIÓN DETECTADA: Se ajustó el horario a $horaFinal:$minutoFinal para evitar conflictos.",
        );
      }
    }

    int horas = int.tryParse(_intervaloController.text) ?? 8;
    int dias = int.tryParse(_diasController.text) ?? 1;
    int tomasTotales = (dias * 24) ~/ horas;

    final data = SchedulesCompanion(
      medicamento: Value(_nombreController.text),
      pacienteNombre: Value(_pacienteSeleccionado!),
      casillero: Value(_casilleroSeleccionado!),
      //usamos la variables ajustadas
      horaProxima: Value(horaFinal),
      minutoProxima: Value(minutoFinal),
      intervaloMinutos: Value(horas * 60),
      tomasRestantes: Value(tomasTotales),
      fechaCreacion: Value(DateTime.now()),
    );

    try {
      int idFinal;

      if (widget.schedule == null) {
        idFinal = await db.insertSchedule(data);
      } else {
        await db.updateSchedule(widget.schedule!.id, data);
        idFinal = widget.schedule!.id;
      }

      final scheduleParaEnviar = await db.getScheduleById(idFinal);

      if (scheduleParaEnviar != null) {
        _mostrarLoading();

        bool exitoWifi = await _wifiServicio.enviarHorario(scheduleParaEnviar);

        if (mounted) Navigator.pop(context); // Cierra el Loading

        if (exitoWifi) {
          if (mounted) Navigator.pop(context, true); // Regresa a la lista
        } else {
          _mostrarAlerta(
            "Error de Sincronización",
            "Guardado localmente. Pero no se pudo enviar al TecnoPill. Verifica tu WiFi.",
          );
        }
      }
    } catch (e) {
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
      _mostrarAlerta("Error", "Ocurrió un problema: $e");
    }
  } // <-- AQUÍ TERMINA _procesarGuardado

  // Este método debe ir suelto en la clase
  void _mostrarLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF3D7DC8)),
      ),
    );
  }

  void _mostrarAlerta(String t, String m) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(t),
        content: Text(m),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _campo(String label, TextEditingController c, {bool number = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _botonDegradado() {
    return GestureDetector(
      onTap: _procesarGuardado,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF3D7DC8), Color(0xFF5B8ED4)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "SINCRONIZAR HORARIO",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _casillero(int num) {
    bool ocupado = _casillerosOcupados.contains(num);
    bool sel = _casilleroSeleccionado == num;

    return Expanded(
      child: GestureDetector(
        onTap: ocupado
            ? null
            : () => setState(() => _casilleroSeleccionado = num),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.all(6),
          height: 85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: sel
                ? LinearGradient(colors: [Color(0xFF3D7DC8), Color(0xFF4A6FA5)])
                : null,
            color: ocupado ? Colors.grey.shade300 : Colors.white,
            border: Border.all(
              color: sel ? Colors.transparent : Colors.grey.shade300,
            ),
            boxShadow: sel
                ? [
                    BoxShadow(
                      color: const Color(0xFF3D7DC8).withOpacity(0.3),
                      blurRadius: 10,
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                ocupado ? Icons.lock : Icons.medication,
                color: sel ? Colors.white : Colors.black54,
              ),
              SizedBox(height: 4),
              Text(
                "Casillero $num",
                style: TextStyle(
                  color: sel ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F2F5),
      appBar: AppBar(
        title: Text("Configurar TecnoPill"),
        backgroundColor: Color(0xFF3D7DC8),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Paciente", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text("Selecciona paciente"),
                  value: _pacienteSeleccionado,
                  items: _pacientesDisponibles.map((p) {
                    return DropdownMenuItem(
                      value: "${p.nombre} ${p.apellidoPaterno}",
                      child: Text("${p.nombre} ${p.apellidoPaterno}"),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => _pacienteSeleccionado = v),
                ),
              ),
            ),

            SizedBox(height: 20),

            Text("Casilleros", style: TextStyle(fontWeight: FontWeight.bold)),
            Row(children: [1, 2].map(_casillero).toList()),

            SizedBox(height: 20),

            _campo("Medicamento", _nombreController),

            const SizedBox(height: 10),

            // HORA
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.access_time,
                  color: Color(0xFF3D7DC8),
                ),
                title: const Text("Primera Toma"),
                subtitle: Text(
                  _horaSeleccionada.format(context),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: () async {
                  final t = await showTimePicker(
                    context: context,
                    initialTime: _horaSeleccionada,
                  );
                  if (t != null) {
                    setState(() => _horaSeleccionada = t);
                  }
                },
              ),
            ),

            const SizedBox(height: 10),

            // INTERVALO + DIAS
            Row(
              children: [
                Expanded(
                  child: _campo(
                    "Cada (horas)",
                    _intervaloController,
                    number: true,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: _campo("Días", _diasController, number: true)),
              ],
            ),

            const SizedBox(height: 20),
            _botonDegradado(),
          ],
        ),
      ),
    );
  }
}
