import 'package:flutter/material.dart';
import 'registre.dart';
import 'inici_sessio.dart';

class CartelleraScreen extends StatefulWidget {
  const CartelleraScreen({super.key});

  @override
  State<CartelleraScreen> createState() => _CartelleraScreenState();
}

class _CartelleraScreenState extends State<CartelleraScreen> {
  String _userRole = 'Usuario No Registrado';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Cartellera", textAlign: TextAlign.center),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                _userRole = value;
              });
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'Usuario No Registrado', child: Text('Usuario No Registrado')),
              const PopupMenuItem(value: 'Usuario Registrado', child: Text('Usuario Registrado')),
              const PopupMenuItem(value: 'Administrador', child: Text('Administrador')),
            ],
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      drawer: _buildDrawer(),
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Menú dinàmic amb diferents camps segons l'usuari actual
  Widget _buildDrawer() {
    List<Widget> menuOptions = [];

    if (_userRole == "Usuario No Registrado") {
      menuOptions.addAll([
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
      ]);
    } else if (_userRole == "Usuario Registrado") {
      menuOptions.addAll([
        ListTile(
        title: const Text("Cartelera"),
        onTap: () {
        },
        ),
        ListTile(
          title: const Text("Biblioteca"),
          onTap: () {
            // TODO: Navegar a la pantalla de Biblioteca
          },
        ),
        ListTile(
          title: const Text("Recomendaciones"),
          onTap: () {
            // TODO: Navegar a la pantalla de Recomanacions
          },
        ),
        ListTile(
          title: const Text("Cuestionarios"),
          onTap: () {
            // TODO: Navegar a la pantalla de Qüestionaris
          },
        ),
        ListTile(
          title: const Text("Chats con personajes"),
          onTap: () {
            // TODO: Navegar a la pantalla de Xats
          },
        ),
        ListTile(
          title: const Text("Otros usuarios"),
          onTap: () {
            // TODO: Navegar a la pantalla d'altres usuaris
          },
        ),
        ListTile(
          title: const Text(" "),
          onTap: () {
          },
        ),
        ListTile(
          title: const Text(" "),
          onTap: () {
          },
        ),
        ListTile(
          title: const Text("Manual de Uso"),
          onTap: () {
            // TODO: Navegar a la pantalla de Manual d'Ús
          },
        ),
        ListTile(
          title: const Text("Cerrar sesión"),
          onTap: () {
            setState(() {
              _userRole = "Usuario No Registrado";
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartelleraScreen()),
            );
          },
        ),
      ]);
    } else if (_userRole == "Administrador") {
      menuOptions.addAll([
        ListTile(
          title: const Text("Gestionar películas y series"),
          onTap: () {
            // TODO: Navegar a la pantalla de Biblioteca
          },
        ),
        ListTile(
          title: const Text("Gestionar Cuestionarios"),
          onTap: () {
            // TODO: Navegar a la pantalla de Recomanacions
          },
        ),
        ListTile(
          title: const Text("Gestionar Personajes de Chats"),
          onTap: () {
            // TODO: Navegar a la pantalla de Qüestionaris
          },
        ),
        ListTile(
          title: const Text("Gestionar Cuestionarios"),
          onTap: () {
            // TODO: Navegar a la pantalla de Xats
          },
        ),
        ListTile(
          title: const Text(" "),
          onTap: () {
            // TODO: Navegar a la pantalla d'altres usuaris
          },
        ),
        ListTile(
          title: const Text(" "),
          onTap: () {
          },
        ),
        ListTile(
          title: const Text(" "),
          onTap: () {
          },
        ),
        ListTile(
          title: const Text(" "),
          onTap: () {
          },
        ),
        ListTile(
          title: const Text(" "),
          onTap: () {
          },
        ),
        ListTile(
          title: const Text("Cerrar sesión"),
          onTap: () {
            setState(() {
              _userRole = "Usuario No Registrado";
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartelleraScreen()),
            );
          },
        ),
      ]);
    }

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.black),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.movie, size: 50, color: Colors.white),
                const SizedBox(height: 10),
              ],
            ),
          ),
          ...menuOptions,
        ],
      ),
    );
  }

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
