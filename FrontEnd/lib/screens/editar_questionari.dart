import 'package:flutter/material.dart';
import '../requests.dart';


//TODO: Fer request per editar les coses del questionari
class QuestionariAdminScreen extends StatefulWidget {
  final String mediaId;
  final String title;

  const QuestionariAdminScreen({super.key, required this.mediaId, required this.title});

  @override
  State<QuestionariAdminScreen> createState() => _QuestionariAdminScreenState();
}

class _QuestionariAdminScreenState extends State<QuestionariAdminScreen> {
  late Future<List<Map<String, dynamic>>> _questionsFuture;
  List<Map<String, dynamic>> editableQuestions = [];

  @override
  void initState() {
    super.initState();
    _questionsFuture = getQuestions(widget.mediaId);
    _questionsFuture.then((questions) {
      setState(() {
        editableQuestions = questions.map((q) {
          return {
            'controller': TextEditingController(text: q['question']),
            'answers': (q['possibleAnswers'] as List?)?.cast<String>().map((a) => TextEditingController(text: a)).toList() ?? [],
          };
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (editableQuestions.isEmpty) {
            return const Center(child: Text('No questions found.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: editableQuestions.length,
              itemBuilder: (context, i) => _buildEditableQuestion(i),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: ElevatedButton(
          onPressed: () async {
            //TODO: Modificar que es passa a la request, canviar accions de després
            await editQuestionnaire(widget.title);
            final updatedQuestions = editableQuestions.map((q) {
              return {
                'question': q['controller'].text,
                'possibleAnswers': (q['answers'] as List<TextEditingController>).map((c) => c.text).toList(),
              };
            }).toList();

            // Aquí puedes hacer el request para actualizar las preguntas
            // updateQuestions(widget.title, updatedQuestions);
            print(updatedQuestions);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
          child: const Text("Save changes"),
        ),
      ),
    );
  }

  Widget _buildEditableQuestion(int index) {
    final questionData = editableQuestions[index];
    final TextEditingController questionController = questionData['controller'];
    final List<TextEditingController> answerControllers = questionData['answers'];

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Question ${index + 1}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: "Delete question",
                  onPressed: () {
                    setState(() {
                      editableQuestions.removeAt(index);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: questionController,
              decoration: const InputDecoration(labelText: "The question is..."),
            ),
            const SizedBox(height: 10),
            const Text("Answers:", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            ...answerControllers.asMap().entries.map((entry) {
              final i = entry.key;
              final controller = entry.value;
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(labelText: "Answer ${i + 1}"),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        answerControllers.removeAt(i);
                      });
                    },
                  ),
                ],
              );
            }),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  answerControllers.add(TextEditingController());
                });
              },
              icon: const Icon(Icons.add),
              label: const Text("Add answers"),
            ),
          ],
        ),
      ),
    );
  }
}