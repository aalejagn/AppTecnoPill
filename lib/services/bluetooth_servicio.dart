import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class MiBluetoothService {
  // --- PATRÓN SINGLETON ---
  static final MiBluetoothService _instance = MiBluetoothService._internal();

  factory MiBluetoothService() {
    return _instance;
  }

  MiBluetoothService._internal();
  // -------------------------

  static const String _serviceUUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  static const String _charUUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";

  BluetoothDevice? dispositivoConectado;
  BluetoothCharacteristic? _caracteristica;
  List<String> redesWifi = [];

  /// Última respuesta de conexión WiFi recibida del ESP32.
  /// Valores posibles: "WIFI_OK", "WIFI_FAIL", o null si aún no hay respuesta.
  String? ultimaRespuestaWifi;

  // ip
  String? ipActualESP32;
  String? nombreRedActual;

  void startScan() async {
    try {
      BluetoothAdapterState state = await FlutterBluePlus.adapterState.first;

      if (state != BluetoothAdapterState.on) {
        print("[BLE] El escaneo no puede iniciar: Bluetooth apagado.");
        return;
      }

      if (FlutterBluePlus.isScanningNow) {
        print("[BLE] Ya se encuentra realizando un escaneo.");
        return;
      }

      print("[BLE] Iniciando escaneo de 15 segundos...");

      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
        androidUsesFineLocation: true,
      );

      FlutterBluePlus.scanResults.listen((resultados) {
        for (ScanResult r in resultados) {
          print(
            '${r.device.remoteId}:"${r.advertisementData.advName}" Encontrado',
          );
        }
      });
    } catch (e) {
      print("[BLE] Error crítico durante el escaneo: $e");
    }
  }

  Future<void> connectarServicio(BluetoothDevice dispositivo) async {
    try {
      print("[BLE] Conectando a ${dispositivo.advName}...");
      await dispositivo.connect();
      dispositivoConectado = dispositivo;
      print("[BLE] Conectado a ${dispositivo.platformName}");
      await prepararEscucha(dispositivo);
    } catch (e) {
      print("[BLE] Error al conectar: $e");
    }
  }

  Future<void> prepararEscucha(BluetoothDevice dispositivo) async {
    if (_caracteristica != null) {
      print("[BLE] ya estaba suscrito skip");
      return;
    }

    try {
      print("[BLE] Descubriendo servicios...");
      List<BluetoothService> servicios = await dispositivo.discoverServices();

      for (var servicio in servicios) {
        if (servicio.uuid.toString() != _serviceUUID) continue;

        for (var caracteristica in servicio.characteristics) {
          if (caracteristica.uuid.toString() != _charUUID) continue;

          _caracteristica = caracteristica;

          await caracteristica.setNotifyValue(true);
          print("[BLE] Suscrito a notificaciones. Listo para recibir.");

          caracteristica.lastValueStream.listen((value) {
            if (value.isEmpty) return;
            String rawRespuesta = String.fromCharCodes(value);
            print("[BLE] Recibido: $rawRespuesta");

            if (rawRespuesta.startsWith("IP|")) {
              ipActualESP32 = rawRespuesta.split('|')[1].trim();
              print("¡IP capturada con éxito!: $ipActualESP32");
              return;
            }

            if (rawRespuesta == "SCAN" ||
                rawRespuesta == "ABRIENDO" ||
                rawRespuesta.startsWith("WIFI_CONNECT"))
              return;

            // Capturamos el resultado real de la conexión WiFi
            if (rawRespuesta == "WIFI_OK" || rawRespuesta == "WIFI_FAIL") {
              ultimaRespuestaWifi = rawRespuesta;
              print("[BLE] Resultado WiFi: $ultimaRespuestaWifi");
              return;
            }

            redesWifi = rawRespuesta.trim().split(',');
            print("Redes Encontradas: $redesWifi");
          });

          break;
        }
      }
    } catch (e) {
      print("[BLE] Error al preparar escucha: $e");
    }
  }

  Future<void> enviarDatosWifi(
    BluetoothDevice dispositivo,
    String datos,
  ) async {
    if (_caracteristica == null) {
      print(
        "[BLE] Error: caracteristica no lista, llama connectarServicio primero.",
      );
      return;
    }
    print("[BLE] Enviando: $datos");
    await _caracteristica!.write(datos.codeUnits, withoutResponse: false);
    print("[BLE] Enviado OK.");
  }

  Future<void> conectarWifiESP32(
    BluetoothDevice dispositivo,
    String ssid,
    String contrasena,
  ) async {
    String tramaFinal = "WIFI_CONNECT|$ssid|$contrasena";
    try {
      await enviarDatosWifi(dispositivo, tramaFinal);
      print("Protocolo de conexion enviado con exito.");
    } catch (e) {
      print("Error al intentar Enviar el paquete de Wifi $e");
    }
  }

  void limpiarConexion() {
    dispositivoConectado = null;
    _caracteristica = null;
    redesWifi = [];
    print("[BLE] Estado limpiado.");
  }

  /// Desconecta el dispositivo BLE y limpia el estado interno.
  /// Útil cuando el ESP32 se reinicia y la app queda en estado fantasma.
  Future<void> desconectar() async {
    try {
      if (dispositivoConectado != null) {
        await dispositivoConectado!.disconnect();
        print("[BLE] Dispositivo desconectado correctamente.");
      }
    } catch (e) {
      print("[BLE] Error al desconectar (puede que ya estuviera caído): $e");
    } finally {
      limpiarConexion();
    }
  }
}
