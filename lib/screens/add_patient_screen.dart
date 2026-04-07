import 'package:flutter/material.dart';

class AddPatientScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Paciente')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: 'Nombre')),
            TextField(decoration: InputDecoration(labelText: 'Edad')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text('Guardar')),
          ],
        ),
      ),
    );
  }
}
