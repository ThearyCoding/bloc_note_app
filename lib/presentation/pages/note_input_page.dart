import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/note.dart';
import '../bloc/note_bloc.dart';

import 'dart:async'; // Import this for Timer

class NoteInputPage extends StatefulWidget {
  final Note? note;

  const NoteInputPage({super.key, this.note});

  @override
  NoteInputPageState createState() => NoteInputPageState();
}

class NoteInputPageState extends State<NoteInputPage> {
  final TextEditingController _controller = TextEditingController();
  bool isEditing = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      isEditing = true;
      _controller.text = widget.note!.content;
    }

    // Auto-save functionality with debouncing
    _controller.addListener(_debounceAutoSave);
  }

  @override
  void dispose() {
    _controller.removeListener(_debounceAutoSave);
    _debounce?.cancel(); // Cancel the debounce timer
    _controller.dispose();
    super.dispose();
  }

  void _debounceAutoSave() {
    // Cancel the previous timer if it's still active
    _debounce?.cancel();
    
    // Set up a new timer
    _debounce = Timer(const Duration(seconds: 1), () {
      if (_controller.text.isNotEmpty) {
        final note = isEditing
            ? widget.note!.copyWith(content: _controller.text)
            : Note(
                id: DateTime.now().millisecondsSinceEpoch,
                content: _controller.text,
                createdAt: DateTime.now(),
              );

        BlocProvider.of<NoteBloc>(context)
            .add(isEditing ? UpdateNote(note) : AddNewNote(note));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: double.infinity,
          child: TextField(
            controller: _controller,
            style: const TextStyle(color: Colors.black),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              border: InputBorder.none,
              hintText: "Start typing your note...",
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
