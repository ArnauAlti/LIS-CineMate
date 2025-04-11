import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_role_provider.dart';
import 'cerca_pelicules.dart';
import 'detalls_biblioteca.dart';
import 'app_drawer.dart';

class BibliotecaScreen extends StatefulWidget {
  const BibliotecaScreen({super.key});

  @override
  State<BibliotecaScreen> createState() => _BibliotecaScreenState();
}

class _BibliotecaScreenState extends State<BibliotecaScreen> {
  bool isPeliculasSelected = true;

  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final userRole = userRoleProvider.userRole;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Biblioteca"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CercaPelicules()),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(
        userRole: userRole,
        onRoleChange: (String newRole) {
          userRoleProvider.setUserRole(newRole);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSectionButton("Películas", isPeliculasSelected, () {
                  setState(() {
                    isPeliculasSelected = true;
                  });
                }),
                const SizedBox(width: 20),
                _buildSectionButton("Series", !isPeliculasSelected, () {
                  setState(() {
                    isPeliculasSelected = false;
                  });
                }),
              ],
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMovieBox(context, isPeliculasSelected ? "Película 1" : "Serie 1"),
                    _buildMovieBox(context, isPeliculasSelected ? "Película 2" : "Serie 2"),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMovieBox(context, isPeliculasSelected ? "Película 3" : "Serie 3"),
                    _buildMovieBox(context, isPeliculasSelected ? "Película 4" : "Serie 4"),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMovieBox(context, isPeliculasSelected ? "Película 3" : "Serie 3"),
                    _buildMovieBox(context, isPeliculasSelected ? "Película 4" : "Serie 4"),
                  ],
                ),
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget _buildSectionButton(String title, bool isSelected, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.black : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(title),
    );
  }

  Widget _buildMovieBox(BuildContext context, String title) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetallsBibliotecaScreen(title: title),
          ),
        );

      },
      child: Container(
        width: 135,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
