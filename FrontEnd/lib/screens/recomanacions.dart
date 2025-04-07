import 'package:cine_mate/screens/generar_recomanacions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_role_provider.dart';
import 'app_drawer.dart';

class RecomanacionsScreen extends StatefulWidget {
  const RecomanacionsScreen({super.key});

  @override
  _RecomanacionsScreenState createState() => _RecomanacionsScreenState();
}

class _RecomanacionsScreenState extends State<RecomanacionsScreen> {
  String? _selectedGenre;  // Variable para almacenar la opción seleccionada

  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final userRole = userRoleProvider.userRole;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Recomendaciones"),
      ),
      drawer: AppDrawer(
        userRole: userRole,
        onRoleChange: (String newRole) {
          userRoleProvider.setUserRole(newRole);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Generar recomendaciones a partir de:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Generar recomendaciones a partir del usuario mismo
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecomanacionsGeneradesScreen(selectedGenre: _selectedGenre),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Gustos personales"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Generar recomendaciones a partir de otros usuarios
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RecomanacionsGeneradesScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Usuarios que sigo"),
            ),
            const SizedBox(height: 50),
            const Text(
              "Dar más peso al siguiente género:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              alignment: Alignment.center,
              value: _selectedGenre, // Asignamos el valor seleccionado
              items: const [
                DropdownMenuItem<String>(
                  value: 'Terror',
                  child: Text('Terror'),
                ),
                DropdownMenuItem<String>(
                  value: 'Comedia',
                  child: Text('Comedia'),
                ),
                DropdownMenuItem<String>(
                  value: 'Drama',
                  child: Text('Drama'),
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGenre = newValue; // Actualizamos el valor seleccionado
                });
              },
              hint: const Text('Selecciona un género'),
              isExpanded: true,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              iconEnabledColor: Colors.black,
              underline: const SizedBox(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
