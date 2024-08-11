library iban_detector;

import 'dart:io';

import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// A Calculator.
class IbanDetector {
  // make this class a singleton

  static final IbanDetector instance = IbanDetector._();

  IbanDetector._();

  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;

  Future<void> textRecognizeFromUrl(String url) async {
    final textRecognizer = TextRecognizer();

    // Resmi indir ve yerel dosya sistemine kaydet
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/image.jpg');
      await file.writeAsBytes(response.bodyBytes);

      final value = textRecognizeFromFile(file);
    } else {
      print('Failed to download image');
    }
  }

  Future<List<String>> textRecognizeFromFile(File file) async {
    final textRecognizer = TextRecognizer();
    final inputImage = InputImage.fromFile(file);
    final visionText = await textRecognizer.processImage(inputImage);
    List<String> textList = [];
    for (final block in visionText.blocks) {
      for (final line in block.lines) {
        for (final element in line.elements) {
          textList.add(element.text);

          print(element.text);
        }
      }
    }
    return textList;
  }
}
