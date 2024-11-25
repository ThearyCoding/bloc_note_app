import 'package:bloc_note_app/domain/usecases/update_note_usecase.dart';
import 'package:get_it/get_it.dart';

import 'data/datasources/note_local_data_source.dart';
import 'data/repositories/note_repository_impl.dart';
import 'domain/repositories/note_repository.dart';
import 'domain/usecases/add_note_usecase.dart';
import 'domain/usecases/delete_note_usecase.dart';
import 'domain/usecases/get_notes_usecase.dart';
import 'presentation/bloc/note_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => NoteBloc(
        getNotesUseCase: sl(),
        addNoteUseCase: sl(),
        deleteNoteUseCase: sl(),
        updateNoteUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetNotesUseCase(sl()));
  sl.registerLazySingleton(() => AddNoteUseCase(sl()));
  sl.registerLazySingleton(() => DeleteNoteUseCase(sl()));
  sl.registerLazySingleton(() => UpdateNoteUseCase(sl()));

  // Repository
  sl.registerLazySingleton<NoteRepository>(
      () => NoteRepositoryImpl(localDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<NoteLocalDataSource>(
      () => NoteLocalDataSourceImpl());
}