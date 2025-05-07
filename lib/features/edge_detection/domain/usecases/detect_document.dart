import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/error/failures.dart';
import '../repositories/edge_detection_repository.dart';

class DetectDocument {
  final EdgeDetectionRepository repository;

  DetectDocument(this.repository);

  Future<Either<Failure, Tuple2<File, List<Offset>>>> call(
    File imageFile,
  ) async {
    return await repository.detectDocument(imageFile);
  }
}
