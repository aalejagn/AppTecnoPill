import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;
  bool bluetooth = false;
  bool darkMode = false;

  SwitchListTile _buildSwitch({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      secondary: Icon(icon),
      value: value,
      activeColor: const Color(0xFF3D7DC8),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuración")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // NOTIFICACIONES
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: _buildSwitch(
              title: "Notificaciones",
              subtitle: "Activar recordatorios",
              icon: Icons.notifications,
              value: notifications,
              onChanged: (value) => setState(() => notifications = value),
            ),
          ),

          // BLUETOOTH
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: _buildSwitch(
              title: "Bluetooth",
              subtitle: bluetooth ? "Conectado" : "Desconectado",
              icon: Icons.bluetooth,
              value: bluetooth,
              onChanged: (value) => setState(() => bluetooth = value),
            ),
          ),

          // MODO OSCURO
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: _buildSwitch(
              title: "Modo oscuro",
              subtitle: "Cambiar apariencia",
              icon: Icons.dark_mode,
              value: darkMode,
              onChanged: (value) => setState(() => darkMode = value),
            ),
          ),

          // EXPORTAR DATOS
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text("Exportar datos"),
              subtitle: const Text("Guardar respaldo"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Exportando datos...")),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
