import 'package:cine_mate/screens/perfil_usuari.dart';
import 'package:cine_mate/screens/recomanacions.dart';
import 'package:cine_mate/screens/xats_actius.dart';
import 'package:flutter/material.dart';
import 'biblioteca.dart';
import 'cerca_pelicules.dart';
import 'cerca_personatges.dart';
import 'cerca_questionaris.dart';
import 'registre.dart';
import 'inici_sessio.dart';
import 'cartellera.dart';
import 'manual_us.dart';

class AppDrawer extends StatelessWidget {
  final String userRole;
  final Function(String) onRoleChange; // Para actualizar el rol desde el Drawer

  const AppDrawer({super.key, required this.userRole, required this.onRoleChange});

  @override
  Widget build(BuildContext context) {
    List<Widget> menuOptions = [];

    if (userRole == "Usuario No Registrado") {
      menuOptions.addAll([
        ListTile(
          title: const Text("Registro"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistreScreen()));
          },
        ),
        ListTile(
          title: const Text("Inicio de sesión"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
        ),
      ]);
    } else if (userRole == "Usuario Registrado") {
      menuOptions.addAll([
        ListTile(
          title: const Text("Cartelera"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CartelleraScreen()));
          },
        ),
        ListTile(
          title: const Text("Biblioteca"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const BibliotecaScreen()));
          },
        ),
        ListTile(
          title: const Text("Recomendaciones"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const RecomanacionsScreen()));
          },
        ),
        ListTile(
          title: const Text("Cuestionarios"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CercaQuestionarisScreen()));
          },
        ),
        ListTile(
          title: const Text("Chats con personajes"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const XatsActiusScreen()));
          },
        ),
        ListTile(
          title: const Text("Otros usuarios"),
          onTap: () {},
        ),
        ListTile(
          title: const Text(" "),
          onTap: () {},
        ),
        ListTile(
          title: const Text(" "),
          onTap: () {},
        ),
        ListTile(
          title: const Text("Manual de Uso"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ManualUsScreen()));
          },
        ),
        ListTile(
          title: const Text("Cerrar sesión"),
          onTap: () {
            onRoleChange("Usuario No Registrado"); // Actualiza el estado en la pantalla
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CartelleraScreen()));
          },
        ),
      ]);
    } else if (userRole == "Administrador") {
      menuOptions.addAll([
        ListTile(
          title: const Text("Gestionar películas y series"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CercaPelicules()));
          },
        ),
        ListTile(
          title: const Text("Gestionar Cuestionarios"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CercaQuestionarisScreen()));
          },
        ),
        ListTile(
          title: const Text("Gestionar Personajes de Chats"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CercaPersonatgesScreen()));
          },
        ),
        ListTile(
          title: const Text(" "),
          onTap: () {},
        ),
        ListTile(
          title: const Text(" "),
          onTap: () {},
        ),
        ListTile(
          title: const Text(" "),
          onTap: () {},
        ),
        ListTile(
          title: const Text(" "),
          onTap: () {},
        ),
        ListTile(
          title: const Text(" "),
          onTap: () {},
        ),
        ListTile(
          title: const Text(" "),
          onTap: () {},
        ),
        ListTile(
          title: const Text("Cerrar sesión"),
          onTap: () {
            onRoleChange("Usuario No Registrado");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CartelleraScreen()));
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
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.person, size: 50, color: Colors.white),
                    onPressed: () {
                      if (userRole == "Usuario Registrado" || userRole == "Administrador") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PerfilUsuari()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Debes estar registrado para acceder al perfil.')),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text("PERFIL",  style: TextStyle(color: Colors.white, fontSize: 18))
              ],
            ),
          ),
          ...menuOptions,
        ],
      ),
    );
  }
}
