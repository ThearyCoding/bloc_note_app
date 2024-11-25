

import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_local_data_source.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource localDataSource;

  NoteRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Note>> getNotes() {
    return localDataSource.getAllNotes();
  }

  @override
  Future<void> addNote(Note note) {
    return localDataSource.addNote(note);
  }

  @override
  Future<void> deleteNoteByID(int id) {
    return localDataSource.deleteNoteById(id);
  }
  
  @override
  Future<void> updateNote(Note note) {
    return localDataSource.updatedNote(note);
  }
  
  
}