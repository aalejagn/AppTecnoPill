import 'package:flutter/material.dart';
import '../main.dart';
import '../models/patient.dart';

/// Pantalla encargada de gestionar el registro de nuevos pacientes en la base de datos local.
class AddPatientScreen extends StatefulWidget {
  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  /// Controladores de texto para capturar la entrada del usuario en los campos de formulario.
  final _nombreController = TextEditingController();
  final _paternoController = TextEditingController();
  final _maternoController = TextEditingController();
  final _telefonoController =
      TextEditingController(); // Controlador para el número telefónico.

  /// Almacena la fecha seleccionada, inicializada por defecto en el año 2000.
  DateTime _fechaSeleccionada = DateTime(2000, 1, 1);

  /// Ejecuta la persistencia de los datos en la base de datos Isar y gestiona la retroalimentación visual.
  void _guardarPaciente() async {
    // El sistema valida que los campos obligatorios no se encuentren vacíos.
    if (_nombreController.text.isEmpty || _paternoController.text.isEmpty) {
      _mostrarAlerta(
        "Campos Requeridos",
        "Por favor, ingrese al menos el nombre y el apellido paterno.",
      );
      return;
    }

    // Se crea una instancia del modelo Patient con la información recolectada de la interfaz.
    final nuevoPaciente = Patient()
      ..nombre = _nombreController.text
      ..apellidoPaterno = _paternoController.text
      ..apellidoMaterno = _maternoController.text
      ..telefono = _telefonoController
          .text // El sistema asigna el teléfono capturado.
      ..fechaNacimiento = _fechaSeleccionada;

    // Se realiza una transacción de escritura asíncrona en la colección de pacientes de Isar.
    await isar.writeTxn(() async {
      await isar.patients.put(nuevoPaciente);
    });

    // El sistema despliega un cuadro de diálogo informativo para confirmar el éxito de la operación.
    showDialog(
      context: context,
      barrierDismissible:
          false, // El usuario debe presionar el botón para cerrar la alerta.
      builder: (context) => AlertDialog(
        title: Text("Registro Exitoso"),
        content: Text(
          "Los datos del paciente han sido almacenados correctamente.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              // El navegador cierra el diálogo y posteriormente regresa a la pantalla anterior.
              Navigator.pop(context); // Cierra la alerta.
              Navigator.pop(context); // Regresa a la pantalla de inicio.
            },
            child: Text("ACEPTAR"),
          ),
        ],
      ),
    );
  }

  /// Despliega una alerta genérica para mensajes de error o validación.
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
      appBar: AppBar(title: Text('Datos del Paciente')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Campo de entrada para el nombre de pila.
          TextField(
            controller: _nombreController,
            decoration: InputDecoration(labelText: 'Nombre'),
          ),
          // Campo de entrada para el primer apellido.
          TextField(
            controller: _paternoController,
            decoration: InputDecoration(labelText: 'Apellido Paterno'),
          ),
          // Campo de entrada para el segundo apellido.
          TextField(
            controller: _maternoController,
            decoration: InputDecoration(labelText: 'Apellido Materno'),
          ),
          // Campo de entrada para el teléfono con configuración de teclado numérico.
          TextField(
            controller: _telefonoController,
            keyboardType: TextInputType
                .phone, // El sistema optimiza el teclado para números telefónicos.
            decoration: InputDecoration(
              labelText: 'Teléfono de contacto',
              hintText: 'Ej. 9611234567',
              prefixIcon: Icon(Icons.phone),
            ),
          ),

          SizedBox(height: 10),

          // Elemento interactivo para la selección de la fecha de nacimiento.
          ListTile(
            title: Text(
              "Fecha de Nacimiento: ${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}",
            ),
            trailing: Icon(Icons.calendar_today),
            onTap: () async {
              // El sistema invoca el selector de fecha nativo del sistema operativo.
              final picked = await showDatePicker(
                context: context,
                initialDate: _fechaSeleccionada,
                firstDate: DateTime(1920),
                lastDate: DateTime.now(),
              );
              // Si el usuario confirma una fecha, el estado de la pantalla se actualiza.
              if (picked != null) setState(() => _fechaSeleccionada = picked);
            },
          ),

          SizedBox(height: 30),

          // Botón principal que activa el proceso de guardado.
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF7B61FF),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
            onPressed: _guardarPaciente,
            child: Text(
              'GUARDAR DATOS',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
