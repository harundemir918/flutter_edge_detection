import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;
import '../../../../core/error/failures.dart';
import '../../domain/repositories/edge_detection_repository.dart';

class EdgeDetectionRepositoryImpl implements EdgeDetectionRepository {
  @override
  Future<Either<Failure, Tuple2<File, List<Offset>>>> detectDocument(
    File imageFile,
  ) async {
    try {
      // 1. Read image as Mat
      final mat = cv.imread(imageFile.path);

      // 2. Convert to grayscale
      final gray = cv.cvtColor(mat, cv.COLOR_BGR2GRAY);

      // 3. Gaussian blur
      final blurred = cv.gaussianBlur(gray, (5, 5), 0);

      // 4. Canny edge detection
      final edged = cv.canny(blurred, 75, 200);

      // 5. Find contours
      final result = cv.findContours(
        edged,
        cv.RETR_EXTERNAL,
        cv.CHAIN_APPROX_SIMPLE,
      );
      final contours = result.$1;

      List<Offset> quad = [];
      double maxArea = 0;
      for (final contour in contours) {
        final peri = cv.arcLength(contour, true);
        final approx = cv.approxPolyDP(contour, 0.02 * peri, true);
        if (approx.length == 4) {
          final area = cv.contourArea(approx);
          if (area > maxArea) {
            maxArea = area;
            quad =
                approx
                    .map<Offset>(
                      (pt) => Offset(pt.x.toDouble(), pt.y.toDouble()),
                    )
                    .toList();
          }
        }
      }

      if (quad.length != 4) {
        return const Left(ImageProcessingFailure('Document not found'));
      }

      // Save the processed image (edged) for preview
      final tempDir = await getTemporaryDirectory();
      final outputFile = File(
        '${tempDir.path}/edge_detected_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      final bytes = cv.imencode('.png', edged).$2;
      await outputFile.writeAsBytes(bytes);

      return Right(Tuple2(outputFile, quad));
    } catch (e) {
      return Left(ImageProcessingFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, File>> saveProcessedImage(File processedImage) async {
    try {
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        return const Left(CacheFailure('Could not access Downloads directory'));
      }

      final fileName =
          'edge_detected_${DateTime.now().millisecondsSinceEpoch}.png';
      final savedFile = File('${downloadsDir.path}/$fileName');

      // Copy the processed image to Downloads directory
      await processedImage.copy(savedFile.path);

      return Right(savedFile);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
