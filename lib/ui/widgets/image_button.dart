import 'dart:io';

import 'package:flutter/material.dart';
import 'package:treasurer/ui/colors.dart';

/// A button to display the receipt image of an operation.
///
/// When pressed, it displays the picture in a dialog.
class ImageButton extends StatelessWidget {
  /// The path to the pictire.
  final String imagePath;

  ImageButton({@required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        imagePath == null ? Icons.filter_none : Icons.collections,
        color: DefaultThemeColors.white,
      ),
      onPressed: () {
        if (imagePath != null) {
          showDialog(
            context: context,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: DefaultThemeColors.white,
                ),
                padding: const EdgeInsets.all(8.0),
                child: Image.file(File("$imagePath")),
              ),
            ),
          );
        }
      },
    );
  }
}
