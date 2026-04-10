import 'package:http/http.dart' as http;
import 'bluetooth_servicio.dart';
import '../models/schedule.dart';

class WifiServicio {
  // Intentamos obtener la IP del bluetooth, si no, usamos la que ya conocemos
  String get ipTecnoPill {
    String? ipDetectada = MiBluetoothService().ipActualESP32;
    if (ipDetectada == null || ipDetectada.isEmpty) {
      return "192.168.1.71"; // IP fija de respaldo para pruebas
    }
    return ipDetectada;
  }

  Future<bool> enviarHorario(Schedule s) async {
    final ip = ipTecnoPill;

    // Formateamos la hora para que siempre tenga dos dígitos en los minutos
    String horaFormateada =
        "${s.horaProxima}:${s.minutoProxima.toString().padLeft(2, '0')}";

    // Construimos la URL manualmente para estar seguros
    final url = Uri.parse(
      'http://$ip/enviarMed?nombre=${s.medicamento}&hora=$horaFormateada',
    );

    try {
      print(">>> INTENTANDO ENVIAR A: $url"); // ESTO DEBE SALIR EN TU CONSOLA

      final response = await http.get(url).timeout(const Duration(seconds: 5));

      print(">>> RESPUESTA DEL ESP32: ${response.statusCode}");
      print(">>> CUERPO: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print(">>> ERROR CRÍTICO EN WIFI: $e");
      return false;
    }
  }
}
