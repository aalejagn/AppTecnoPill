import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool recordatorios = true;
  bool bluetoothActivo = true;

  // ---------- COMPONENTES REUTILIZABLES ----------

  Widget sectionCard({required Widget child}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: child,
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget optionTile(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF3D7DC8),
      ),
      title: Text(title),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  // ---------- BUILD PRINCIPAL ----------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),

      body: ListView(
        children: [
          // USUARIO
          sectionCard(
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 30,
                  child: Icon(
                    Icons.person,
                    size: 30,
                  ),
                ),

                SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kaleb Toledo",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text("kaleb@email.com"),
                  ],
                ),
              ],
            ),
          ),

          // ESTADISTICAS
          sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle("Resumen general"),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                  children: const [
                    Column(
                      children: [
                        Text(
                          "12",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Pacientes"),
                      ],
                    ),

                    Column(
                      children: [
                        Text(
                          "35",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Medicamentos"),
                      ],
                    ),

                    Column(
                      children: [
                        Text(
                          "120",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Registros"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // PACIENTES
          sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle("Pacientes"),

                ListTile(
                  title: const Text("Max"),
                  trailing: const Icon(Icons.more_vert),
                  onTap: () {},
                ),

                ListTile(
                  title: const Text("Luna"),
                  trailing: const Icon(Icons.more_vert),
                  onTap: () {},
                ),
              ],
            ),
          ),

          // ESTADO DEL SISTEMA
          sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle("Estado del sistema"),

                SwitchListTile(
                  secondary: const Icon(
                    Icons.bluetooth,
                    color: Color(0xFF3D7DC8),
                  ),

                  title: const Text("Bluetooth"),

                  subtitle: Text(
                    bluetoothActivo
                        ? "Conectado"
                        : "Desconectado",
                  ),

                  value: bluetoothActivo,

                  activeColor:
                      const Color(0xFF3D7DC8),

                  onChanged: (value) {
                    setState(() {
                      bluetoothActivo = value;
                    });
                  },
                ),
              ],
            ),
          ),

          // NOTIFICACIONES
          sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle("Notificaciones"),

                SwitchListTile(
                  title:
                      const Text("Recordatorios"),

                  value: recordatorios,

                  activeColor:
                      const Color(0xFF3D7DC8),

                  onChanged: (value) {
                    setState(() {
                      recordatorios = value;
                    });
                  },
                ),
              ],
            ),
          ),

          // CONFIGURACION
          sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle("Configuración"),

                optionTile(
                  Icons.settings,
                  "Configuración general",
                  () {},
                ),

                optionTile(
                  Icons.security,
                  "Privacidad",
                  () {},
                ),
              ],
            ),
          ),

          // EXPORTAR
          sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle("Exportar datos"),

                optionTile(
                  Icons.upload_file,
                  "Exportar respaldo",
                  () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}