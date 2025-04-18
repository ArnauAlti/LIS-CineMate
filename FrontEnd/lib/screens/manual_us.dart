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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildExpansionTile(
              icon: Icons.library_books,
              title: "¿Cómo funciona la biblioteca?",
              content:
              "La biblioteca es la sección donde podrás guardar todas las series y películas que hayas visto o quieras ver, divididas en las dos secciones correspondientes. "
                  "Podrás valorar y comentar aquellas obras que tengas guardadas en la biblioteca, pero solo podrás verlo tú. Además, podrás guardar el momento exacto en el que te quedaste, "
                  "por si la quieres retomar. Con las series podrás indicar también el capítulo.\n\n"
                  "¿Cómo guardar una película o serie en la biblioteca?\n"
                  "→ Para ello tendrás que ir a la sección de la cartelera, entrar en la obra que quieras y hacer click en 'Añadir a biblioteca'.\n\n"
                  "¿Se pueden eliminar las series o películas de la biblioteca?\n"
                  "→ Sí, solo hace falta entrar a la película/serie en tu biblioteca, y clicar el botón de eliminar.\n\n"
                  "¿Puedo modificar el comentario o la valoración?\n"
                  "→ Sí, entra en la serie o película correspondiente, cambia la valoración, el comentario o el instante en el que te quedaste, y haz click en 'Guardar cambios'.",
            ),
            _buildExpansionTile(
              icon: Icons.recommend,
              title: "¿Cómo funcionan las recomendaciones?",
              content:
              "Las recomendaciones inteligentes te mostrarán aquellas películas o series que más se adecuen a tus gustos. "
                  "También podrás generar recomendaciones a partir de los gustos de otros usuarios a los que sigas.\n\n"
                  "¿Puedo dar más peso a algún género de película/serie?\n"
                  "→ Así es, podrás elegir a qué géneros quieres dar más relevancia a la hora de generar las recomendaciones.",
            ),
            _buildExpansionTile(
              icon: Icons.quiz,
              title: "¿Cómo funcionan los cuestionarios?",
              content:
              "Con los cuestionarios podrás poner a prueba tus conocimientos sobre la película o serie que desees. "
                  "Busca la serie o película que quieras y haz click en comenzar. Se generarán 10 preguntas aleatorias, pero aparecerán solo 5.\n\n"
                  "¿Puedo salir del cuestionario si no quiero seguir respondiendo más preguntas?\n"
                  "→ Sí, puedes abandonar el cuestionario en cualquier momento usando el botón correspondiente, o salir tras las primeras 5 preguntas.",
            ),
            _buildExpansionTile(
              icon: Icons.chat_bubble,
              title: "¿Cómo funcionan los chats inteligentes?",
              content:
              "Los chats te permitirán conversar con personajes de tu película o serie favorita. Aunque son inteligentes, no recuerdan conversaciones pasadas tras varias horas. "
                  "Generan respuestas basadas en la personalidad del personaje.\n\n"
                  "¿Cómo añado un nuevo chat?\n"
                  "→ Clica en 'Añadir nuevo chat', busca el personaje o película/serie, y se añadirá automáticamente a la lista de chats activos.\n\n"
                  "¿Qué pasa si tengo 3 chats activos y quiero empezar uno nuevo?\n"
                  "→ Deberás eliminar un chat desde la opción 'Eliminar chats' y seleccionar el que desees quitar.",
            ),
            _buildExpansionTile(
              icon: Icons.people,
              title: "¿Cómo funciona la parte social?",
              content:
              "En la sección de otros usuarios podrás ver a las personas que sigues y sus respectivas bibliotecas, incluyendo comentarios y valoraciones. "
                  "Estos usuarios también influyen en las recomendaciones personalizadas.\n\n"
                  "¿Cómo puedo seguir a otros usuarios?\n"
                  "→ Pulsa en 'Buscar usuarios', introduce su nombre, accede a su perfil y haz click en 'Seguir usuario'.\n\n"
                  "¿Y cómo dejo de seguir a alguien?\n"
                  "→ Entra a su perfil y haz click en 'Dejar de seguir'.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          leading: Icon(icon, color: Colors.black87),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                content,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
