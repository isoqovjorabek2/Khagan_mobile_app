// Platform-specific file handling
// This file helps bridge the gap between dart:io File (mobile) and dart:html File (web)

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:io' if (dart.library.html) 'dart:html' as io_platform;

class PlatformFileHelper {
  static bool canProcessFile(dynamic file) {
    return !kIsWeb && file != null;
  }

  static Future<bool> fileExists(dynamic file) async {
    if (kIsWeb || file == null) return false;
    try {
      // On non-web, file should be dart:io File
      // Use dynamic to avoid type issues during compilation
      final dynamic ioFile = file;
      return await ioFile.exists() as bool;
    } catch (e) {
      return false;
    }
  }

  static Future<http.ByteStream> getFileStream(dynamic file) async {
    if (kIsWeb) throw UnsupportedError('File operations not supported on web');
    final dynamic ioFile = file;
    return http.ByteStream(ioFile.openRead());
  }

  static Future<int> getFileLength(dynamic file) async {
    if (kIsWeb) throw UnsupportedError('File operations not supported on web');
    final dynamic ioFile = file;
    return await ioFile.length() as int;
  }

  static String getFileName(dynamic file) {
    if (kIsWeb) return '';
    final dynamic ioFile = file;
    return ioFile.path.toString().split('/').last;
  }
}

