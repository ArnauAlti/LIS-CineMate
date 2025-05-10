import 'generar_recomanacions.dart';
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
  final Map<String, bool> _genres = {
    'Action': false, 'Aventura': false, 'Animación': false, 'Infantil': false, 'Comedia': false, 'Crimen': false,
    'Documental': false, 'Drama': false, 'Fantasía': false, 'Terror': false, 'IMAX': false, 'Musical': false, 'Misterio': false,
    'Cine negro': false, 'Romance': false, 'Ciencia ficción': false, 'Suspense': false, 'Bélico': false, 'Western': false,
  };

  List<String> _getSelectedGenres() {
    return _genres.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecomanacionsGeneradesScreen(
                      selectedGenres: _getSelectedGenres(),
                    ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecomanacionsGeneradesScreen(
                      selectedGenres: _getSelectedGenres(),
                    ),
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
              child: const Text("Usuarios que sigo"),
            ),
            const SizedBox(height: 50),
            const Text(
              "Dar más peso a los siguientes géneros:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: _genres.keys.map((genre) {
                return CheckboxListTile(
                  title: Text(genre),
                  value: _genres[genre],
                  onChanged: (bool? value) {
                    setState(() {
                      _genres[genre] = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}