import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../main.dart'; // Acceso a la instancia global de Isar
import '../models/schedule.dart';
import '../models/patient.dart'; // Importación del modelo de pacientes
import '../services/wifi_servicio.dart';

class AddScheduleScreen extends StatefulWidget {
  @override
  _AddScheduleScreenState createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  // Controladores para la captura de texto de los inputs
  final _nombreController = TextEditingController();
  final _intervaloController = TextEditingController();
  final _diasController = TextEditingController();

  // Variables de estado para la selección de datos
  int? _casilleroSeleccionado;
  TimeOfDay _horaSeleccionada = TimeOfDay.now();
  List<int> _casillerosOcupados = [];

  /// Lista que almacena los pacientes recuperados de la base de datos.
  List<Patient> _pacientesDisponibles = [];

  /// Almacena el nombre del paciente seleccionado en el menú desplegable.
  String? _pacienteSeleccionado;

  @override
  void initState() {
    super.initState();
    // Ejecución de la carga inicial de casilleros desde la base de datos
    _obtenerCasillerosEnUso();
  }

  // Consulta a Isar para identificar qué casilleros (1 o 2) ya tienen un horario activo
  void _obtenerCasillerosEnUso() async {
    // El sistema recupera todos los horarios para marcar casilleros en uso.
    final registros = await isar.schedules.where().findAll();
    // El sistema recupera la lista completa de pacientes registrados.
    final pacientes = await isar.patients.where().findAll();
    setState(() {
      _casillerosOcupados = registros.map((s) => s.casillero!).toList();
      _pacientesDisponibles = pacientes;
    });
  }

  // Proceso principal de guardado y sincronización
  // Proceso principal de guardado y sincronización
  void _procesarGuardado() async {
    // Validación: El sistema verifica si el casillero seleccionado ya tiene un registro en Isar
    final existe = await isar.schedules
        .filter()
        .casilleroEqualTo(_casilleroSeleccionado)
        .findFirst();
    // El sistema valida que se haya seleccionado un paciente y un casillero.
    if (_pacienteSeleccionado == null ||
        _casilleroSeleccionado == null ||
        _nombreController.text.isEmpty) {
      _mostrarAlerta(
        "Información Incompleta",
        "Por favor seleccione un paciente, un casillero y el nombre del medicamento.",
      );
      return;
    }
    if (existe != null) {
      // Notificación al usuario de que el espacio ya está en uso para evitar errores de índice único
      _mostrarAlerta(
        "Casillero Ocupado",
        "Este casillero ya tiene un medicamento asignado.",
      );
      _obtenerCasillerosEnUso(); // Actualización de la interfaz para bloquear el casillero
      return;
    }

    // Validación de seguridad por si no se llenaron los campos
    if (_nombreController.text.isEmpty || _casilleroSeleccionado == null) {
      _mostrarAlerta(
        "Campos incompletos",
        "Por favor, llena el nombre y selecciona un casillero.",
      );
      return;
    }

    // Cálculo de la logística del tratamiento (tomas totales)
    int horas = int.tryParse(_intervaloController.text) ?? 8;
    int dias = int.tryParse(_diasController.text) ?? 1;
    int tomasTotales = (dias * 24) ~/ horas;

    // Instanciación del modelo Schedule con los datos capturados en pantalla
    final nuevoHorario = Schedule()
      ..medicamento = _nombreController.text
      ..pacienteNombre =
          _pacienteSeleccionado // Se asigna el paciente a la etiqueta.
      ..casillero = _casilleroSeleccionado
      ..horaProxima = _horaSeleccionada.hour
      ..minutoProxima = _horaSeleccionada.minute
      ..intervaloMinutos = horas * 60
      ..tomasRestantes = tomasTotales
      ..fechaCreacion = DateTime.now();

    try {
      // Ejecución de la transacción de escritura en la base de datos local
      await isar.writeTxn(() async {
        await isar.schedules.put(nuevoHorario);
      });

      // Intento de comunicación con el hardware TecnoPill mediante protocolo HTTP/WiFi
      bool exitoWifi = await WifiServicio().enviarHorario(nuevoHorario);

      if (exitoWifi) {
        _mostrarAlerta(
          "Éxito",
          "Horario guardado y sincronizado con TecnoPill",
        );
      } else {
        // Notificación de guardado local exitoso pero falla en la sincronización inalámbrica
        _mostrarAlerta(
          "Aviso",
          "Guardado en el celular, pero no se pudo contactar al TecnoPill por WiFi",
        );
      }

      // Finalización del proceso y retorno a la pantalla principal tras un retraso de cortesía
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context, true);
      });
    } catch (e) {
      // Captura de excepciones críticas durante el proceso de persistencia
      _mostrarAlerta("Error Fatal", "No se pudo guardar el horario: $e");
    }
  }

  // Generación de cuadros de diálogo para retroalimentación al usuario
  void _mostrarAlerta(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configurar TecnoPill')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Paciente Responsable",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),

            /// Menú desplegable para seleccionar un paciente de la base de datos Isar.
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text("Seleccione un paciente"),
                  value: _pacienteSeleccionado,
                  // El sistema mapea la lista de pacientes a elementos del menú.
                  items: _pacientesDisponibles.map((p) {
                    return DropdownMenuItem<String>(
                      value: p.nombreCompleto,
                      child: Text(p.nombreCompleto),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _pacienteSeleccionado = val;
                    });
                  },
                ),
              ),
            ),

            SizedBox(height: 25), // Espacio antes de los casilleros

            Text(
              "Selección de Casillero",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 15),

            // Renderizado de los dos casilleros disponibles
            Row(
              children: [1, 2].map((num) {
                bool estaOcupado = _casillerosOcupados.contains(num);
                bool esSeleccionado = _casilleroSeleccionado == num;

                return Expanded(
                  child: GestureDetector(
                    onTap: estaOcupado
                        ? null
                        : () => setState(() => _casilleroSeleccionado = num),
                    child: Container(
                      margin: EdgeInsets.all(5),
                      height: 80,
                      decoration: BoxDecoration(
                        color: estaOcupado
                            ? Colors.grey[300]
                            : (esSeleccionado
                                  ? Color(0xFF7B61FF)
                                  : Colors.white),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: esSeleccionado
                              ? Colors.deepPurple
                              : Colors.grey[300]!,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            estaOcupado ? Icons.lock : Icons.medication,
                            color: esSeleccionado
                                ? Colors.white
                                : Colors.black54,
                          ),
                          Text(
                            "Casillero $num",
                            style: TextStyle(
                              color: esSeleccionado
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 25),

            // Captura del nombre del fármaco
            TextField(
              controller: _nombreController,
              autofillHints: null, //
              enableSuggestions:
                  false, // Desactiva sugerencias si el teclado se pone rebelde
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'Nombre del Medicamento',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),

            // Selección de la hora de inicio mediante TimePicker nativo
            ListTile(
              tileColor: Colors.blue[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text("Primera toma: ${_horaSeleccionada.format(context)}"),
              trailing: Icon(Icons.access_time),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _horaSeleccionada,
                );
                if (time != null) setState(() => _horaSeleccionada = time);
              },
            ),

            SizedBox(height: 15),

            // Entradas numéricas para frecuencia y duración del tratamiento
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _intervaloController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Cada (horas)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    controller: _diasController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Por (días)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),

            // Botón de ejecución del protocolo de guardado
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7B61FF),
                  foregroundColor: Colors.white,
                ),
                onPressed: _procesarGuardado,
                child: Text(
                  'SINCRONIZAR HORARIO',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
