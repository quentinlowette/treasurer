import 'dart:io';

export 'text_recognition.FMLV.service.dart';

/// Text Recognition Service
abstract class TextRecognitionService {
  DateTime date;
  double total;

  /// Tries to detects in the given [imageFile] the total and the date.
  ///
  /// It fills the [_total] and [_date] fields of the service.
  Future<void> detect(File imageFile);
}
