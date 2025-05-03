import 'dart:convert'; // Required for base64 and utf8
import 'dart:async';

class ApiService {
  // Enhanced mock encoding with proper format
  static Future<String> encodeText(String cover, String secret) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (cover.isEmpty || secret.isEmpty) {
      throw Exception("Both texts are required");
    }
    
    // Format: "STEGO:[timestamp]:[cover_length]|[encoded_data]"
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final encodedSecret = _encodeBase64(secret);
    return "STEGO:$timestamp:${cover.length}|$cover|$encodedSecret";
  }

  // Reliable decoding implementation
  static Future<String> decodeText(String stegoText) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    try {
      if (!stegoText.startsWith("STEGO:")) {
        throw Exception("Invalid stego text format");
      }
      
      final parts = stegoText.split('|');
      if (parts.length != 3) throw Exception("Malformed data");
      
      final coverLength = int.tryParse(parts[0].split(':')[2]) ?? 0;
      final cover = parts[1];
      final secret = parts[2];
      
      if (cover.length != coverLength) {
        throw Exception("Data corrupted: length mismatch");
      }
      
      return _decodeBase64(secret);
    } catch (e) {
      throw Exception("Decoding failed: ${e.toString()}");
    }
  }

  // Private encoding helpers
  static String _encodeBase64(String text) {
    return base64Encode(utf8.encode(text));
  }

  static String _decodeBase64(String text) {
    return utf8.decode(base64Decode(text));
  }
}