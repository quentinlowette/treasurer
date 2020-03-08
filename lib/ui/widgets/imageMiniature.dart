import 'dart:io';

import 'package:flutter/material.dart';

class ImageMiniature extends StatelessWidget {
  final File imageFile;

  ImageMiniature({@required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (imageFile != null) {
          showDialog(
              context: context,
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                          fit: BoxFit.cover, image: FileImage(imageFile))),
                  child: Text(imageFile.path, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                ),
              ));
        }
      },
      child: Container(
        width: imageFile == null ? null : MediaQuery.of(context).size.width,
        height: imageFile == null ? null : 220.0,
        decoration: BoxDecoration(
            image: imageFile == null
                ? null
                : DecorationImage(
                    fit: BoxFit.cover, image: FileImage(imageFile))),
        child: imageFile == null ? Center(child: Text('Pas d\'image sélectionnée')) : null,
      ),
    );
  }
}
