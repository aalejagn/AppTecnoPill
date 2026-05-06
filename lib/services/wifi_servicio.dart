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

  //
  Future<bool> enviarHorario(Schedule s) async {
    final ip = ipTecnoPill;

    String nombreMed = s.medicamento;
    String nombreParaMostrar = _abreviarNombre(
      s.pacienteNombre.isNotEmpty ? s.pacienteNombre : "Paciente",
    );

    //Mapeamos el casillero
    // Esto facilita la lógica en el ESP32 para manejar los servos
    String casilleroId = (s.casillero == 1) ? "1" : "2";

    // nombre: Medicamento
    // paciente: Nombre abreviado
    // c: Casillero (A o B)
    // h: Hora de la toma
    // m: Minuto de la toma
    // int: Intervalo en minutos
    // tot: Total de tomas a sonar
    final url = Uri.parse(
      'http://$ip/enviarMed?'
      'nombre=${Uri.encodeComponent(nombreMed)}'
      '&paciente=${Uri.encodeComponent(nombreParaMostrar)}'
      '&c=$casilleroId'
      '&h=${s.horaProxima}'
      '&m=${s.minutoProxima}'
      '&int=${s.intervaloMinutos}'
      '&tot=${s.tomasRestantes}',
    );

    try {
      print("=========== DEBUG TECNOPILL ===========");
      print("IP detectada: $ip");
      print("Medicamento: $nombreMed");
      print("Paciente: $nombreParaMostrar");
      print("Casillero: $casilleroId");
      print("Hora: ${s.horaProxima}:${s.minutoProxima}");
      print("Intervalo: ${s.intervaloMinutos}");
      print("Tomas restantes: ${s.tomasRestantes}");
      print("URL FINAL: $url");

      final response = await http
          .get(url)
          .timeout(
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

  Future<void> escucharESP32() async {
    final ip = ipTecnoPill;

    try {
      final response = await http.get(Uri.parse('http://$ip/estado'));

      if (response.statusCode == 200) {
        final data = response.body.split(',');

        int casillero = int.parse(data[0]);
        String estado = data[1];

        // 🚨 IMPORTANTE: ignorar cuando no hay evento
        if (casillero == 0 || estado == "none") {
          return;
        }

        bool tomada = estado == "tomada";

        print("Evento ESP32 → Casillero $casillero | Estado: $estado");

        await db.actualizarTomaDesdeESP32(casillero, tomada);
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
