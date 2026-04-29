import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_aplicacion1/services/bluetooth_servicio.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  // Usamos la instancia única del servicio (Singleton)
  final MiBluetoothService _bluetoothService = MiBluetoothService();
  List<ScanResult> _listaDispositivos = [];

  @override
  void initState() {
    super.initState();

    // Escuchamos los resultados del escaneo
    FlutterBluePlus.scanResults.listen((resultados) {
      // Filtramos dispositivos que tengan nombre (para no llenar la lista de basura)
      final listaLimpia = resultados.where((r) {
        return r.advertisementData.advName.isNotEmpty;
      }).toList();

      if (mounted) {
        setState(() {
          _listaDispositivos = listaLimpia;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Conectar TecnoPill",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Stack(
        children: [
          // FONDO DECORATIVO
          Container(color: const Color(0xFFF8F9FA)),
          Positioned(
            top: -80,
            left: -80,
            child: _circle(const Color(0xFF3F7CAC).withOpacity(0.3), 200),
          ),
          Positioned(
            top: -60,
            right: -60,
            child: _circle(const Color(0xFFF2F4F3), 180),
          ),
          Positioned(
            bottom: -100,
            right: -50,
            child: _circle(const Color(0xFF3F7CAC).withOpacity(0.2), 220),
          ),

          // CONTENIDO
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Dispositivos cercanos",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F7CAC),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        // El sistema requiere 'async' aquí para poder usar 'await' adentro
                        onPressed: () async {
                          // 1. El sistema verifica de forma asíncrona el estado del adaptador
                          BluetoothAdapterState state =
                              await FlutterBluePlus.adapterState.first;

                          if (state != BluetoothAdapterState.on) {
                            // 2. Si el Bluetooth está apagado, el sistema muestra la alerta de seguridad
                            _mostrarAlertaBluetooth(context);
                          } else {
                            // 3. El sistema inicia el escaneo si el hardware está listo
                            _bluetoothService.startScan();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Buscando TecnoPill... 🔍"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.search, size: 18),
                        label: const Text("Escanear"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // LISTA DE DISPOSITIVOS
                  Expanded(
                    child: _listaDispositivos.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            itemCount: _listaDispositivos.length,
                            itemBuilder: (context, index) {
                              final scanResult = _listaDispositivos[index];
                              final nombre =
                                  scanResult.advertisementData.advName;

                              // Verificamos si es el dispositivo que ya tenemos conectado
                              bool estaConectado =
                                  _bluetoothService
                                      .dispositivoConectado
                                      ?.remoteId ==
                                  scanResult.device.remoteId;

                              return _buildDeviceCard(
                                scanResult,
                                nombre,
                                estaConectado,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para cuando no hay dispositivos
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bluetooth_searching, size: 50, color: Colors.grey[400]),
          const SizedBox(height: 10),
          Text(
            "No hay dispositivos a la vista",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // Widget para cada tarjeta de dispositivo
  Widget _buildDeviceCard(
    ScanResult scanResult,
    String nombre,
    bool estaConectado,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          // Cambié greenAccent por Green normal para que resalte más
          color: estaConectado ? Colors.green : Colors.transparent,
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: estaConectado
                ? Colors.green.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          // El círculo del icono también cambia a verde si está conectado
          backgroundColor: estaConectado
              ? Colors.green[50]
              : const Color(0xFFE3F2FD),
          child: Icon(
            Icons.bluetooth,
            color: estaConectado ? Colors.green : const Color(0xFF3F7CAC),
          ),
        ),
        title: Text(
          nombre,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        // AHORA: Subtítulo dinámico
        subtitle: Text(
          estaConectado ? "Conectado" : scanResult.device.remoteId.toString(),
          style: TextStyle(
            fontSize: 12,
            color: estaConectado ? Colors.green : Colors.black54,
            fontWeight: estaConectado ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: estaConectado
            ? TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                icon: const Icon(Icons.bluetooth_disabled, size: 16),
                label: const Text(
                  "Desconectar",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  await _bluetoothService.desconectar();
                  if (mounted) {
                    setState(() {
                      _listaDispositivos = [];
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Bluetooth desconectado 🔌"),
                      ),
                    );
                  }
                },
              )
            : const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: estaConectado
            ? null
            : () => _mostrarDialogoConexion(context, scanResult),
      ),
    );
  }

  Widget _circle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  void _mostrarDialogoConexion(BuildContext context, ScanResult resultado) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        //Usaremos el dialogcontext para el dialogo
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text("Conectar a ${resultado.advertisementData.advName}"),
          content: const Text(
            "¿Deseas vincular este dispositivo con TecnoPill?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F7CAC),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.pop(dialogContext); // Cierra el diálogo

                try {
                  // USA LA VARIABLE GUARDADA
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text("Conectando..."),
                      duration: Duration(seconds: 1),
                    ),
                  );

                  await _bluetoothService.connectarServicio(resultado.device);

                  if (mounted) {
                    setState(() {});
                    // USA LA VARIABLE GUARDADA
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text("¡TecnoPill Conectado! ✅")),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text("Error al conectar.")),
                    );
                  }
                }
              },

              child: const Text("Conectar"),
            ),
          ],
        );
      },
    );
  }

  void _mostrarAlertaBluetooth(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.bluetooth_disabled, color: Colors.redAccent),
            SizedBox(width: 10),
            Text("Bluetooth Apagado"),
          ],
        ),
        content: const Text(
          "Para buscar tu TecnoPill, necesitas activar el Bluetooth de tu dispositivo.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Entendido"),
          ),
          // En Android, puedes intentar pedir que se encienda automáticamente:
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3F7CAC),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              // Intenta encenderlo (Solo funciona en Android)
              try {
                await FlutterBluePlus.turnOn();
              } catch (e) {
                print("No se pudo encender automáticamente: $e");
              }
            },
            child: const Text("Activar ahora"),
          ),
        ],
      ),
    );
  }
}
