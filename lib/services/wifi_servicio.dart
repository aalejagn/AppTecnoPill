import 'package:http/http.dart' as http;
import 'bluetooth_servicio.dart';
import '../models/schedule.dart';
import '../models/patient.dart'; // Importación necesaria para manejar los datos del paciente

/// Servicio encargado de la comunicación inalámbrica entre la aplicación y el hardware TecnoPill.
class WifiServicio {
  /// El sistema determina la dirección IP del hardware, priorizando la detectada por Bluetooth.
  String get ipTecnoPill {
    String? ipDetectada = MiBluetoothService().ipActualESP32;
    if (ipDetectada == null || ipDetectada.isEmpty) {
      return "192.168.1.71"; // Dirección IP de respaldo para entornos de desarrollo.
    }
    return ipDetectada;
  }

  /// Procesa y abrevia el nombre del paciente para que sea compatible con las dimensiones del LCD (16 caracteres).
  /// Ejemplo: "Alejandro Gutierrez Nuñez" -> "Alejandro G. N."
  String _abreviarNombre(String nombreCompleto) {
    List<String> partes = nombreCompleto.split(' ');
    if (partes.length <= 1) return nombreCompleto;

    String nombrePila = partes[0];
    String inicialesApellidos = "";

    // El sistema recorre los apellidos para extraer su letra inicial y añadir un punto.
    for (int i = 1; i < partes.length; i++) {
      if (partes[i].isNotEmpty) {
        inicialesApellidos += " ${partes[i][0]}.";
      }
    }

    String resultado = "$nombrePila$inicialesApellidos";

    // Si el nombre sigue siendo muy largo para el LCD, se recorta a 16 caracteres.
    return resultado.length > 16 ? resultado.substring(0, 16) : resultado;
  }

  /// Envía la información del medicamento y el paciente al TecnoPill mediante el protocolo HTTP.
  Future<bool> enviarHorario(Schedule s) async {
    final ip = ipTecnoPill;

    // El sistema obtiene el nombre del paciente almacenado en el horario o usa un valor por defecto.
    String nombreParaMostrar = _abreviarNombre(s.pacienteNombre ?? "Paciente");

    // El sistema construye la URL enviando 'nombre' (medicamento) y 'paciente' (nombre abreviado).
    // Se utiliza Uri.encodeComponent para manejar espacios o caracteres especiales.
    final url = Uri.parse(
      'http://$ip/enviarMed?nombre=${Uri.encodeComponent(s.medicamento)}&paciente=${Uri.encodeComponent(nombreParaMostrar)}',
    );
    // En tu archivo wifi_servicio.dart
    try {
      print(">>> ENVIANDO A TECNOPILL: $url");

      // El sistema intenta la conexión con un límite de 5 segundos.
      final response = await http
          .get(url)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              // El sistema lanza una respuesta simulada de error si se agota el tiempo.
              throw http.ClientException(
                "Tiempo de espera agotado. Revisa la conexión con TecnoPill.",
              );
            },
          );

      print(">>> ESTADO ESP32: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      // El sistema captura el error (Timeout o Red) y evita que la aplicación colapse.
      print(">>> ERROR DE CONEXIÓN WIFI: $e");
      return false;
    }
  }
}
