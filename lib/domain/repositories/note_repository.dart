import 'package:bloc_note_app/domain/entities/note.dart';

abstract class NoteRepository{
  Future<void> addNote(Note note);
  Future<List<Note>> getNotes();
  Future<void> deleteNoteByID(int id);
   Future<void> updateNote(Note note); 
}