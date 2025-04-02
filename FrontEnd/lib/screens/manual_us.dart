import 'package:flutter/material.dart';
import 'registre.dart';
import 'inici_sessio.dart';
import 'cartellera.dart';

class ManualUsScreen extends StatefulWidget {
  const ManualUsScreen({super.key});

  @override
  State<ManualUsScreen> createState() => _ManualUsScreen();
}

class _ManualUsScreen extends State<ManualUsScreen> {
  String _userRole = 'Usuario Registrado';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Manual De Uso", textAlign: TextAlign.center),
        centerTitle: true,
      ),
      drawer: _buildDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ExpansionTile(
              title: Text("¿Como funciona la biblioteca?"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  //TODO: Posar funcionament biblioteca
                  child: Text("Funcionamiento biblioteca"),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("¿Como funcionan las recomendaciones?"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  //TODO: Posar funcionament recomanacions
                  child: Text("Funcionamiento recomendaciones"),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("¿Como funcionan los cuestionarios?"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  //TODO: Posar funcionament qüestionaris
                  child: Text("Funcionamiento cuestionarios"),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("¿Como funcionan los chats inteligentes?"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  //TODO: Posar funcionament xats
                  child: Text("Funcionamiento chats"),
                ),
              ],
            ),
            ExpansionTile(
              title: Text("¿Como funciona la parte social?"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  //TODO: Posar funcionament altres usuaris
                  child: Text("Funcionamiento otros usuarios"),
                ),
              ],
            ),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartelleraScreen()),
            );
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