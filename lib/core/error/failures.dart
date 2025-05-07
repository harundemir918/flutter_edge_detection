import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure([this.message = '']);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server Error']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache Error']) : super(message);
}

class PermissionFailure extends Failure {
  const PermissionFailure([String message = 'Permission Denied'])
    : super(message);
}

class ImageProcessingFailure extends Failure {
  const ImageProcessingFailure([String message = 'Image Processing Error'])
    : super(message);
}
