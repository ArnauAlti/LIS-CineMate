import 'package:cine_mate/screens/cerca_pelicules.dart';
import 'package:cine_mate/screens/detalls_peli_serie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_role_provider.dart';
import 'app_drawer.dart';
import '../requests.dart';

class CartelleraScreen extends StatefulWidget {
  const CartelleraScreen({super.key});

  @override
  State<CartelleraScreen> createState() => _CartelleraScreenState();
}

class _CartelleraScreenState extends State<CartelleraScreen> {
  late Future<List<Map<String, dynamic>>> _filmsFuture;

  @override
  void initState() {
    super.initState();
    _filmsFuture = getLatestFilms();
  }

  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final userRole = userRoleProvider.userRole;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Billboard", textAlign: TextAlign.center),
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  const Text("New in our app!!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
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
            ),
          );
        },
      ),
    );
  }


  // Funció per construir una caixa de pel·lícula o sèrie, es passa a la següent pantalla tota la informació necessària
  //de la pel·lícula o sèrie per mostrar a pantalla
  Widget _buildMovieBox(BuildContext context, Map<String, dynamic> film) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetallsPeliSerieScreen(mediaId: film['id'])),
        );
      },
      child: Container(
        width: 135,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          image: film['png'] != null
              ? DecorationImage(
            image: NetworkImage(film['png']),
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
              film['name'] ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
