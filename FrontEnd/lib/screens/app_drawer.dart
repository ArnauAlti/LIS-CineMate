import 'package:cine_mate/screens/perfil_usuari.dart';
import 'package:cine_mate/screens/recomanacions.dart';
import 'package:cine_mate/screens/usuaris_seguits.dart';
import 'package:cine_mate/screens/xats_actius.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_role_provider.dart';
import 'biblioteca.dart';
import 'cerca_personatges.dart';
import 'cerca_questionaris.dart';
import 'registre.dart';
import 'inici_sessio.dart';
import 'cartellera.dart';
import 'manual_us.dart';

class AppDrawer extends StatelessWidget {
  final String userRole;
  final Function(String) onRoleChange; // Per actualitzar el rol des del Drawer (menú desplegable)

  const AppDrawer({super.key, required this.userRole, required this.onRoleChange});

  //Construir un menú desplegable segons el rol de l'usuari, amb diferents seccions segons si l'usuari
  //està no està registrat, està registrat o és un administrador
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRoleProvider>(context, listen: false).getUser;

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
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const UsuarisSeguits()));
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Se ha cerrado sesión correctamente.')),
            );
          },
        ),
      ]);
    } else if (userRole == "Administrador") {
      menuOptions.addAll([
        ListTile(
          title: const Text("Gestionar Películas y Series"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CartelleraScreen()));
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Se ha cerrado sesión correctamente.')),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
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
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage(user?['profileImage'] ?? 'assets/perfil1.jpg'),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  user?['nick'] ?? 'Usuario', // Mostrar nombre de usuario si está disponible
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  "Ver perfil",
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                ),
              ],
            ),
          ),
          ...menuOptions,
        ],
      ),
    );
  }
}
