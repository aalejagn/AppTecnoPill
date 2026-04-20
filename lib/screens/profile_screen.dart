import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String nombre = "Rodrigo";
  String rol = "Cuidador";
  String correo = "rodrigo@email.com";

  void _editarPerfil() {
    final nombreController = TextEditingController(text: nombre);
    final rolController = TextEditingController(text: rol);
    final correoController = TextEditingController(text: correo);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Editar perfil",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: "Nombre"),
              ),

              TextField(
                controller: rolController,
                decoration: const InputDecoration(labelText: "Rol"),
              ),

              TextField(
                controller: correoController,
                decoration: const InputDecoration(labelText: "Correo"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B61FF),
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: () {
                  setState(() {
                    nombre = nombreController.text;
                    rol = rolController.text;
                    correo = correoController.text;
                  });

                  Navigator.pop(context);
                },
                child: const Text(
                  "Guardar cambios",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),

      appBar: AppBar(
        title: const Text(
          "Perfil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF7B61FF),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 👤 CARD USUARIO
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [

                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF7B61FF),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nombre,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rol,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          correo,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ✏️ BOTÓN EDITAR
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _editarPerfil,
                icon: const Icon(Icons.edit),
                label: const Text("Editar perfil"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B61FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}