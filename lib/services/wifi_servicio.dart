import 'package:http/http.dart' as http;
import 'bluetooth_servicio.dart';
import '../database/app_database.dart';

class WifiServicio {
  String get ipTecnoPill {
    String? ipDetectada = MiBluetoothService().ipActualESP32;
    if (ipDetectada == null || ipDetectada.isEmpty) {
      return "192.168.1.71";
    }
    return ipDetectada;
  }

  String _abreviarNombre(String nombreCompleto) {
    List<String> partes = nombreCompleto.split(' ');
    if (partes.length <= 1) return nombreCompleto;

    String nombrePila = partes[0];
    String inicialesApellidos = "";

    for (int i = 1; i < partes.length; i++) {
      if (partes[i].isNotEmpty) {
        inicialesApellidos += " ${partes[i][0]}.";
      }
    }

    String resultado = "$nombrePila$inicialesApellidos";
    return resultado.length > 16 ? resultado.substring(0, 16) : resultado;
  }

  // ✅ CORRECTO
  Future<bool> enviarHorario(Schedule s) async {
    final ip = ipTecnoPill;

    String nombreParaMostrar = _abreviarNombre(
      s.pacienteNombre.isNotEmpty ? s.pacienteNombre : "Paciente",
    );

    final url = Uri.parse(
      'http://$ip/enviarMed?nombre=${Uri.encodeComponent(s.medicamento)}&paciente=${Uri.encodeComponent(nombreParaMostrar)}',
    );

    try {
      print(">>> ENVIANDO A TECNOPILL: $url");

      final response = await http.get(url).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw http.ClientException(
            "Tiempo de espera agotado. Revisa la conexión con TecnoPill.",
          );
        },
      );

      print(">>> ESTADO ESP32: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      print(">>> ERROR DE CONEXIÓN WIFI: $e");
      return false;
    }
  }
}