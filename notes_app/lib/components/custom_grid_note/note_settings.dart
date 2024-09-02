import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';

class NoteSettings extends StatelessWidget {
  final Note note;
  final void Function(Note) onEditTitleTap;
  final void Function(int) onDeleteTap;

  const NoteSettings(
      {super.key,
      required this.onEditTitleTap,
      required this.onDeleteTap,
      required this.note});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            onEditTitleTap(note);
          },
          child: SizedBox(
              height: 45,
              child: Center(
                  child: Text('Edit title',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface)))),
        ),
        GestureDetector(
          onTap: () {
            onDeleteTap(note.id);
            Navigator.pop(context);
          },
          child: SizedBox(
              height: 25,
              child: Center(
                  child: Text('Delete',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface)))),
        )
      ],
    );
  }
}
