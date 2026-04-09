import 'package:http/http.dart' as http;
import 'bluetooth_servicio.dart';
import '../models/schedule.dart';

class WifiServicio {
  // Aquí usamos la IP que guardamos en el paso 1
  String get ipTecnoPill => MiBluetoothService().ipActualESP32 ?? "";

  Future<bool> enviarHorario(Schedule s) async {
    if (ipTecnoPill.isEmpty) return false;

    final url = Uri.parse('http://$ipTecnoPill/configurar');
    try {
      String trama =
          "CAS|${s.casillero}|${s.medicamento}|${s.horaProxima}|${s.minutoProxima}|${s.intervaloMinutos}|${s.tomasRestantes}";

      final response = await http.post(url, body: {'data': trama});
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
