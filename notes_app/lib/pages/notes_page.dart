import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_app/components/custom_drawer/custom_drawer.dart';
import 'package:notes_app/components/custom_grid_note/custom_grid_note.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/models/note_database.dart';
import 'package:notes_app/theme/theme_provider.dart';
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
    textController.text = '';
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Enter title'),
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
                ]),
        barrierColor: Colors.black.withOpacity(0.5));
  }

  void updateTitleOfNote(Note note) {
    textController.text = note.title;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Update title'),
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
            ),
        barrierColor: Colors.black.withOpacity(0.5));
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
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          systemOverlayStyle:
              Provider.of<ThemeProvider>(context, listen: false).isDarkMode
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,
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
                child: GridView.builder(
              padding: const EdgeInsets.all(25),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 25.0,
                childAspectRatio: 0.7,
              ),
              itemCount: currentNotes.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomGridItem(
                    note: currentNotes[index], onEditTitleTap: updateTitleOfNote,
                    onNoteSettingsTap: updateTitleOfNote,
                    onDeleteTap: deleteNode,);
              },
            )),
          ],
        ));
  }
}
