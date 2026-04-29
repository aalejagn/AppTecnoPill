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
  String? _redConectadaActual; //Nueva Variable

  @override
  void initState() {
    super.initState();
    _configurarEscucha();
    // Recuperamos el nombre si ya se había conectado antes
    _redConectadaActual = _bleService.nombreRedActual;
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
    if (widget.device == null) return; // Seguridad extra

    await _bleService.prepararEscucha(widget.device!);

    // En lugar de un doWhile infinito, escucha cambios solo si el widget existe
    Stream.periodic(const Duration(milliseconds: 800)).listen((_) {
      if (!mounted) return; // Si ya no estás en la pantalla, se detiene

      if (_redesDetectadas.length != _bleService.redesWifi.length) {
        setState(() {
          _redesDetectadas = List.from(_bleService.redesWifi);
        });
      }
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
    // En lugar de enviar la cadena manual "$ssid,$pass",
    // usa la función que ya armamos en el servicio que pone el prefijo WIFI_CONNECT|
    if (widget.device != null) {
      await _bleService.conectarWifiESP32(widget.device!, ssid, pass);
    }
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
    bool esEstaRed = _redConectadaActual == nombreRed; //Verificamos

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        //Borde Verde Sutil
        border: Border.all(
          color: esEstaRed ? Colors.green.withOpacity(0.5) : Colors.transparent,
          width: 2,
        ),
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
        //Agregamos el "CONECTADO"
        subtitle: esEstaRed
            ? const Text(
                "Conectado",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _mostrarDialogoConexion(nombreRed),
      ),
    );
  }

  /// Espera la respuesta real del ESP32 por BLE.
  /// Devuelve true si llegó WIFI_OK, false si llegó WIFI_FAIL o se agotó el tiempo.
  Future<bool> _esperarRespuestaWifi() async {
    // Limpiamos cualquier respuesta vieja antes de esperar
    _bleService.ultimaRespuestaWifi = null;

    const maxEspera = Duration(seconds: 12);
    const intervalo = Duration(milliseconds: 300);
    final limite = DateTime.now().add(maxEspera);

    while (DateTime.now().isBefore(limite)) {
      await Future.delayed(intervalo);
      final resp = _bleService.ultimaRespuestaWifi;
      if (resp == "WIFI_OK") return true;
      if (resp == "WIFI_FAIL") return false;
    }
    return false; // Timeout = fallo
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
                    const Text("Esperando respuesta del TecnoPill..."),
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

                          // Enviamos las credenciales al ESP32
                          _enviarCredenciales(
                            nombreRed,
                            passwordController.text,
                          );

                          // Esperamos la respuesta REAL del ESP32
                          final exito = await _esperarRespuestaWifi();

                          if (!mounted) return;
                          Navigator.pop(context);

                          if (exito) {
                            // Solo marcamos conectado si el ESP32 confirmó
                            setState(() {
                              _redConectadaActual = nombreRed;
                              _bleService.nombreRedActual = nombreRed;
                            });
                            _mostrarExito(nombreRed);
                          } else {
                            // Contraseña incorrecta o timeout
                            _mostrarError(nombreRed);
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

  // --- Modal de error ---
  void _mostrarError(String red) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, color: Colors.white, size: 70),
              const SizedBox(height: 15),
              const Text(
                "No se pudo conectar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi, color: Colors.white70, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    red,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                "Verifica la contraseña e intenta de nuevo",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Intentar de nuevo"),
              ),
            ],
          ),
        ),
      ),
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
                "¡Datos enviada!",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi, color: Colors.white70, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    red,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                "Conectado",
                style: TextStyle(color: Colors.white70, fontSize: 13),
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