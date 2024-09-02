import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/models/note_database.dart';
import 'package:notes_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class IndividualNotePage extends StatefulWidget {
  final Note note;

  const IndividualNotePage({super.key, required this.note});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _IndividualNotePageState(note: note);
}

class _IndividualNotePageState extends State<IndividualNotePage> {
  late final Note note;
  final textController = TextEditingController();
  final titleNoteController = TextEditingController();
  final titleFocusNode = FocusNode();
  final textFocusNode = FocusNode();

  _IndividualNotePageState({required this.note});

  @override
  void initState() {
    super.initState();
    textController.text = note.data;
    titleNoteController.text = note.title;
  }

  @override
  void dispose() {
    titleFocusNode.dispose();
    textFocusNode.dispose();
    textController.dispose();
    titleNoteController.dispose();
    super.dispose();
  }

  void _handleEditingComplete() {
    if (titleNoteController.text.isNotEmpty) {
      saveModifiedNote();
    } else {
      titleNoteController.text = note.title;
    }
    titleFocusNode.unfocus();
    textFocusNode.unfocus();
  }

  void saveModifiedNote() {
    note.title = titleNoteController.text;
    note.data = textController.text;
    context.read<NoteDatabase>().updateNote(note);
  }

  Future<bool> _onWillPop() async {
    if (titleNoteController.text.isEmpty) {
      return true;
    }
    saveModifiedNote();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: TextField(
            controller: titleNoteController,
            focusNode: titleFocusNode,
            style: const TextStyle(fontSize: 20),
            cursorColor: Colors.white,
            decoration: const InputDecoration(border: InputBorder.none),
            onEditingComplete: _handleEditingComplete,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          systemOverlayStyle:
              Provider.of<ThemeProvider>(context, listen: false).isDarkMode
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: TextField(
                  controller: textController,
                  focusNode: textFocusNode,
                  style: const TextStyle(),
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  onEditingComplete: _handleEditingComplete,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
