import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/edge_detection_repository.dart';

class SaveProcessedImage {
  final EdgeDetectionRepository repository;

  SaveProcessedImage(this.repository);

  Future<Either<Failure, File>> call(File processedImage) async {
    return await repository.saveProcessedImage(processedImage);
  }
}
