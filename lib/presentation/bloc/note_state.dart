part of 'note_bloc.dart'; 

abstract class NoteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoteUpdated extends NoteState {
  final Note note;

  NoteUpdated(this.note);

  @override
  List<Object?> get props => [note];
}

class NotesEmpty extends NoteState {}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NotesLoaded extends NoteState {
  final List<Note> notes;

  NotesLoaded(this.notes);

  @override
  List<Object?> get props => [notes];
}


class NoteError extends NoteState {
  final String message;

  NoteError(this.message);

  @override
  List<Object?> get props => [message];
}