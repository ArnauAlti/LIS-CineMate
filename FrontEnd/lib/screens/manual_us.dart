import 'package:flutter/material.dart';
import 'app_drawer.dart';

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
      drawer: AppDrawer(
        userRole: _userRole,
        onRoleChange: (String newRole) {
          setState(() {
            _userRole = newRole;
          });
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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