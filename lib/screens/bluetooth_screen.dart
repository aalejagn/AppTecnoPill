import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_aplicacion1/services/bluetooth_servicio.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  // Lógica de backend
  final MiBluetoothService _bluetoothService = MiBluetoothService();
  List<ScanResult> _listaDispositivos = [];

  @override
  void initState() {
    super.initState();
    // Escuchamos los resultados reales del escaneo
    FlutterBluePlus.scanResults.listen((resultados) {
      final listaLimpia = resultados.where((r) {
        return r.advertisementData.advName.isNotEmpty;
      }).toList();
      
      setState(() {
        _listaDispositivos = listaLimpia;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hacemos el AppBar transparente para que se vean los círculos de fondo
      appBar: AppBar(
        title: const Text("Conectar TecnoPill", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // FONDO DECORATIVOJAJAJJA
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

          // CONTENIDO REAL
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
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      // Botón de Escanear vinculado al servicio
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F7CAC),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          _bluetoothService.startScan();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Buscando TecnoPill... 🔍"), duration: Duration(seconds: 2)),
                          );
                        },
                        icon: const Icon(Icons.search, size: 18),
                        label: const Text("Escanear"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  //LISTA DE DISPOSITIVOS REALES
                  Expanded(
                    child: _listaDispositivos.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.bluetooth_searching, size: 50, color: Colors.grey[400]),
                                const SizedBox(height: 10),
                                Text("No hay dispositivos a la vista", style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _listaDispositivos.length,
                            itemBuilder: (context, index) {
                              final scanResult = _listaDispositivos[index];
                              final nombre = scanResult.advertisementData.advName;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Color(0xFFE3F2FD),
                                    child: Icon(Icons.bluetooth, color: Color(0xFF3F7CAC)),
                                  ),
                                  title: Text(
                                    nombre,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(scanResult.device.remoteId.toString(), style: const TextStyle(fontSize: 12)),
                                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                                  onTap: () => _mostrarDialogoConexion(context, scanResult),
                                ),
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

  // Widget auxiliar para los círculos de fondo
  Widget _circle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  // Ventana de confirmación 
  void _mostrarDialogoConexion(BuildContext context, ScanResult resultado) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Conectar a ${resultado.advertisementData.advName}"),
          content: const Text("¿Deseas vincular este dispositivo con TecnoPill?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F7CAC),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                _bluetoothService.connectarServicio(resultado.device);
                Navigator.pop(context);
                // 
              },
              child: const Text("Conectar"),
            ),
          ],
        );
      },
    );
  }
}