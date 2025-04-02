import 'package:flutter/material.dart';

class CercaPersonatges extends StatefulWidget {
  const CercaPersonatges({super.key});

  @override
  State<CercaPersonatges> createState() => _CercaPersonatgesState();
}

class _CercaPersonatgesState extends State<CercaPersonatges> {
  @override
  Widget build(BuildContext context) {
    bool _mostrarFiltres = false;
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Busqueda", textAlign: TextAlign.center),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Volver a la pantalla anterior
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: "Introdueix el títol de la pel·lícula o sèrie...",
                prefixIcon: Icon(Icons.search),
                fillColor: Color(0xFFEAE6f3),
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            GestureDetector(
              onTap: (){
                setState(() {
                  _mostrarFiltres= !_mostrarFiltres;
                });
              },
              child: const Text(
                "Filtrar",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 16.0,),
            if(_mostrarFiltres)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAE6F3),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: const [
                    ListTile(title: Text("Gènere")),
                    Divider(height: 1),
                    ListTile(title: Text("Paraula")),
                    Divider(height: 1),
                    ListTile(title: Text("Actor o Actriu")),
                    Divider(height: 1),
                    ListTile(title: Text("Director/a")),
                    Divider(height: 1),
                    ListTile(title: Text("Duració")),
                  ],
                ),
              )
          ],
        )
      ),
    );
  }
}
