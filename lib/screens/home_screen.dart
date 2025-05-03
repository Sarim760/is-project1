import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isproject/screens/decode_screen.dart';
import 'package:isproject/servise/api_servise.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _coverController = TextEditingController();
  final _secretController = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  Future<void> _encode() async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final encoded = await ApiService.encodeText(
        _coverController.text,
        _secretController.text,
      );
      setState(() => _result = encoded);
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text Steganography')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _coverController,
              decoration: const InputDecoration(
                labelText: 'Cover Text',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _secretController,
              decoration: const InputDecoration(
                labelText: 'Secret Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _encode,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Encode Message'),
              ),
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text('Encoded Result:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SelectableText(
                _result,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _result));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard')),
                  );
                },
              ),
            ],
            // In home_page.dart, modify the navigation button:
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DecodePage(
                      initialStegoText:
                          _result, // Pass the encoded result automatically
                    ),
                  ),
                );
              },
              child: const Text('Go to Decode Page'),
            ),
          ],
        ),
      ),
    );
  }
}
