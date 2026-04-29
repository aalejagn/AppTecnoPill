import 'package:flutter/material.dart';

class AlertaTomaExitosa extends StatelessWidget {
  final int casillero;

  const AlertaTomaExitosa({super.key, required this.casillero});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icono de éxito animado o simple
          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 80),
          const SizedBox(height: 20),
          const Text(
            "¡Acción Detectada!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Se confirmó la toma del medicamento en el casillero $casillero.",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 25),

          // Botón Corregido
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Color de fondo
                foregroundColor: Colors.white, // Color del texto
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                elevation: 2,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "ENTENDIDO",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
