import 'package:flutter/material.dart';

class AddScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Horario')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: 'Medicamento')),
            TextField(decoration: InputDecoration(labelText: 'Hora')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text('Guardar')),
          ],
        ),
      ),
    );
  }
}
