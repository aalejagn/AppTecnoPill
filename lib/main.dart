import 'dart:math';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/add_patient_screen.dart';
import 'screens/add_schedule_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/wifi_screen.dart';
import 'screens/bluetooth_screen.dart';
import 'services/bluetooth_servicio.dart';
import 'database/app_database.dart';

late AppDatabase database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = AppDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3D7DC8)),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isOpen = false;

  late AnimationController _controller;
  late Animation<double> _expandAnim;

  final List<Widget> _screens = [
    HomeScreen(),
    HistoryScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  late final List<_ArcItem> _arcItems = [
    _ArcItem(
      angle: -150,
      icon: Icons.medication,
      label: 'Agregar\nHorario',
      onTap: () {
        toggleMenu();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddScheduleScreen()),
        );
      },
    ),
    _ArcItem(
      angle: -30,
      icon: Icons.person_add,
      label: 'Agregar\nPacientes',
      onTap: () {
        toggleMenu();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddPatientScreen()),
        );
      },
    ),
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    // 🔥 BOUNCE SUAVE TIPO iOS
    _expandAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleMenu() {
    setState(() {
      _isOpen = !_isOpen;
      _isOpen ? _controller.forward() : _controller.reverse();
    });
  }

  Color get activeColor => const Color(0xFF3D7DC8);
  Color get inactiveColor => Colors.grey;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    final fabCenterX = size.width / 2;

    // 🔥 FIX correcto
    final fabCenterY = size.height - padding.bottom - 90;

    final double radius = size.width * 0.23;
    const double btnSize = 64;

    return Scaffold(
      extendBody: true,

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF3D7DC8)),
              child: Text(
                "Menú",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.wifi),
              title: const Text("WiFi"),
              onTap: () {
                Navigator.pop(context);
                if (_isOpen) toggleMenu();

                final conectado = MiBluetoothService().dispositivoConectado;

                if (conectado != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WifiScreen(device: conectado),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Conecta Bluetooth primero")),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BluetoothScreen()),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.bluetooth),
              title: const Text("Bluetooth"),
              onTap: () {
                Navigator.pop(context);
                if (_isOpen) toggleMenu();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BluetoothScreen()),
                );
              },
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          _screens[_currentIndex],

          if (_isOpen)
            GestureDetector(
              onTap: toggleMenu,
              child: Container(color: Colors.black.withOpacity(0.55)),
            ),

          ..._arcItems.map((item) {
            final rad = item.angle * pi / 180;
            final dx = cos(rad) * radius;
            final dy = sin(rad) * radius;

            return AnimatedBuilder(
              animation: _expandAnim,
              builder: (context, _) {
                final t = _expandAnim.value;

                final cx = fabCenterX + dx * t;
                final cy = fabCenterY + dy * t;

                return Opacity(
                  opacity: t.clamp(0.0, 1.0),
                  child: Stack(
                    children: [
                      Positioned(
                        left: cx - 55,
                        top: cy - btnSize / 2 - 52,
                        child: SizedBox(
                          width: 110,
                          child: Text(
                            item.label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 6,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        left: cx - btnSize / 2,
                        top: cy - btnSize / 2,
                        child: GestureDetector(
                          onTap: item.onTap,
                          child: Container(
                            width: btnSize,
                            height: btnSize,
                            decoration: BoxDecoration(
                              color: activeColor.withOpacity(0.95),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: activeColor.withOpacity(0.35),
                                  blurRadius: 18,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Icon(
                              item.icon,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(Icons.home_rounded, 'Inicio', 0),
              _buildNavItem(Icons.calendar_today_rounded, 'Historial', 1),
              const SizedBox(width: 56),
              _buildNavItem(Icons.person_rounded, 'Perfil', 2),
              _buildNavItem(Icons.settings_rounded, 'Config', 3),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(), // 🔥 IMPORTANTE
        backgroundColor: _isOpen ? Colors.redAccent : activeColor,
        onPressed: toggleMenu,
        child: AnimatedRotation(
          turns: _isOpen ? 0.125 : 0,
          duration: const Duration(milliseconds: 300),
          child: Icon(
            _isOpen ? Icons.close : Icons.add,
            size: 28,
            color: Colors.white,
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? activeColor : inactiveColor, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArcItem {
  final double angle;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ArcItem({
    required this.angle,
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
