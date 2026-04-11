import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../providers/proxy_provider.dart';
import '../providers/server_provider.dart';

class BrowserScreen extends ConsumerStatefulWidget {
  const BrowserScreen({super.key});

  @override
  ConsumerState<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends ConsumerState<BrowserScreen> {
  WebViewController? _webViewController;
  String? _currentUrl;
  bool _isWebViewActive = false;
  final _urlController = TextEditingController();
  final _portController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(proxyControllerProvider.notifier).refresh();
      _prefillHostIp();
    });
  }

  /// Extracts host IP from server connection URL and pre-fills the Open URL field
  void _prefillHostIp() {
    final serverUrl = ref.read(serverConnectionProvider).url;
    if (serverUrl.isEmpty) return;

    // Parse IP from http://192.168.1.100:8080 or similar
    // Match IPv4 addresses (not localhost, not hostnames)
    final ipRegex = RegExp(r'https?://(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})(?::\d+)?');
    final match = ipRegex.firstMatch(serverUrl);
    
    if (match != null) {
      final hostIp = match.group(1);
      if (hostIp != null && hostIp != '127.0.0.1') {
        // Pre-fill with common dev server port
        _urlController.text = 'http://$hostIp:8888';
      }
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _portController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _openProxyUrl(int port) {
    final proxyController = ref.read(proxyControllerProvider.notifier);
    final url = proxyController.getProxyUrl(port);
    // Generate headers with the correct proxy path for HMAC signature
    final headers = proxyController.getProxyHeaders(path: '/api/proxy/$port/');

    if (url.isEmpty) return;

    setState(() {
      _currentUrl = url;
      _isWebViewActive = true;
      _pageError = null;
      _webViewController = WebViewController()
        ..setJavaScriptMode(_javaScriptEnabled ? JavaScriptMode.unrestricted : JavaScriptMode.disabled)
        ..setBackgroundColor(const Color(0xFFFFFFFF))
        ..setUserAgent('Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.0')
        ..clearCache()
        ..clearLocalStorage()
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              debugPrint('[Browser] Page started loading: $url');
              setState(() {
                _currentUrl = url;
                _isLoadingPage = true;
              });
              // Inject error capture as early as possible
              Future.microtask(() async {
                try {
                  await _webViewController?.runJavaScript(
                    'window.__omniErrors = []; window.onerror = function(msg,src,line,col,err){ window.__omniErrors.push(msg+"@"+src+":"+line); return false; }; window.addEventListener("unhandledrejection", function(e){ window.__omniErrors.push("UnhandledRejection: "+e.reason); });',
                  );
                } catch (_) {}
              });
            },
            onPageFinished: (url) async {
              debugPrint('[Browser] Page finished loading: $url');
              setState(() => _currentUrl = url);
              
              // Wait longer for JavaScript hydration (Next.js can take 2-3 seconds)
              await Future.delayed(const Duration(milliseconds: 3000));
              
              // Check if page has visible content
              try {
                final bodyText = await _webViewController?.runJavaScriptReturningResult(
                  'document.body?.innerText?.trim()?.length || 0',
                );
                final bodyLen = int.tryParse(bodyText?.toString() ?? '0') ?? 0;
                final hasBody = bodyLen > 10;
                debugPrint('[Browser] Page body innerText length: $bodyLen');
                
                // Check if body is visible
                final bodyDisplay = await _webViewController?.runJavaScriptReturningResult(
                  'window.getComputedStyle(document.body).display',
                );
                final bodyVisibility = await _webViewController?.runJavaScriptReturningResult(
                  'window.getComputedStyle(document.body).visibility',
                );
                final bodyOpacity = await _webViewController?.runJavaScriptReturningResult(
                  'window.getComputedStyle(document.body).opacity',
                );
                debugPrint('[Browser] Body styles - display: $bodyDisplay, visibility: $bodyVisibility, opacity: $bodyOpacity');
                
                // Check CSS stylesheets loading
                final cssInfo = await _webViewController?.runJavaScriptReturningResult(
                  'JSON.stringify(Array.from(document.styleSheets).map(function(s){return {href: s.href || "inline", rules: s.cssRules ? s.cssRules.length : "blocked"}}))',
                );
                debugPrint('[Browser] Stylesheets: $cssInfo');

                // Check computed background of main element (should be gradient for the dark theme)
                final mainBg = await _webViewController?.runJavaScriptReturningResult(
                  '''(function(){var m=document.querySelector("main"); return m ? JSON.stringify({bg: window.getComputedStyle(m).background.substring(0,80), cls: m.className}) : "no main";})()''',
                );
                debugPrint('[Browser] Main computed background: $mainBg');

                // Log any JS errors captured
                final jsErrors = await _webViewController?.runJavaScriptReturningResult(
                  'JSON.stringify(window.__omniErrors || [])',
                );
                debugPrint('[Browser] JS errors: $jsErrors');
                
                // The server now injects a CSS reset into proxied HTML that:
                // - Completes all CSS animations instantly (opacity:0 → visible)
                // - Disables backdrop-filter (requires GPU, fails on some Adreno devices)
                // As a belt-and-suspenders fallback, also force-reveal via JS.
                await _webViewController?.runJavaScript('''
                  (function revealAll() {
                    document.querySelectorAll('[style]').forEach(function(el) {
                      var s = el.style;
                      if (s.opacity === '0') s.opacity = '1';
                      if (s.transform && s.transform !== 'none') s.transform = 'none';
                    });
                  })();
                ''');
                
                if (!hasBody) {
                  setState(() {
                    _pageError = 'Page loaded but appears blank. The site may have JavaScript errors or require features not supported by WebView.';
                  });
                } else {
                  setState(() => _pageError = null);
                }
              } catch (e) {
                debugPrint('[Browser] Error checking content: $e');
              }
              
              setState(() => _isLoadingPage = false);
            },
            onWebResourceError: (error) {
              debugPrint('[Browser] Web resource error: ${error.description}, code: ${error.errorCode}, type: ${error.errorType}');
              if (mounted) {
                // Show clearer error messages for common proxy issues
                String errorMsg = error.description ?? 'Unknown error';
                if (errorMsg.contains('Cannot reach localhost') || 
                    errorMsg.contains('socket hang up') ||
                    errorMsg.contains('ECONNREFUSED')) {
                  errorMsg = 'No service running on localhost:$port on the host computer. Please start your dev server first.';
                } else if (errorMsg.contains('403') || errorMsg.contains('not registered')) {
                  errorMsg = 'Port $port is not registered for proxying. Please register it first.';
                }
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMsg),
                    duration: const Duration(seconds: 5),
                    action: SnackBarAction(
                      label: 'Register',
                      onPressed: () {
                        _portController.text = port.toString();
                        _nameController.text = 'Service on :$port';
                      },
                    ),
                  ),
                );
              }
            },
          ),
        )
        ..setOnConsoleMessage((message) {
          debugPrint('[Browser Console] ${message.level}: ${message.message}');
        })
        ..loadRequest(Uri.parse(url), headers: headers);
    });
  }

  void _openCustomUrl(String url) {
    final headers = ref.read(proxyControllerProvider.notifier).getProxyHeaders();

    setState(() {
      _pageError = null;
      _isLoadingPage = true;
      _currentUrl = url;
      _isWebViewActive = true;
      _webViewController = WebViewController()
        ..setJavaScriptMode(_javaScriptEnabled ? JavaScriptMode.unrestricted : JavaScriptMode.disabled)
        ..setBackgroundColor(const Color(0xFFFFFFFF))
        ..setUserAgent('Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36')
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              debugPrint('[Browser] Page started loading: $url');
              setState(() {
                _currentUrl = url;
                _isLoadingPage = true;
                _pageError = null;
              });
            },
            onPageFinished: (url) async {
              debugPrint('[Browser] Page finished loading: $url');
              setState(() => _isLoadingPage = false);
              
              // Check if page content loaded properly
              await Future.delayed(const Duration(seconds: 3));
              if (!mounted || _webViewController == null) return;
              
              try {
                final bodyLength = await _webViewController!.runJavaScriptReturningResult(
                  'document.body?.innerHTML?.length ?? 0',
                );
                debugPrint('[Browser] Page body length: $bodyLength');
                
                final rootContent = await _webViewController!.runJavaScriptReturningResult(
                  'document.getElementById("__next")?.innerHTML?.length ?? document.getElementById("root")?.innerHTML?.length ?? 0',
                );
                debugPrint('[Browser] Root element content length: $rootContent');
                
                if (rootContent.toString() == '0' && bodyLength.toString() != '0') {
                  setState(() => _pageError = 'Page loaded but React app did not hydrate. Try disabling JavaScript to view raw HTML.');
                }
              } catch (e) {
                debugPrint('[Browser] Error checking page content: $e');
              }
            },
            onHttpError: (error) {
              debugPrint('[Browser] HTTP error: ${error.response?.statusCode} for ${error.request?.uri}');
            },
            onWebResourceError: (error) {
              debugPrint('[Browser] Web resource error: ${error.description}, code: ${error.errorCode}, type: ${error.errorType}');
            },
          ),
        )
        ..setOnConsoleMessage((message) {
          debugPrint('[Browser Console] ${message.level}: ${message.message}');
        })
        ..clearCache()
        ..clearLocalStorage()
        ..loadRequest(Uri.parse(url), headers: headers);
    });
  }

  void _closeWebView() {
    setState(() {
      _isWebViewActive = false;
      _webViewController = null;
      _currentUrl = null;
      _pageError = null;
    });
  }

  bool _isLoadingPage = false;
  String? _pageError;
  bool _javaScriptEnabled = true;

  @override
  Widget build(BuildContext context) {
    final proxyState = ref.watch(proxyControllerProvider);
    final theme = Theme.of(context);

    if (_isWebViewActive && _webViewController != null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _closeWebView,
          ),
          title: Text(
            _currentUrl ?? 'Browser',
            style: theme.textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            if (_isLoadingPage)
              const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            IconButton(
              icon: Icon(_javaScriptEnabled ? Icons.javascript : Icons.code_off),
              tooltip: _javaScriptEnabled ? 'Disable JavaScript' : 'Enable JavaScript',
              onPressed: () async {
                // Toggle JavaScript mode
                setState(() => _javaScriptEnabled = !_javaScriptEnabled);
                final newMode = _javaScriptEnabled 
                    ? JavaScriptMode.unrestricted 
                    : JavaScriptMode.disabled;
                await _webViewController?.setJavaScriptMode(newMode);
                _webViewController?.reload();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(!_javaScriptEnabled 
                          ? 'JavaScript disabled - showing raw HTML' 
                          : 'JavaScript enabled'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _webViewController?.goBack(),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () => _webViewController?.goForward(),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _webViewController?.reload(),
            ),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _webViewController!),
            if (_isLoadingPage)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: theme.colorScheme.primaryContainer,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_pageError != null)
              Positioned(
                top: _isLoadingPage ? 40 : 0,
                left: 0,
                right: 0,
                child: Container(
                  color: theme.colorScheme.errorContainer,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: theme.colorScheme.error, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _pageError!,
                          style: TextStyle(
                            color: theme.colorScheme.onErrorContainer,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => setState(() => _pageError = null),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browser'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(proxyControllerProvider.notifier).refresh(),
          ),
        ],
      ),
      body: proxyState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Status card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          proxyState.enabled
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: proxyState.enabled
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reverse Proxy',
                                style: theme.textTheme.titleMedium,
                              ),
                              Text(
                                proxyState.enabled
                                    ? 'Enabled - ${proxyState.ports.length} port(s) registered'
                                    : 'Disabled on server',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (proxyState.error != null) ...[
                  const SizedBox(height: 8),
                  Card(
                    color: theme.colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        proxyState.error!,
                        style: TextStyle(color: theme.colorScheme.onErrorContainer),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Register new port
                Text('Register Port', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _portController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Port',
                          hintText: '3000',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name (optional)',
                          hintText: 'Dev Server',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: () {
                        final port = int.tryParse(_portController.text);
                        if (port == null || port <= 0 || port > 65535) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Enter a valid port number (1-65535)')),
                          );
                          return;
                        }
                        ref.read(proxyControllerProvider.notifier).registerPort(
                          port,
                          name: _nameController.text.isNotEmpty ? _nameController.text : null,
                        );
                        _portController.clear();
                        _nameController.clear();
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Available services (auto-discovered)
                Row(
                  children: [
                    Text('Available Services', style: theme.textTheme.titleSmall),
                    const SizedBox(width: 8),
                    if (proxyState.isScanning)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.refresh, size: 18),
                        tooltip: 'Scan for services',
                        onPressed: () => ref.read(proxyControllerProvider.notifier).scanForServices(),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                if (proxyState.availableServices.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.search, size: 36, color: theme.colorScheme.outline),
                            const SizedBox(height: 8),
                            Text(
                              'No services detected',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap refresh to scan for localhost services',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: proxyState.availableServices.map((service) => ActionChip(
                      avatar: const Icon(Icons.open_in_browser, size: 18),
                      label: Text('${service.name} (:${service.port})'),
                      onPressed: () {
                        ref.read(proxyControllerProvider.notifier).registerAndOpenPort(
                          service.port,
                          service.name,
                          (port) => _openProxyUrl(port),
                        );
                      },
                    )).toList(),
                  ),

                const SizedBox(height: 24),

                // Registered ports list
                Text('Proxied Services', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),

                if (proxyState.ports.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.language, size: 48, color: theme.colorScheme.outline),
                            const SizedBox(height: 8),
                            Text(
                              'No services registered',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Register a port above to view localhost services',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  ...proxyState.ports.map((proxy) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(proxy.name),
                      subtitle: Text('localhost:${proxy.port}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.open_in_browser),
                            tooltip: 'Open in browser',
                            onPressed: () => _openProxyUrl(proxy.port),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            tooltip: 'Unregister',
                            onPressed: () => ref
                                .read(proxyControllerProvider.notifier)
                                .unregisterPort(proxy.port),
                          ),
                        ],
                      ),
                    ),
                  )),

                const SizedBox(height: 24),

                // Direct URL entry
                Text('Open URL', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _urlController,
                        keyboardType: TextInputType.url,
                        decoration: const InputDecoration(
                          labelText: 'URL',
                          hintText: 'https://...',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onSubmitted: (url) {
                          if (url.isNotEmpty) {
                            _openCustomUrl(url);
                            _urlController.clear();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: () {
                        final url = _urlController.text;
                        if (url.isNotEmpty) {
                          _openCustomUrl(url);
                          _urlController.clear();
                        }
                      },
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
