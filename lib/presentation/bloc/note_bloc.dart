import 'package:bloc_note_app/domain/usecases/update_note_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/note.dart';
import '../../domain/usecases/add_note_usecase.dart';
import '../../domain/usecases/delete_note_usecase.dart';
import '../../domain/usecases/get_notes_usecase.dart';
part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final GetNotesUseCase getNotesUseCase;
  final AddNoteUseCase addNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;
  final UpdateNoteUseCase updateNoteUseCase;

  NoteBloc(
      {required this.getNotesUseCase,
      required this.addNoteUseCase,
      required this.deleteNoteUseCase,
      required this.updateNoteUseCase})
      : super(NoteInitial()) {
    on<LoadNotes>((event, emit) async {
      emit(NoteLoading());
      final notes = await getNotesUseCase.call();
      if (notes.isEmpty) {
        emit(NotesEmpty());
      } else {
        emit(NotesLoaded(notes));
      }
    });

    on<AddNewNote>((event, emit) async {
      await addNoteUseCase.call(event.note);
      add(LoadNotes());
    });

    on<DeleteNote>((event, emit) async {
      await deleteNoteUseCase.call(event.id);
      add(LoadNotes());
    });

    on(_onUpdateNote);
  }
  Future<void> _onUpdateNote(UpdateNote event, Emitter<NoteState> emit) async {
    try {
      await updateNoteUseCase(event.note);
      final notes = await getNotesUseCase();
      emit(NoteUpdated(event.note)); // Emit the updated note state
      emit(NotesLoaded(notes)); // Optionally reload all notes
    } catch (_) {
      emit(NoteError('Failed to update note'));
    }
  }
}
