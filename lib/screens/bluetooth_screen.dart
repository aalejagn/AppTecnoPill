import 'package:flutter/material.dart';

class BluetoothScreen extends StatelessWidget {
  const BluetoothScreen({super.key});

  // 🔵 dispositivos simulados
  final List<Map<String, dynamic>> devices = const [
    {"name": "AirPods Pro", "type": Icons.headphones},
    {"name": "Bocina JBL", "type": Icons.speaker},
    {"name": "Smart Watch", "type": Icons.watch},
    {"name": "Teclado Bluetooth", "type": Icons.keyboard},
    {"name": "Mouse Logitech", "type": Icons.mouse},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth"),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            right: -50,
            child: _circle(const Color(0xFF3F7CAC).withOpacity(0.2), 220),
          ),

          // 📡 CONTENIDO
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 🔥 TITULO + ESCANEAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Dispositivos disponibles",
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
                              content: Text("Buscando dispositivos... 🔍"),
                            ),
                          );
                        },
                        child: const Text("Escanear"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 📋 LISTA
                  Expanded(
                    child: ListView.builder(
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        final device = devices[index];

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
                              device["type"],
                              color: const Color(0xFF3F7CAC),
                            ),
                            title: Text(device["name"]),
                            trailing: const Icon(Icons.bluetooth),

                            onTap: () {
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
                                            "Conectar a ${device["name"]}"),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [

                                            if (isLoading)
                                              const Column(
                                                children: [
                                                  CircularProgressIndicator(),
                                                  SizedBox(height: 10),
                                                  Text("Conectando..."),
                                                ],
                                              )
                                            else
                                              const Text(
                                                  "¿Deseas conectar este dispositivo?"),
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
                                                      builder: (context) {
                                                        return Dialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(25),
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
                                                                Text(
                                                                  "Conectado a",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.9),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 8),
                                                                Text(
                                                                  device["name"],
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
                                                                  style:
                                                                      ElevatedButton
                                                                          .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    foregroundColor:
                                                                        const Color(
                                                                            0xFF3F7CAC),
                                                                  ),
                                                                  onPressed: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
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