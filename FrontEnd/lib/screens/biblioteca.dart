import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_role_provider.dart';
import 'cerca_pelicules.dart';
import 'detalls_biblioteca.dart';
import 'app_drawer.dart';
import '../requests.dart';

class BibliotecaScreen extends StatefulWidget {
  const BibliotecaScreen({super.key});

  @override
  State<BibliotecaScreen> createState() => _BibliotecaScreenState();
}

class _BibliotecaScreenState extends State<BibliotecaScreen> {
  bool isPeliculasSelected = true;
  late Future<List<Map<String, dynamic>>> _filmsFuture;


  @override
  void initState() {
    final userEmail = Provider.of<UserRoleProvider>(context, listen: false).userEmail;
    super.initState();
    _filmsFuture = getLibraryFilms(userEmail!, true);
  }
  //TODO: Eliminar pelis/series entre cambios de sección
  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final userRole = userRoleProvider.userRole;
    final userEmail = Provider.of<UserRoleProvider>(context, listen: false).userEmail;

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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _filmsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final films = snapshot.data ?? [];

          return SingleChildScrollView(
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
                        _filmsFuture = getLibraryFilms(userEmail!, true);
                      });
                    }),
                    const SizedBox(width: 20),
                    _buildSectionButton("Series", !isPeliculasSelected, () {
                      setState(() {
                        isPeliculasSelected = false;
                        _filmsFuture = getLibraryFilms(userEmail!, false);
                      });
                    }),
                  ],
                ),
                const SizedBox(height: 30),

                for (int i = 0; i < films.length; i += 2)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildMovieBox(context, films[i]),
                          if (i + 1 < films.length)
                            _buildMovieBox(context, films[i + 1]),
                        ],
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
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

  Widget _buildMovieBox(BuildContext context, Map<String, dynamic> film) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetallsBibliotecaScreen(film: film),
          ),
        );
      },
      child: Container(
        width: 135,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(8),
          image: film['media_png'] != null
              ? DecorationImage(
            image: NetworkImage(film['media_png']),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          )
              : null,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              film['media_name'] ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
