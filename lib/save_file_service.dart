import 'dart:async';

import 'package:flutter/services.dart';

abstract class SaveFileService {
  Future<bool> saveFile({required String fileName, required String text});
}

class MethodChannelService implements SaveFileService {
  static const _methodChannel =
  MethodChannel("com.example.text_editors/action");

  @override
  Future<bool> saveFile({required String fileName, required String text}) async {
    try {
      final result = await _methodChannel.invokeMethod(
        "createFile",
        {
          'fileName': fileName,
          'content': text,
        },
      );
      return result as bool; // Ensure result is bool
    } catch (e) {
      print("Error saving file: $e"); // Print error for debugging
      return false;
    }
  }
}
