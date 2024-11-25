import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/note.dart';
import '../bloc/note_bloc.dart';
import 'package:intl/intl.dart';
import 'note_input_page.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NotesEmpty) {
            return const Center(child: Text('No notes available'));
          } else if (state is NotesLoaded) {
            final groupedNotes = _groupNotesByDate(state.notes);

            return ListView.builder(
              itemCount: groupedNotes.keys.length,
              itemBuilder: (context, groupIndex) {
                final dateGroup = groupedNotes.keys.elementAt(groupIndex);
                final notesForGroup = groupedNotes[dateGroup]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        dateGroup,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notesForGroup.length,
                      itemBuilder: (context, noteIndex) {
                        final note = notesForGroup[noteIndex];

                        return Card(
                          child: ListTile(
                            onLongPress: () {
                              showDeleteNoteDialog(context, note);
                            },
                            onTap: () async {
                              final updatedNote = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NoteInputPage(note: note),
                                ),
                              );
                              if (updatedNote != null) {
                                // ignore: use_build_context_synchronously
                                BlocProvider.of<NoteBloc>(context)
                                    .add(UpdateNote(updatedNote));
                              }
                            },
                            title: Text(
                              note.content,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          } else if (state is NoteError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteInputPage()),
          );
          if (newNote != null) {
            // ignore: use_build_context_synchronously
            BlocProvider.of<NoteBloc>(context).add(AddNewNote(newNote));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showDeleteNoteDialog(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          backgroundColor:
                              const Color.fromARGB(255, 255, 0, 0)),
                      onPressed: () {
                        BlocProvider.of<NoteBloc>(context)
                            .add(DeleteNote(note.id ?? 0));
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 253, 253)),
                      ),
                    ),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Map<String, List<Note>> _groupNotesByDate(List<Note> notes) {
    Map<String, List<Note>> groupedNotes = {};

    for (var note in notes) {
      final formattedDate = DateFormat('MMMM yyyy').format(note.createdAt);
      if (!groupedNotes.containsKey(formattedDate)) {
        groupedNotes[formattedDate] = [];
      }
      groupedNotes[formattedDate]!.add(note);
    }

    return groupedNotes;
  }
}
