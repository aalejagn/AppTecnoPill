import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class MiBluetoothService {
  //Funcion para empezar a ascanear dispositivos

  void startScan() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 15));

    //Escuchar los resultados
    FlutterBluePlus.scanResults.listen((resultados) {
      for (ScanResult r in resultados) {
        print(
          '${r.device.remoteId}:"${r.advertisementData.advName}" Encontrado',
        );
      }
    });
  }

  //Función para conectar a un dispositivo especifico
  Future<void> connectarServicio(BluetoothDevice dispositivo) async {
    await dispositivo.connect();
    print("Conectado a ${dispositivo.platformName}");
  }

  //Envio de string a bytes para ESP32
  Future<void> enviarDatosWifi(
    BluetoothDevice dispositivo,
    String datos,
  ) async {
    //1.- Descubrir Los servicios del ESP32

    List<BluetoothService> servicios = await dispositivo.discoverServices();

    for (var servicio in servicios) {
      for (var caracteristica in servicio.characteristics) {
        //Buscamos la caracteristica que permita Escritura (write)
        if (caracteristica.properties.write) {
          //Convertir el texto a bytes (UTF-8) para que el ESP32 lo entienda
          await caracteristica.write(datos.codeUnits);
          print("Datos enviados: $datos ");
        }
      }
    }
  }

  //Escuchar al ESP32
  //Para uso Global
  List<String> redesWifi = [];

  Future<void> prepararEscucha(BluetoothDevice dispositivo) async {
    //La lista con todo los servicios disponibles
    List<BluetoothService> servicios = await dispositivo.discoverServices();
    //Entramos a un ciclo para revisar cada servicio ESP32
    for (var servicio in servicios) {
      // Dentro de cada servicio revisamos sus caracteristicas
      for (var caracteristica in servicio.characteristics) {
        // Aviso
        if (caracteristica.properties.notify) {
          await caracteristica.setNotifyValue(true);
          // Flujo de datos constante, esperando que mande algo el ESP32
          caracteristica.lastValueStream.listen((value) {
            //Traduccion
            String rawRespuesta = String.fromCharCodes(value);

            redesWifi = rawRespuesta.split(',');

            print("Redes Encontradas desde el ESP32: $redesWifi");
          });
        }
      }
    }
  }

  //Funcionra para empaquetar y enviar credenciales
  Future<void> conectarWifiESP32(
    BluetoothDevice dispositivo,
    String ssid,
    String contrasena,
  ) async {
    //Primero sera el empaquetado, se enviara en un solo String
    String tramaFinal = "WIFI_CONNECT|$ssid|$contrasena";

    print("Preparando envio de credenciales $tramaFinal");

    //Reutilizar la funcion enviarDatosWifi por que ya convierte a bytes
    try {
      await enviarDatosWifi(dispositivo, tramaFinal);
      print("Protocolo de conexion enviado con exito.");
    } catch (e) {
      print("Error al  intentar Enviar el paquete de Wifi $e");
    }
  }
}
