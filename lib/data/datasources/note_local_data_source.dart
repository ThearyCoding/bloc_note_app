import 'package:sqflite/sqflite.dart';

import '../../core/db/database_helper.dart';
import '../../domain/entities/note.dart';

abstract class NoteLocalDataSource {
  Future<List<Note>> getAllNotes();
  Future<void> addNote(Note note);
  Future<void> deleteNoteById(int id);
  Future<void> updatedNote(Note note);
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Future<List<Note>> getAllNotes() async {
    final db = await dbHelper.database;
    final notesMap = await db.query('notes');
    return notesMap.map((note) => Note.fromMap(note)).toList();
  }

  @override
  Future<void> addNote(Note note) async {
    final db = await dbHelper.database;
    await db.insert('notes', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> deleteNoteById(int id) async {
    final db = await dbHelper.database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> updatedNote(Note note) async {
    final db = await dbHelper.database;
    await db
        .update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }
}
