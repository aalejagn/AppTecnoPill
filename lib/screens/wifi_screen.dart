import 'package:flutter/material.dart';

class WifiScreen extends StatefulWidget {
  const WifiScreen({super.key});

  @override
  State<WifiScreen> createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen> {

  bool _firstTime = true;

  // 🔌 Lista simulada de redes
  final List<Map<String, dynamic>> wifiNetworks = const [
    {"name": "Totalplay-1234", "strength": 3},
    {"name": "Izzi-5678", "strength": 2},
    {"name": "INFINITUM-ABCD", "strength": 4},
    {"name": "MiCelular", "strength": 1},
    {"name": "VecinoWiFi", "strength": 2},
  ];

  IconData getWifiIcon(int strength) {
    switch (strength) {
      case 4:
        return Icons.wifi;
      case 3:
        return Icons.wifi_2_bar;
      case 2:
        return Icons.wifi_1_bar;
      default:
        return Icons.wifi_off;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_firstTime) {
        _showHelpDialog();
        _firstTime = false;
      }
    });
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("¿Cómo funciona?"),
          content: const Text(
            "Aquí podrás conectarte a redes WiFi disponibles. "
            "Selecciona una red, ingresa la contraseña y listo.\n\n"
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Entendido"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WiFi"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [

          // 🔵 FONDO
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

          // 📶 CONTENIDO
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 🔥 TITULO + BOTÓN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Redes disponibles",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F7CAC),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Escaneando redes... 📡"),
                            ),
                          );
                        },
                        child: const Text("Escanear"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView.builder(
                      itemCount: wifiNetworks.length,
                      itemBuilder: (context, index) {
                        final wifi = wifiNetworks[index];

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
                            leading: Icon(
                              getWifiIcon(wifi["strength"]),
                              color: const Color(0xFF3F7CAC),
                            ),
                            title: Text(wifi["name"]),
                            trailing: const Icon(Icons.lock),
                            onTap: () {
                              final TextEditingController passwordController =
                                  TextEditingController();
                              bool obscure = true;
                              bool isLoading = false;

                              showDialog(
                                context: context,
                                barrierDismissible: !isLoading,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        title: Text(
                                            "Conectar a ${wifi["name"]}"),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: passwordController,
                                              obscureText: obscure,
                                              enabled: !isLoading,
                                              decoration: InputDecoration(
                                                labelText: "Contraseña",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    obscure
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      obscure = !obscure;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 20),

                                            if (isLoading)
                                              const Column(
                                                children: [
                                                  CircularProgressIndicator(),
                                                  SizedBox(height: 10),
                                                  Text("Conectando..."),
                                                ],
                                              ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: isLoading
                                                ? null
                                                : () =>
                                                    Navigator.pop(context),
                                            child: const Text("Cancelar"),
                                          ),
                                          ElevatedButton(
                                            onPressed: isLoading
                                                ? null
                                                : () async {
                                                    setState(() {
                                                      isLoading = true;
                                                    });

                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 2));

                                                    Navigator.pop(context);

                                                    // 🔥 MODAL ÉXITO
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (context) {
                                                        return Dialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                          ),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(25),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xFF3F7CAC),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 80,
                                                                ),
                                                                const SizedBox(
                                                                    height: 20),
                                                                const Text(
                                                                  "Conectado a",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 8),
                                                                Text(
                                                                  wifi["name"],
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        22,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 20),
                                                                ElevatedButton(
                                                                  onPressed: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      "Aceptar"),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                            child: const Text("Conectar"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
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

  Widget _circle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}