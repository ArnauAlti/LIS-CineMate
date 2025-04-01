import 'package:flutter/material.dart';
import 'registre.dart';
import 'inici_sessio.dart';

class CartelleraScreen extends StatelessWidget {
  const CartelleraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Cartellera", textAlign: TextAlign.center),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Acció al polsar la lupa
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: kToolbarHeight, // Mateixa alçada que la AppBar
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Menú",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop(); // Creu que tanca el Drawer (Menu desplegable)
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text("Registro"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistreScreen()),
                );
                },
            ),
            ListTile(
              title: const Text("Inicio de sesión"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMovieBox("Pelicula 1"),
                _buildMovieBox("Pelicula 2"),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMovieBox("Pelicula 3"),
                _buildMovieBox("Pelicula 4"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //Funció per crear les caixes per cada portada de sèrie i pel·lícula
  Widget _buildMovieBox(String title) {
    return Container(
      width: 135,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title),
        ),
      ),
    );
  }
}
