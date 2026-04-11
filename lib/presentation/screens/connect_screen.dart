import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/constants.dart';
import '../../presentation/providers/server_provider.dart';
import 'home_screen.dart';
import 'qr_scanner_screen.dart';

class ConnectScreen extends ConsumerStatefulWidget {
  const ConnectScreen({super.key});

  @override
  ConsumerState<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends ConsumerState<ConnectScreen> {
  final _urlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  bool _isLoading = false;
  bool _hasSavedConfig = false;
  String? _savedUrl;
  String? _lastConnectedAt;

  @override
  void initState() {
    super.initState();
    final serverConnection = ref.read(serverConnectionProvider);
    _urlController.text = serverConnection.url;
    _apiKeyController.text = serverConnection.apiKey;
    _checkSavedConfig();
  }

  Future<void> _checkSavedConfig() async {
    final notifier = ref.read(serverConnectionProvider.notifier);
    final hasSaved = await notifier.hasSavedConfig;
    final savedConfig = await notifier.getSavedConfig();

    if (mounted) {
      setState(() {
        _hasSavedConfig = hasSaved;
        _savedUrl = savedConfig['url'];
        _lastConnectedAt = savedConfig['lastConnectedAt'];
      });
    }
  }

  Future<void> _reconnect() async {
    setState(() => _isLoading = true);

    await ref.read(serverConnectionProvider.notifier).reconnect();

    if (!mounted) return;

    setState(() => _isLoading = false);

    final serverConnection = ref.read(serverConnectionProvider);

    if (serverConnection.isConnected) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(serverConnection.error ?? 'Reconnection failed'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  String _formatLastConnected(String? iso8601String) {
    if (iso8601String == null) return '';
    try {
      final dateTime = DateTime.parse(iso8601String);
      final now = DateTime.now();
      final diff = now.difference(dateTime);

      if (diff.inMinutes < 1) {
        return 'Just now';
      } else if (diff.inHours < 1) {
        return '${diff.inMinutes} min ago';
      } else if (diff.inDays < 1) {
        return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
      } else if (diff.inDays < 30) {
        return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
      } else {
        return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    final url = _urlController.text.trim();
    final apiKey = _apiKeyController.text.trim();

    if (url.isEmpty || apiKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both URL and API key')),
      );
      return;
    }

    setState(() => _isLoading = true);

    ref.read(serverConnectionProvider.notifier).updateUrl(url);
    ref.read(serverConnectionProvider.notifier).updateApiKey(apiKey);
    await ref.read(serverConnectionProvider.notifier).connect();

    if (!mounted) return;

    setState(() => _isLoading = false);

    final serverConnection = ref.read(serverConnectionProvider);
    
    if (serverConnection.isConnected) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(serverConnection.error ?? 'Connection failed'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _scanQRCode() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const QRScannerScreen()),
    );

    if (result != null && mounted) {
      final url = result['url'] as String?;
      final apiKey = result['apiKey'] as String?;

      if (url != null && apiKey != null) {
        setState(() {
          _urlController.text = url;
          _apiKeyController.text = apiKey;
        });

        // Optionally auto-connect
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('QR code scanned successfully! Connecting...'),
            backgroundColor: Colors.green,
          ),
        );

        // Small delay to show the success message
        await Future.delayed(const Duration(milliseconds: 500));
        await _connect();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid QR code format'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final serverConnection = ref.watch(serverConnectionProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Image.asset('assets/images/logo.png', width: 120, height: 120),
              const SizedBox(height: 16),
              Text(
                AppConstants.appName,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Connect to your omni-code server',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Reconnect Card
              if (_hasSavedConfig && _savedUrl != null)
                Card(
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Color(0xFF2A3441)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.history,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Previous Connection',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _savedUrl!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (_lastConnectedAt != null)
                          Text(
                            'Last connected: ${_formatLastConnected(_lastConnectedAt)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _reconnect,
                            icon: _isLoading
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.refresh),
                            label: Text(_isLoading ? 'Connecting...' : 'Reconnect'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_hasSavedConfig) const SizedBox(height: 24),
              if (_hasSavedConfig)
                Row(
                  children: [
                    Expanded(child: Divider(color: theme.colorScheme.onSurface.withOpacity(0.2))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: theme.colorScheme.onSurface.withOpacity(0.2))),
                  ],
                ),
              if (_hasSavedConfig) const SizedBox(height: 24),
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Server URL',
                  hintText: 'https://xxx.ngrok.io',
                  prefixIcon: Icon(Icons.link),
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
                keyboardType: TextInputType.url,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _apiKeyController,
                decoration: const InputDecoration(
                  labelText: 'API Key',
                  hintText: 'Enter your API key',
                  prefixIcon: Icon(Icons.vpn_key),
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
                obscureText: true,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 8),
              if (serverConnection.error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withOpacity(0.1),
                    border: Border(left: BorderSide(color: theme.colorScheme.error, width: 2)),
                  ),
                  child: Text(
                    serverConnection.error!,
                    style: TextStyle(color: theme.colorScheme.error, fontSize: 14),
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _connect,
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Connect', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 16),
              // QR Code Scanner Button
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _scanQRCode,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan QR Code'),
                  style: OutlinedButton.styleFrom(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
