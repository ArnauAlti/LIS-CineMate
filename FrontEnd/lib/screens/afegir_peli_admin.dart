import 'package:cine_mate/screens/cerca_personatges.dart';
import 'package:flutter/material.dart';

class AfegirPeliScreen extends StatelessWidget {
  const AfegirPeliScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Añadir película o serie"),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal:  24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Título película o serie"),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  filled:  true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Reparto"),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  filled:  true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Año de estreno"),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  filled:  true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Duración"),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  filled:  true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Plataformas donde se encuentra"),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  filled:  true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Sinópsis/Resumen"),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  filled:  true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("URL de la foto"),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  filled:  true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Edad mínima para su visualización"),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  filled:  true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              //TODO: Canviar a llista amb opcions
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Género"),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  filled:  true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              //TODO: Canviar a menú amb dos opcions, si és sèrie mostrar els dos últims camps
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Serie o película"),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  filled:  true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Temporada"),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  filled:  true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Número de capítulos"),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  filled:  true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const Spacer(),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    //TODO: Enviar noves dades al BackEnd per afegir personatge a la BD
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CercaPersonatgesScreen()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Personaje añadido correctamente.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  ),
                  child: const Text("Añadir"),
                ),
              ),
              const SizedBox(height: 16),
            ],
          )
      ),
    );
  }
}
