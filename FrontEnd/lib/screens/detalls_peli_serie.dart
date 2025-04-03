import 'package:flutter/material.dart';

class DetallsPeliSerieScreen extends StatelessWidget {
  final String title;

  const DetallsPeliSerieScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Details"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TODO: Posar imatge de la pel·lícula o sèrie
                // Informació de la película
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //TODO: Posar informació a partir de la BD
                    children: const [
                      Text("Any: 2025"),
                      Text("Duració: 119 minuts"),
                      Text("Plataformes: Disney+"),
                      Text("Repart: Anthony Mackie, Harrison Ford, Danny..."),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'https://th.bing.com/th/id/OIP.TDVZL0VokIrAyO-t9RFLJQAAAA?rs=1&pid=ImgDetMain',
                    width: 120,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // TODO: Calcular nota mitjana gràcies a la BD
            const Text("Nota mitjana"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: const Icon(Icons.star_border),
                  onPressed: () {},
                );
              }),
            ),
            const SizedBox(height: 16),
            // Sinopsis
            const Text(
              "Tras reunirse con el recién elegido presidente de EE.UU. Thaddeus Ross (Harrison Ford), Sam se encuentra en medio de un incidente internacional...",
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            // TODO: Botó per afegir a la biblioteca
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("AFEGIR A BIBLIOTECA"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
