import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _isScanning = true;
  String? _errorMessage;

  void _onDetect(BarcodeCapture capture) {
    if (!_isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;
    
    for (final barcode in barcodes) {
      final String? rawValue = barcode.rawValue;
      if (rawValue == null) continue;

      try {
        // Parse the QR code data as JSON
        final Map<String, dynamic> data = jsonDecode(rawValue);
        
        // Validate the data format
        if (data.containsKey('url') && data.containsKey('key')) {
          // Valid QR code - stop scanning and return the data
          setState(() => _isScanning = false);
          
          Navigator.of(context).pop({
            'url': data['url'] as String,
            'apiKey': data['key'] as String,
            'name': data['name'] as String?,
          });
          return;
        } else {
          setState(() {
            _errorMessage = 'Invalid QR code format';
          });
        }
      } catch (e) {
        // Not valid JSON, try to parse as a custom format
        if (rawValue.startsWith('http')) {
          // Try to extract URL and API key from query params
          final uri = Uri.tryParse(rawValue);
          if (uri != null && uri.queryParameters.containsKey('key')) {
            setState(() => _isScanning = false);
            Navigator.of(context).pop({
              'url': '${uri.scheme}://${uri.host}${uri.path}',
              'apiKey': uri.queryParameters['key']!,
              'name': uri.queryParameters['name'],
            });
            return;
          }
        }
        
        setState(() {
          _errorMessage = 'Could not parse QR code';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Camera preview
          MobileScanner(
            onDetect: _onDetect,
            errorBuilder: (context, error, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Camera error: ${error.errorCode}',
                      style: TextStyle(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.errorDetails?.message ?? 'Unknown error',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          
          // Scan overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
          
          // Instructions
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.zero,
                ),
                child: const Text(
                  'Point camera at QR code on your computer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          
          // Error message
          if (_errorMessage != null)
            Positioned(
              bottom: 150,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withOpacity(0.9),
                  borderRadius: BorderRadius.zero,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: theme.colorScheme.onError,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: theme.colorScheme.onError),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: theme.colorScheme.onError,
                        size: 18,
                      ),
                      onPressed: () {
                        setState(() => _errorMessage = null);
                      },
                    ),
                  ],
                ),
              ),
            ),
          
          // Loading indicator when scan is processed
          if (!_isScanning)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
