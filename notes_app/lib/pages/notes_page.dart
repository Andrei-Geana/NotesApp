import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_app/components/custom_drawer/custom_drawer.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/models/note_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<StatefulWidget> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    readNotes();
  }

  void createNote() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                content: TextField(
                  controller: textController,
                ),
                actions: [
                  MaterialButton(
                      onPressed: () {
                        String noteText = textController.text.trim();
                         if (noteText.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Title cannot be empty.'),
                              ),
                          );
                          return;
                        }
                        context
                            .read<NoteDatabase>()
                            .addNote(textController.text);
                        Navigator.pop(context);
                        textController.clear();
                      },
                      child: const Text('Create'))
                ]));
  }

  void updateNote(Note note) {
    textController.text = note.title;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Update text'),
              content: TextField(controller: textController),
              actions: [
                MaterialButton(
                    onPressed: () {
                      String noteText = textController.text.trim();
                         if (noteText.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Title cannot be empty.'),
                              ),
                          );
                          return;
                        }

                      context
                          .read<NoteDatabase>()
                          .updateNote(note.id, textController.text);
                      Navigator.pop(context);
                    },
                    child: const Text('Update'))
              ],
            )).then((_) {
      textController.clear();
    });
  }

  void deleteNode(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
        appBar: AppBar( 
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        floatingActionButton: FloatingActionButton(
            onPressed: createNote,
            child:
                Icon(Icons.add, color: Theme.of(context).colorScheme.tertiary)),
        drawer: const CustomDrawer(),
        body: Column(
          children: [
            //HEADING
            Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text('Notes',
                    style: TextStyle(
                        fontSize: 40,
                        color: Theme.of(context).colorScheme.inversePrimary))),

            //LIST OF NOTES
            Expanded(
              child: ListView.builder(
                itemCount: currentNotes.length,
                itemBuilder: (context, index) {
                  final note = currentNotes[index];
                  return ListTile(
                      title: Text(note.title),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () => updateNote(note),
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () => deleteNode(note.id),
                              icon: const Icon(Icons.delete))
                        ],
                      ));
                },
              ),
            ),
          ],
        ));
  }
}
