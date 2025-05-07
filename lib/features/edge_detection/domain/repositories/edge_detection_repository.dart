import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/error/failures.dart';

abstract class EdgeDetectionRepository {
  Future<Either<Failure, Tuple2<File, List<Offset>>>> detectDocument(
    File imageFile,
  );
  Future<Either<Failure, File>> saveProcessedImage(File processedImage);
}
