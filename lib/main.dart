import 'package:flutter/material.dart';
import 'package:flutter_aplicacion1/screens/imc_bluetooth_screen.dart';
// import 'package:flutter_aplicacion1/core/app_colores.dart';
import 'package:flutter_aplicacion1/screens/splash_screen.dart';

void main() {
  runApp(const TecnoPillApp());
}

class TecnoPillApp extends StatelessWidget {
  const TecnoPillApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Quitar el banner de la esquina
      debugShowCheckedModeBanner: false,
      title: "TecnoPill App",

      //Configuracion visual de la aplicacion
      theme: ThemeData(
        //Usar el material 3 por que es el mas reciente
        useMaterial3: true,
        //Colores
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent,
        primary: Colors.blueAccent,),
      ),
    
    //Plantilla de bluetooth
    home: SplashScreen(),
    // home: BluetoothScreen(),
    );
  }
}

