import 'package:bloc_note_app/domain/repositories/note_repository.dart';

import '../entities/note.dart';
class UpdateNoteUseCase {
  final NoteRepository repository;

  UpdateNoteUseCase(this.repository);

  Future<void> call(Note note) {
    return repository.updateNote(note);
  }
}