class LayerException implements Exception {
  final String message;

  const LayerException({required this.message});
}

class LayerAlreadyExistsException extends LayerException {
  const LayerAlreadyExistsException({required super.message});
}

class LayerNotExistsException extends LayerException {
  const LayerNotExistsException({required super.message});
}
