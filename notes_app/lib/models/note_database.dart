import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes_app/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  //INITIALIZE
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  //LIST OF NOTES
  final List<Note> currentNotes = [];

  //CREATE
  Future<void> addNote(String titleFromUser) async {
    final newNote = Note()..title = titleFromUser;

    await isar.writeTxn(() => isar.notes.put(newNote));
    await fetchNotes();
  }

  //READ
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }

  //UPDATE
  Future<void> updateNoteTitle(int id, String newTitle) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.title = newTitle;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

  Future<void> updateNote(Note note) async {
    Note? existingNote = await isar.notes.get(note.id);
    if (existingNote != null) {
      existingNote = note;
      await isar.writeTxn(() => isar.notes.put(existingNote!));
      await fetchNotes();
    }
  }

  //DELETE
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}
