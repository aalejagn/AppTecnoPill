import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column;
import '../database/app_database.dart';

class AddPatientScreen extends StatefulWidget {
  final Patient? patient;

  const AddPatientScreen({super.key, this.patient});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _nombreController = TextEditingController();
  final _paternoController = TextEditingController();
  final _maternoController = TextEditingController();
  final _telefonoController = TextEditingController();

  DateTime _fechaSeleccionada = DateTime(2000, 1, 1);

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // 🔥 SI ES EDICIÓN, LLENA CAMPOS
    if (widget.patient != null) {
      final p = widget.patient!;
      _nombreController.text = p.nombre;
      _paternoController.text = p.apellidoPaterno;
      _maternoController.text = p.apellidoMaterno;
      _telefonoController.text = p.telefono ?? '';
      _fechaSeleccionada = p.fechaNacimiento;
    }
  }

  Future<void> _guardarPaciente() async {
    if (_nombreController.text.isEmpty || _paternoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Faltan datos obligatorios")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final data = PatientsCompanion(
        nombre: Value(_nombreController.text.trim()),
        apellidoPaterno: Value(_paternoController.text.trim()),
        apellidoMaterno: Value(_maternoController.text.trim()),
        telefono: Value(_telefonoController.text.trim()),
        fechaNacimiento: Value(_fechaSeleccionada),
      );

      // 🔥 CREATE O UPDATE
      if (widget.patient == null) {
        await db.insertPatient(data);
      } else {
        await db.updatePatient(widget.patient!.id, data);
      }

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7B61FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 40,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "¡Guardado!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Paciente guardado correctamente.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF7B61FF), // texto
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFF7B61FF)), // borde opcional
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text("Continuar"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al guardar")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.patient != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        title: Text(esEdicion ? "Editar Paciente" : "Nuevo Paciente"),
        centerTitle: true,
        backgroundColor: const Color(0xFF7B61FF),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _input("Nombre", _nombreController, Icons.person),
                      _input("Apellido Paterno", _paternoController, null),
                      _input("Apellido Materno", _maternoController, null),
                      _input("Teléfono", _telefonoController, Icons.phone,
                          isPhone: true),

                      const SizedBox(height: 10),

                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tileColor: Colors.grey.shade100,
                        leading: const Icon(Icons.calendar_month),
                        title: const Text("Fecha de nacimiento"),
                        subtitle: Text(
                          "${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}",
                        ),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _fechaSeleccionada,
                            firstDate: DateTime(1920),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => _fechaSeleccionada = picked);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B61FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _isLoading ? null : _guardarPaciente,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          esEdicion ? "ACTUALIZAR" : "GUARDAR PACIENTE",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(
    String label,
    TextEditingController c,
    IconData? icon, {
    bool isPhone = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType:
            isPhone ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
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
}