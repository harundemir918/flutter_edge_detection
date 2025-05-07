import 'package:get_it/get_it.dart';
import '../../features/edge_detection/data/repositories/edge_detection_repository_impl.dart';
import '../../features/edge_detection/domain/repositories/edge_detection_repository.dart';
import '../../features/edge_detection/domain/usecases/detect_document.dart';
import '../../features/edge_detection/domain/usecases/save_processed_image.dart';
import '../../features/edge_detection/presentation/bloc/edge_detection_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => EdgeDetectionBloc(
      detectDocument: sl(),
      saveProcessedImage: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => DetectDocument(sl()));
  sl.registerLazySingleton(() => SaveProcessedImage(sl()));

  // Repository
  sl.registerLazySingleton<EdgeDetectionRepository>(
    () => EdgeDetectionRepositoryImpl(),
  );
}
