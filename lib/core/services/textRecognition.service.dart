import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';

/// Text Recognition Service
abstract class TextRecognitionService {
  DateTime _date;
  double _total;

  DateTime get date => _date;
  double get total => _total;

  /// Tries to detects in the given [imageFile] the total and the date.
  ///
  /// It fills the [_total] and [_date] fields of the service.
  Future<void> detect(File imageFile);
}

/// Implementation of the Text Recognition Service using Firebase ML Vision
class FMLVTextRecognitionService extends TextRecognitionService {

  /// Extracts a date from a VisionText
  DateTime _extractDate(VisionText visionText) {
    // Date regular expression
    String datePattern = r"\d{1,2}(\/|-)\d{1,2}\1\d{2,4}";
    RegExp dateRegEx = RegExp(datePattern);

    // Search for the regular expression
    for (TextBlock block in visionText.blocks) {
      for(TextLine line in block.lines) {
        String match = dateRegEx.stringMatch(line.text);
        if (match != null) {
          List<String> splitted;
          if (match.contains('/')) {
            splitted = match.split('/');
          } else {
            splitted = match.split('-');
          }

          int year = int.parse(splitted[2]);
          int month = int.parse(splitted[1]);
          int day = int.parse(splitted[0]);

          if (year < 100) {
            year += 2000;
          }

          DateTime extractedDate = DateTime(year, month, day);

          if (extractedDate.compareTo(DateTime.now()) < 0) {
            return extractedDate;
          }
        }
      }
    }

    return null;
  }

  /// Extracts a total from a VisionText
  double _extractTotal(VisionText visionText) {
    // Float number regular expression
    String floatPattern = r"[-+]?\d+(\.|,)\d+";
    RegExp floatRegEx = RegExp(floatPattern);

    List<double> floatingNumbers = List<double>();

    for (TextBlock block in visionText.blocks) {
      for(TextLine line in block.lines) {
        String match = floatRegEx.stringMatch(line.text);
        if (line.text.contains('EUR') && match != null) {
          return double.parse(match.replaceAll(',', '.'));
        } if (match != null) {
          floatingNumbers.add(double.parse(match.replaceAll(',', '.')));
        }
      }
    }

    return floatingNumbers.reduce((current, next) => current > next ? current : next);
  }

  @override
  Future<void> detect(File imageFile) async {
    // Vision Image
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);

    // Detector
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();

    // Recognition
    final VisionText visionText = await textRecognizer.processImage(visionImage);

    // EXtract the date
    _date = _extractDate(visionText);

    // EXtract the total
    _total = _extractTotal(visionText);

    /// Close the recognizer
    textRecognizer.close();

    return;
  }
}
