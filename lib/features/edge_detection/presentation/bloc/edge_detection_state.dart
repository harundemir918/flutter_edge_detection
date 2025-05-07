part of 'edge_detection_bloc.dart';

abstract class EdgeDetectionState extends Equatable {
  const EdgeDetectionState();

  @override
  List<Object> get props => [];
}

class EdgeDetectionInitial extends EdgeDetectionState {}

class EdgeDetectionLoading extends EdgeDetectionState {}

class EdgeDetectionSuccess extends EdgeDetectionState {
  final File processedImage;
  final List<Offset> corners;

  const EdgeDetectionSuccess({
    required this.processedImage,
    required this.corners,
  });

  @override
  List<Object> get props => [processedImage, corners];
}

class EdgeDetectionSaved extends EdgeDetectionState {
  final File savedImage;

  const EdgeDetectionSaved({required this.savedImage});

  @override
  List<Object> get props => [savedImage];
}

class EdgeDetectionError extends EdgeDetectionState {
  final String message;

  const EdgeDetectionError({required this.message});

  @override
  List<Object> get props => [message];
}
