import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_aplicacion1/services/bluetooth_servicio.dart';
// import 'package:flutter_aplicacion1/core/app_colores.dart';

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  //Instanciamos la logica del backend
  final MiBluetoothService _bluetoothService = MiBluetoothService();
  //Enccuentro local
  List<ScanResult> _listaDispositivos = [];

  @override
  //Primer metodo a ejecutar
  void initState() {
    super.initState();
    //Al iniciar la pantalla, escuchamos los resultados del escaneo
    FlutterBluePlus.scanResults.listen((resultados) {
      setState(() {
        _listaDispositivos = resultados; //Actualizamos la lista y se redibuja
      });
    });
  }

  @override
  //Se ejecuta cada vez que llamamos a SetState
  Widget build(BuildContext contexto) {
    //AppBar
    return Scaffold(
      appBar: AppBar(
        title: Text("Conectar TecnoPill"),
        backgroundColor: Colors.blueAccent,
      ),
      //Column organizacion de los elementos de forma vertical
      body: Column(
        children: [
          //Espacio acolchado para el boton
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: Icon(Icons.search),
              label: Text("Buscar Dispositivo"),
              onPressed: () => _bluetoothService.startScan(),
            ),
          ),
          //La lista usara todo el espacio sobrante en la pantalla
          Expanded(
            //Solo pintara lo que el usuaria ve en la pantalla
            child: ListView.builder(
              //Cantidad de elementos en la lista
              itemCount: _listaDispositivos.length,

              //Contruir cada reguion de la lista uno por uno
              itemBuilder: (context, index) {
                final d = _listaDispositivos[index];

                //Region estándar
                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.bluetooth),
                  ), //Icono circular
                  title: Text(
                    d.advertisementData.advName.isEmpty
                        ? "Dispositivo Desconocido"
                        : d.advertisementData.advName,
                  ),

                  subtitle: Text(d.device.remoteId.toString()), //Direccion ID
                  trailing: Icon(Icons.chevron_right), //Flecha ala derecha
                  onTap: () {
                    //Accuin al tocar en región
                    _bluetoothService.connectarServicio(d.device);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
