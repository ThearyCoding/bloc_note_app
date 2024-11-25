part of 'note_bloc.dart';


abstract class NoteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateNote extends NoteEvent {
  final Note note;

  UpdateNote(this.note);

  @override
  List<Object?> get props => [note];
}
class LoadNotes extends NoteEvent {}

class AddNewNote extends NoteEvent {
  final Note note;

  AddNewNote(this.note);

  @override
  List<Object?> get props => [note];
}

class DeleteNote extends NoteEvent {
  final int id;

  DeleteNote(this.id);

  @override
  List<Object?> get props => [id];
}
