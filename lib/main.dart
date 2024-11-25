import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'package:bloc_note_app/presentation/pages/note_page.dart';
import 'package:flutter/material.dart';
import 'presentation/bloc/note_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<NoteBloc>()..add(LoadNotes()),
        ),
      ],
      child: const MaterialApp(
        home: NotesPage(),
      ),
    );
  }
}
