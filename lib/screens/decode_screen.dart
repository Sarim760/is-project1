import 'package:flutter/material.dart';
import 'package:isproject/servise/api_servise.dart';

class DecodePage extends StatefulWidget {
  final String? initialStegoText; // Optional pre-filled text

  const DecodePage({super.key, this.initialStegoText});

  @override
  State<DecodePage> createState() => _DecodePageState();
}

class _DecodePageState extends State<DecodePage> {
  final _controller = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialStegoText != null) {
      _controller.text = widget.initialStegoText!;
    }
  }

  Future<void> _decode() async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final decoded = await ApiService.decodeText(_controller.text.trim());
      setState(() => _result = decoded);
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Decode Message')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Paste Encoded Text',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _decode,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Decode Message'),
              ),
            ),
            const SizedBox(height: 20),
            if (_result.isNotEmpty) ...[
              const Text(
                'Hidden Message:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  _result,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
