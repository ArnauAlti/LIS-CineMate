import 'package:cine_mate/screens/editar_pelicula.dart';
import 'package:flutter/material.dart';
import '../user_role_provider.dart';
import 'package:provider/provider.dart';

class DetallsPeliSerieScreen extends StatelessWidget {
  final String title;

  const DetallsPeliSerieScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final userRole = userRoleProvider.userRole;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Detalles"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //TODO: Fer plantilla per posar cada pel·lícula de la BD
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  //TODO: Agafar imatge a partir de la BD
                  child: Image.network(
                    'https://th.bing.com/th/id/OIP.TDVZL0VokIrAyO-t9RFLJQAAAA?rs=1&pid=ImgDetMain',
                    width: 130,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                //TODO:Agafar dades a partir de la BD
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📅 Año de estreno: 2025", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text("⏱ Duración: 119 minutos", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text("📺 Plataformas: Disney+", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text("🎭 Reparto: Anthony Mackie, Harrison Ford...", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "⭐ Valoración",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return const Icon(Icons.star_border, size: 30, color: Colors.black);
              }),
            ),
            const SizedBox(height: 30),
            const Text(
              "Sinópsis",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              "Tras reunirse con el recién elegido presidente de EE.UU. Thaddeus Ross (Harrison Ford), Sam se encuentra en medio de un incidente internacional...",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),

            //Si l'usuari està registrat, es mostra un botó per afegir la pel·lícula a la biblioteca
            userRole == "Usuario Registrado"
                ? Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  //TODO: Afegir a la biblioteca de l'usuari, crear instància a la BD i canviar text botó
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Película añadida a la biblioteca.')),
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
                icon: const Icon(Icons.add),
                label: const Text(
                  "AÑADIR A BIBLIOTECA",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ): userRole == "Administrador"
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    //TODO: Passar info en forma de document per a no haver d'accedir altre cop a la BD
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EditarPeliCartelleraScreen(
                      mode:"Modify",
                      peliData: {
                      "titol": "Matrix",
                      "repart": "Keanu Reeves, Carrie-Anne Moss",
                      "descripcio": "Película de ciencia ficción",
                      "anyEstreno": "1999",
                      "duracio": "136",
                      "plataformes": "HBO Max",
                      "urlFoto": "https://...",
                      "edatMinima": "16",
                      "tipus": "Película",
                      "genere": "Ciencia Ficción",
                    },)));
                  },
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll<Color>(Colors.black),
                    foregroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                  child: const Text("EDITAR INFORMACIÓN"),
                ),
                ElevatedButton(
                  onPressed: () {
                    //TODO: Eliminar película de la cartellera i de la BD
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Obra eliminada de la cartelera.')),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll<Color>(Colors.red),
                    foregroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                  child: const Text("ELIMINAR"),
                ),
              ],
            )
                : const SizedBox.shrink(), // Si no es usuario registrado, no muestra nada
          ],
        ),
      ),
    );
  }
}
