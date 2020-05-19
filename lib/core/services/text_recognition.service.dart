import 'dart:io';

export 'text_recognition.FMLV.service.dart';

/// An abstract text recognition service.
abstract class TextRecognitionService {
  /// Tries to detects in the given `imageFile` the total and the date.
  Future<TextRecognitionServiceResponse> detect(File imageFile);
}

/// A response of the text recognition service.
///
/// Basic wrapper around the two values returned by the service.
class TextRecognitionServiceResponse {
  /// The detected date.
  DateTime date;

  /// The detected total.
  double total;

  TextRecognitionServiceResponse(this.date, this.total);
}
