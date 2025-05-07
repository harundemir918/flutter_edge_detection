import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../domain/usecases/detect_document.dart';
import '../../domain/usecases/save_processed_image.dart';

part 'edge_detection_event.dart';
part 'edge_detection_state.dart';

class EdgeDetectionBloc extends Bloc<EdgeDetectionEvent, EdgeDetectionState> {
  final DetectDocument detectDocument;
  final SaveProcessedImage saveProcessedImage;

  EdgeDetectionBloc({
    required this.detectDocument,
    required this.saveProcessedImage,
  }) : super(EdgeDetectionInitial()) {
    on<ProcessImageEvent>(_onProcessImage);
    on<SaveImageEvent>(_onSaveImage);
    on<MoveCornerEvent>(_onMoveCorner);
  }

  Future<void> _onProcessImage(
    ProcessImageEvent event,
    Emitter<EdgeDetectionState> emit,
  ) async {
    emit(EdgeDetectionLoading());
    final result = await detectDocument(event.imageFile);
    result.fold(
      (failure) => emit(EdgeDetectionError(message: failure.message)),
      (tuple) => emit(
        EdgeDetectionSuccess(
          processedImage: tuple.value1,
          corners: tuple.value2,
        ),
      ),
    );
  }

  Future<void> _onSaveImage(
    SaveImageEvent event,
    Emitter<EdgeDetectionState> emit,
  ) async {
    emit(EdgeDetectionLoading());
    final result = await saveProcessedImage(event.processedImage);
    result.fold(
      (failure) => emit(EdgeDetectionError(message: failure.message)),
      (savedImage) => emit(EdgeDetectionSaved(savedImage: savedImage)),
    );
  }

  void _onMoveCorner(MoveCornerEvent event, Emitter<EdgeDetectionState> emit) {
    if (state is EdgeDetectionSuccess) {
      final currentState = state as EdgeDetectionSuccess;
      final updatedCorners = List<Offset>.from(currentState.corners);
      updatedCorners[event.index] = event.newPosition;
      emit(
        EdgeDetectionSuccess(
          processedImage: currentState.processedImage,
          corners: updatedCorners,
        ),
      );
    }
  }
}
