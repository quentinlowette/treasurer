import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:treasurer/core/services/text_recognition.service.dart';

/// An implementation of the text recognition service using Firebase ML Vision.
class FMLVTextRecognitionService extends TextRecognitionService {
  /// Extracts a date from a [VisionText].
  ///
  /// Searches inside the [VisionText] for a sequence of character that matches
  /// a date's regular expression.
  DateTime _extractDate(VisionText visionText) {
    // The regular expression of a date.
    String datePattern = r"\d{1,2}(\/|-)\d{1,2}\1\d{2,4}";
    RegExp dateRegEx = RegExp(datePattern);

    // Loops through the VisionText.
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        // Searches a match for the regular expression.
        String match = dateRegEx.stringMatch(line.text);

        // If there is a match.
        if (match != null) {
          List<String> splitted;
          if (match.contains('/')) {
            splitted = match.split('/');
          } else {
            splitted = match.split('-');
          }

          // Splits day, month and year.
          int year = int.parse(splitted[2]);
          int month = int.parse(splitted[1]);
          int day = int.parse(splitted[0]);

          // Converts 2-digits date into 4-digit ones.
          if (year < 100) {
            year += 2000;
          }

          DateTime extractedDate = DateTime(year, month, day);

          // Prevents future predictions.
          if (extractedDate.compareTo(DateTime.now()) < 0) {
            return extractedDate;
          }
        }
      }
    }

    return null;
  }

  /// Extracts a total from a [VisionText].
  ///
  /// Searches inside the [VisionText] for a sequence of character that matches
  /// a money amount's regular expression. If there is a match that also
  /// contains the symbol "EUR" it returns it, otherwise it returns the biggest
  /// detected floating number.
  double _extractTotal(VisionText visionText) {
    // The regular expression of a money amount.
    String floatPattern = r"[-+]?\d+(\.|,)\d+";
    RegExp floatRegEx = RegExp(floatPattern);

    List<double> floatingNumbers = List<double>();

    // Loops through the VisionText.
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        // Searches a match for the regular expression.
        String match = floatRegEx.stringMatch(line.text);

        // If there is a match and if the macthed line contains 'EUR'.
        if (match != null && line.text.contains('EUR')) {
          return double.parse(match.replaceAll(',', '.'));
        }

        // If there is a match
        if (match != null) {
          floatingNumbers.add(double.parse(match.replaceAll(',', '.')));
        }
      }
    }

    return floatingNumbers
        .reduce((current, next) => current >= next ? current : next);
  }

  @override
  Future<TextRecognitionServiceResponse> detect(File imageFile) async {
    // Vision Image
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);

    // Detector
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    // Recognition
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    // EXtract the date
    DateTime date = _extractDate(visionText);

    // EXtract the total
    double total = _extractTotal(visionText);

    /// Close the recognizer
    textRecognizer.close();

    return TextRecognitionServiceResponse(date, total);
  }
}
