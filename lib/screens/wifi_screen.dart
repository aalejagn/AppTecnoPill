import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'dart:convert'; // No se usa
import 'package:flutter_aplicacion1/services/bluetooth_servicio.dart';

class WifiScreen extends StatefulWidget {
  final BluetoothDevice?
  device; // <--- Agregamos el "?" para que pueda ser nulo
  const WifiScreen({super.key, this.device}); // <--- Quitamos el "required"

  @override
  State<WifiScreen> createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen> {
  bool _firstTime = true;
  final MiBluetoothService _bleService = MiBluetoothService();

  List<String> _redesDetectadas = [];
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _configurarEscucha();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_firstTime) {
        _showHelpDialog();
        _firstTime = false;
      }
    });
  }

  // --- NUEVO: Listener mejorado para evitar bucles pesados ---
  void _configurarEscucha() async {
    await _bleService.prepararEscucha(widget.device!);

    // Usamos un loop que verifica cambios cada 500ms para no saturar el procesador
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return false; // Detener si el widget ya no existe

      if (_redesDetectadas.length != _bleService.redesWifi.length) {
        setState(() {
          _redesDetectadas = List.from(_bleService.redesWifi);
        });
      }
      return true;
    });
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("¿Cómo funciona?"),
        content: const Text(
          "Aquí podrás conectarte a redes WiFi disponibles. "
          "Selecciona una red de la lista e ingresa la contraseña para configurar tu TecnoPill.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Entendido"),
          ),
        ],
      ),
    );
  }

  // --- NUEVO: Función para enviar credenciales al ESP32 ---
  void _enviarCredenciales(String ssid, String pass) async {
    // Formato sugerido: SSID,PASSWORD (Asegúrate que tu ESP32 sepa parsear esto)
    String data = "$ssid,$pass";
    await _bleService.enviarDatosWifi(widget.device!, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuración WiFi"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black87),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 🔵 FONDO DECORATIVO
          Container(color: Colors.white),
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
            left: -50,
            child: _circle(const Color(0xFF3F7CAC).withOpacity(0.2), 220),
          ),

          // CONTENIDO PRINCIPAL
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Redes cercanas",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: _isScanning
                            ? const SizedBox(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.refresh),
                        label: Text(_isScanning ? "..." : "Escanear"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F7CAC),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isScanning ? null : _iniciarEscaneo,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // LISTA DE REDES
                  Expanded(
                    child: _redesDetectadas.isEmpty
                        ? const Center(
                            child: Text("No hay redes. Pulsa Escanear."),
                          )
                        : ListView.builder(
                            itemCount: _redesDetectadas.length,
                            itemBuilder: (context, index) {
                              final nombreRed = _redesDetectadas[index];
                              return _itemRedWifi(nombreRed);
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

  // --- NUEVO: Lógica de escaneo separada ---
  void _iniciarEscaneo() async {
    setState(() => _isScanning = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Solicitando escaneo al dispositivo...")),
    );

    // Mandamos el comando "SCAN" al ESP32
    await _bleService.enviarDatosWifi(widget.device!, "SCAN");

    // Tiempo de espera para que el ESP32 responda
    await Future.delayed(const Duration(seconds: 4));
    if (mounted) setState(() => _isScanning = false);
  }

  // --- NUEVO: Widget de item de lista para limpiar el build ---
  Widget _itemRedWifi(String nombreRed) {
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
        leading: const Icon(Icons.wifi, color: Color(0xFF3F7CAC)),
        title: Text(
          nombreRed,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _mostrarDialogoConexion(nombreRed),
      ),
    );
  }

  // --- Diálogo de conexión con StatefulBuilder y lógica limpia ---
  void _mostrarDialogoConexion(String nombreRed) {
    final TextEditingController passwordController = TextEditingController();
    bool obscure = true;
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            // Cambié el nombre a setLocalState para no confundir
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text("Conectar a $nombreRed"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: passwordController,
                    obscureText: obscure,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () =>
                            setLocalState(() => obscure = !obscure),
                      ),
                    ),
                  ),
                  if (isLoading) ...[
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    const Text("Enviando credenciales..."),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F7CAC),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setLocalState(() => isLoading = true);

                          // Enviamos los datos al servicio
                          _enviarCredenciales(
                            nombreRed,
                            passwordController.text,
                          );

                          // Simulación de espera de respuesta
                          await Future.delayed(const Duration(seconds: 2));

                          if (mounted) {
                            Navigator.pop(context); // Cierra diálogo de input
                            _mostrarExito(nombreRed); // Muestra éxito
                          }
                        },
                  child: const Text("Conectar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- NUEVO: Modal de éxito---
  void _mostrarExito(String red) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: const Color(0xFF3F7CAC),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 70),
              const SizedBox(height: 15),
              const Text(
                "¡Configuración enviada!",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 5),
              Text(
                red,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Aceptar"),
              ),
            ],
          ),
        ),
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
}
