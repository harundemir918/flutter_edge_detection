part of 'edge_detection_bloc.dart';

abstract class EdgeDetectionEvent extends Equatable {
  const EdgeDetectionEvent();

  @override
  List<Object> get props => [];
}

class ProcessImageEvent extends EdgeDetectionEvent {
  final File imageFile;

  const ProcessImageEvent(this.imageFile);

  @override
  List<Object> get props => [imageFile];
}

class SaveImageEvent extends EdgeDetectionEvent {
  final File processedImage;

  const SaveImageEvent(this.processedImage);

  @override
  List<Object> get props => [processedImage];
}

class MoveCornerEvent extends EdgeDetectionEvent {
  final int index;
  final Offset newPosition;

  const MoveCornerEvent(this.index, this.newPosition);

  @override
  List<Object> get props => [index, newPosition];
}
