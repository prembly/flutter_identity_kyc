class VerificationException implements Exception {
  String? error;

  VerificationException(this.error);

  @override
  String toString() {
    if (error == null) return 'Unknown error';
    return error!;
  }
}

class NotInitializeException extends VerificationException {
  NotInitializeException(String? error) : super(error);
}