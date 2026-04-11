import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/repositories/remote_repository.dart';
import '../providers/adb_provider.dart';
import '../providers/server_provider.dart';
import '../providers/workspace_provider.dart';

class DevicesScreen extends ConsumerStatefulWidget {
  const DevicesScreen({super.key});

  @override
  ConsumerState<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends ConsumerState<DevicesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentTab = 0;

  final _installPathController = TextEditingController();
  final _packageNameController = TextEditingController();
  final _activityController = TextEditingController();

  // Wireless pairing fields
  final _pairIpController = TextEditingController();
  final _pairPortController = TextEditingController();
  final _pairCodeController = TextEditingController();

  String? _selectedAndroidDeviceId;
  String? _selectedIosDeviceId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _currentTab = _tabController.index);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adbControllerProvider.notifier).refreshDevices();
      ref.read(iosControllerProvider.notifier).refreshDevices();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _installPathController.dispose();
    _packageNameController.dispose();
    _activityController.dispose();
    _pairIpController.dispose();
    _pairPortController.dispose();
    _pairCodeController.dispose();
    super.dispose();
  }

  // ─── Android dialogs ───────────────────────────────────────────────────────

  void _showInstallDialog() {
    _installPathController.clear();
    showDialog(
      context: context,
      builder: (ctx) => _PackagePickerDialog(
        title: 'Install APK via ADB',
        actionLabel: 'Install',
        ref: ref,
        filePattern: '*.apk',
        fileIcon: Icons.android,
        fileTypeLabel: 'APK',
        manualPathController: _installPathController,
        onFileSelected: (apkPath) async {
          final workspaceId = ref.read(currentWorkspaceProvider).valueOrNull?.sharedId;
          final packageName = await ref
              .read(adbControllerProvider.notifier)
              .installApk(apkPath, deviceId: _selectedAndroidDeviceId, workspaceId: workspaceId);
          if (mounted) {
            if (packageName != null) {
              // Install succeeded and we know the package name — offer a Launch button
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('APK installed successfully'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 6),
                  action: SnackBarAction(
                    label: 'Launch',
                    textColor: Colors.white,
                    onPressed: () async {
                      final launched = await ref
                          .read(adbControllerProvider.notifier)
                          .launchApp(packageName, deviceId: _selectedAndroidDeviceId);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(launched ? 'App launched' : 'Launch failed'),
                            backgroundColor: launched ? Colors.green : Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            } else {
              // Install result (success vs failure) is in the ADB state error field
              final adbState = ref.read(adbControllerProvider);
              final succeeded = adbState.error == null;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(succeeded ? 'APK installed successfully' : 'Install failed'),
                  backgroundColor: succeeded ? Colors.green : Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _showLaunchDialog() {
    final lastPkg = ref.read(adbControllerProvider).lastInstalledPackage;
    _packageNameController.text = lastPkg ?? '';
    _activityController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Launch App'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _packageNameController,
              decoration: const InputDecoration(
                labelText: 'Package name',
                hintText: 'com.example.myapp',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _activityController,
              decoration: const InputDecoration(
                labelText: 'Activity (optional)',
                hintText: '.MainActivity',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final pkg = _packageNameController.text.trim();
              if (pkg.isEmpty) return;
              final activity = _activityController.text.trim();
              final success = await ref
                  .read(adbControllerProvider.notifier)
                  .launchApp(
                    pkg,
                    activityName: activity.isNotEmpty ? activity : null,
                    deviceId: _selectedAndroidDeviceId,
                  );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'App launched' : 'Launch failed'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Launch'),
          ),
        ],
      ),
    );
  }

  void _showPairDialog() {
    _pairIpController.clear();
    _pairPortController.clear();
    _pairCodeController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Wireless ADB Pairing'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'On the target device, enable Developer Options > Wireless debugging > Pair device with pairing code.',
              style: Theme.of(ctx).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pairIpController,
              decoration: const InputDecoration(
                labelText: 'IP address',
                hintText: '192.168.1.100',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pairPortController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Pairing port',
                hintText: '37099',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pairCodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Pairing code',
                hintText: '123456',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final ip = _pairIpController.text.trim();
              final port = int.tryParse(_pairPortController.text.trim());
              final code = _pairCodeController.text.trim();
              if (ip.isEmpty || port == null || code.isEmpty) return;
              final success = await ref
                  .read(adbControllerProvider.notifier)
                  .wirelessPair(ip, port, code);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Device paired successfully' : 'Pairing failed'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Pair'),
          ),
        ],
      ),
    );
  }

  void _showLocalInstallDialog() {
    final localPathController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => _PackagePickerDialog(
        title: 'Download & Install Locally',
        actionLabel: 'Download & Install',
        ref: ref,
        filePattern: '*.apk',
        fileIcon: Icons.android,
        fileTypeLabel: 'APK',
        manualPathController: localPathController,
        onFileSelected: (apkPath) async {
          await _downloadAndInstallApk(apkPath);
        },
      ),
    );
  }

  Future<void> _downloadAndInstallApk(String remotePath) async {
    debugPrint('[DownloadInstall] Starting for remotePath=$remotePath, platform=${Platform.operatingSystem}');

    if (!Platform.isAndroid) {
      debugPrint('[DownloadInstall] Not Android — aborting');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Local APK install is only available on Android')),
        );
      }
      return;
    }

    final progressNotifier = ValueNotifier<_DownloadProgress>(const _DownloadProgress());

    try {
      final repo = ref.read(remoteRepositoryProvider);
      final workspaceId = ref.read(currentWorkspaceProvider).valueOrNull?.sharedId;
      final downloadUrl = repo.getDownloadUrl(remotePath, workspaceId: workspaceId);
      // Sign the exact path+query that the server will see in req.originalUrl
      final downloadUri = Uri.parse(downloadUrl);
      final downloadPath = downloadUri.path + (downloadUri.hasQuery ? '?${downloadUri.query}' : '');
      final headers = repo.getProxyHeaders(path: downloadPath);
      debugPrint('[DownloadInstall] workspaceId=$workspaceId');
      debugPrint('[DownloadInstall] downloadUrl=$downloadUrl');
      debugPrint('[DownloadInstall] headers=$headers');

      final dir = await getTemporaryDirectory();
      final fileName = remotePath.split('/').last;
      final localPath = '${dir.path}/$fileName';
      debugPrint('[DownloadInstall] localPath=$localPath');

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => _DownloadProgressDialog(
            fileName: fileName,
            progress: progressNotifier,
          ),
        );
      }

      final dio = Dio();
      debugPrint('[DownloadInstall] Starting Dio download...');
      await dio.download(
        downloadUrl,
        localPath,
        options: Options(headers: headers),
        onReceiveProgress: (received, total) {
          progressNotifier.value = _DownloadProgress(
            received: received,
            total: total > 0 ? total : 0,
          );
          if (total > 0) {
            final pct = (received / total * 100).toStringAsFixed(1);
            debugPrint('[DownloadInstall] Progress: $received/$total ($pct%)');
          }
        },
      );
      debugPrint('[DownloadInstall] Download complete, file=$localPath');

      if (mounted) Navigator.of(context, rootNavigator: true).pop();

      // Verify the file exists and has a reasonable size
      final file = File(localPath);
      final fileSize = await file.length();
      debugPrint('[DownloadInstall] Local file size: $fileSize bytes');

      const authority = 'app.omnicode.omnigo.fileprovider';
      final contentUri = 'content://$authority/cache/$fileName';
      debugPrint('[DownloadInstall] Launching installer via AndroidIntent, uri=$contentUri');
      final intent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        data: contentUri,
        type: 'application/vnd.android.package-archive',
        flags: [Flag.FLAG_GRANT_READ_URI_PERMISSION, Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
      debugPrint('[DownloadInstall] AndroidIntent launched successfully');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('APK downloaded — install prompt should appear')),
        );
      }
    } on DioException catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      debugPrint('[DownloadInstall] DioException: type=${e.type}, message=${e.message}');
      debugPrint('[DownloadInstall] DioException response: status=${e.response?.statusCode}, data=${e.response?.data}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed (${e.response?.statusCode ?? e.type.name}): ${e.response?.data?['error'] ?? e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e, stack) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      debugPrint('[DownloadInstall] Unexpected error: $e');
      debugPrint('[DownloadInstall] Stack: $stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      progressNotifier.dispose();
    }
  }

  // ─── iOS dialogs ───────────────────────────────────────────────────────────

  void _showIpaInstallDialog() {
    final ipaPathController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => _PackagePickerDialog(
        title: 'Install IPA via ios-deploy',
        actionLabel: 'Install',
        ref: ref,
        filePattern: '*.ipa',
        fileIcon: Icons.phone_iphone,
        fileTypeLabel: 'IPA',
        manualPathController: ipaPathController,
        onFileSelected: (ipaPath) async {
          final workspaceId = ref.read(currentWorkspaceProvider).valueOrNull?.sharedId;
          final success = await ref
              .read(iosControllerProvider.notifier)
              .installIpa(ipaPath, deviceId: _selectedIosDeviceId, workspaceId: workspaceId);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(success ? 'IPA installed successfully' : 'Install failed'),
                backgroundColor: success ? Colors.green : Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final adbState = ref.watch(adbControllerProvider);
    final iosState = ref.watch(iosControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
        actions: [
          if (_currentTab == 0)
            IconButton(
              icon: const Icon(Icons.wifi),
              tooltip: 'Wireless pairing',
              onPressed: _showPairDialog,
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_currentTab == 0) {
                ref.read(adbControllerProvider.notifier).refreshDevices();
              } else {
                ref.read(iosControllerProvider.notifier).refreshDevices();
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.android), text: 'Android'),
            Tab(icon: Icon(Icons.phone_iphone), text: 'iOS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAndroidTab(adbState, theme),
          _buildIosTab(iosState, theme),
        ],
      ),
      floatingActionButton: _currentTab == 0
          ? _buildAndroidFabs(adbState)
          : _buildIosFabs(iosState),
    );
  }

  // ─── Android tab ───────────────────────────────────────────────────────────

  Widget _buildAndroidTab(AdbState adbState, ThemeData theme) {
    return Column(
      children: [
        if (adbState.error != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: theme.colorScheme.errorContainer,
            child: Text(
              adbState.error!,
              style: TextStyle(color: theme.colorScheme.onErrorContainer),
            ),
          ),
        if (adbState.lastCommandOutput != null && adbState.lastCommandOutput!.isNotEmpty)
          _CommandOutputBanner(
            output: adbState.lastCommandOutput!,
            onDismiss: () => ref.read(adbControllerProvider.notifier).refreshDevices(),
            theme: theme,
          ),
        Expanded(
          child: adbState.isLoading && adbState.devices.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : adbState.devices.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone_android, size: 64, color: theme.colorScheme.outline),
                          const SizedBox(height: 16),
                          Text(
                            'No Android devices connected',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Connect via USB or use wireless pairing',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: _showPairDialog,
                            icon: const Icon(Icons.wifi),
                            label: const Text('Wireless Pair'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () =>
                          ref.read(adbControllerProvider.notifier).refreshDevices(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: adbState.devices.length,
                        itemBuilder: (context, index) {
                          final device = adbState.devices[index];
                          final isSelected = _selectedAndroidDeviceId == device.id;
                          return _AndroidDeviceCard(
                            device: device,
                            isSelected: isSelected,
                            onTap: () => setState(() {
                              _selectedAndroidDeviceId = isSelected ? null : device.id;
                            }),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  Widget? _buildAndroidFabs(AdbState adbState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (Platform.isAndroid)
          FloatingActionButton.small(
            heroTag: 'local_install',
            onPressed: _showLocalInstallDialog,
            tooltip: 'Download & Install on this device',
            child: const Icon(Icons.download),
          ),
        if (Platform.isAndroid && adbState.devices.isNotEmpty) const SizedBox(height: 8),
        if (adbState.devices.isNotEmpty) ...[
          FloatingActionButton.small(
            heroTag: 'install',
            onPressed: _showInstallDialog,
            tooltip: 'Install APK via ADB',
            child: const Icon(Icons.install_mobile),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'launch',
            onPressed: _showLaunchDialog,
            tooltip: 'Launch App',
            child: const Icon(Icons.play_arrow),
          ),
        ],
      ],
    );
  }

  // ─── iOS tab ───────────────────────────────────────────────────────────────

  Widget _buildIosTab(IosState iosState, ThemeData theme) {
    return Column(
      children: [
        if (iosState.error != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: theme.colorScheme.errorContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  iosState.error!,
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
                if (iosState.error!.contains('No iOS tools'))
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Install Xcode: xcode-select --install\nInstall ios-deploy: npm install -g ios-deploy',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
              ],
            ),
          ),
        if (iosState.lastCommandOutput != null && iosState.lastCommandOutput!.isNotEmpty)
          _CommandOutputBanner(
            output: iosState.lastCommandOutput!,
            onDismiss: () => ref.read(iosControllerProvider.notifier).refreshDevices(),
            theme: theme,
          ),
        Expanded(
          child: iosState.isLoading && iosState.devices.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : iosState.devices.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone_iphone, size: 64, color: theme.colorScheme.outline),
                          const SizedBox(height: 16),
                          Text(
                            'No iOS devices detected',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Connect an iPhone/iPad via USB\nRequires macOS host with Xcode or ios-deploy',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: () => ref.read(iosControllerProvider.notifier).refreshDevices(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () =>
                          ref.read(iosControllerProvider.notifier).refreshDevices(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: iosState.devices.length,
                        itemBuilder: (context, index) {
                          final device = iosState.devices[index];
                          final isSelected = _selectedIosDeviceId == device.udid;
                          return _IosDeviceCard(
                            device: device,
                            isSelected: isSelected,
                            onTap: () => setState(() {
                              _selectedIosDeviceId = isSelected ? null : device.udid;
                            }),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  Widget? _buildIosFabs(IosState iosState) {
    if (iosState.devices.isEmpty) return null;
    return FloatingActionButton.small(
      heroTag: 'ios_install',
      onPressed: _showIpaInstallDialog,
      tooltip: 'Install IPA via ios-deploy',
      child: const Icon(Icons.install_mobile),
    );
  }
}

// ─── Shared widgets ────────────────────────────────────────────────────────────

class _CommandOutputBanner extends StatelessWidget {
  final String output;
  final VoidCallback onDismiss;
  final ThemeData theme;

  const _CommandOutputBanner({
    required this.output,
    required this.onDismiss,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Last output:', style: theme.textTheme.labelSmall),
              const Spacer(),
              InkWell(
                onTap: onDismiss,
                child: Icon(Icons.close, size: 16, color: theme.colorScheme.outline),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            output,
            style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }
}

// ─── Android device card ───────────────────────────────────────────────────────

class _AndroidDeviceCard extends StatelessWidget {
  final AdbDevice device;
  final bool isSelected;
  final VoidCallback onTap;

  const _AndroidDeviceCard({
    required this.device,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOnline = device.isOnline;

    return Card(
      elevation: isSelected ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: isSelected
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.zero,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.phone_android,
                color: isOnline ? Colors.green : Colors.orange,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(device.displayName, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(
                      device.id,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOnline
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.zero,
                ),
                child: Text(
                  device.state,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isOnline ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── iOS device card ───────────────────────────────────────────────────────────

class _IosDeviceCard extends StatelessWidget {
  final IosDevice device;
  final bool isSelected;
  final VoidCallback onTap;

  const _IosDeviceCard({
    required this.device,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: isSelected ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: isSelected
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.zero,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                device.isPhysical ? Icons.phone_iphone : Icons.tablet_mac,
                color: device.isPhysical ? Colors.blue : Colors.blueGrey,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(device.displayName, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(
                      device.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      device.udid,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        color: theme.colorScheme.outline,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: device.isPhysical
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.blueGrey.withOpacity(0.1),
                  borderRadius: BorderRadius.zero,
                ),
                child: Text(
                  device.isPhysical ? 'Device' : 'Simulator',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: device.isPhysical ? Colors.blue : Colors.blueGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Generic dialog that auto-searches for package files (APK or IPA) in the
/// workspace and lets the user pick one or enter a path manually.
class _PackagePickerDialog extends StatefulWidget {
  final String title;
  final String actionLabel;
  final WidgetRef ref;
  final String filePattern;
  final IconData fileIcon;
  final String fileTypeLabel;
  final TextEditingController manualPathController;
  final Future<void> Function(String filePath) onFileSelected;

  const _PackagePickerDialog({
    required this.title,
    required this.actionLabel,
    required this.ref,
    required this.filePattern,
    required this.fileIcon,
    required this.fileTypeLabel,
    required this.manualPathController,
    required this.onFileSelected,
  });

  @override
  State<_PackagePickerDialog> createState() => _PackagePickerDialogState();
}

class _PackagePickerDialogState extends State<_PackagePickerDialog> {
  List<SearchResultFile>? _files;
  bool _isSearching = true;
  String? _searchError;
  String? _selectedPath;

  @override
  void initState() {
    super.initState();
    _searchForFiles();
  }

  Future<void> _searchForFiles() async {
    try {
      final repo = widget.ref.read(remoteRepositoryProvider);
      final workspaceAsync = widget.ref.read(currentWorkspaceProvider);
      final workspaceId = workspaceAsync.valueOrNull?.sharedId;

      if (kDebugMode) {
        debugPrint('[PackagePicker] Searching for ${widget.filePattern}, workspaceId=$workspaceId');
      }

      final results = await repo.searchFiles(
        widget.filePattern,
        maxResults: 50,
        workspaceId: workspaceId,
      );

      if (kDebugMode) {
        debugPrint('[PackagePicker] Found ${results.length} ${widget.fileTypeLabel} files');
        for (final f in results) {
          debugPrint('[PackagePicker]   ${f.relativePath} (${f.sizeFormatted})');
        }
        if (results.isEmpty) {
          debugPrint('[PackagePicker] No files found — check that the workspace directory contains built ${widget.fileTypeLabel} files');
        }
      }

      if (mounted) {
        setState(() {
          _files = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[PackagePicker] Error searching for ${widget.fileTypeLabel}: $e');
      }
      if (mounted) {
        setState(() {
          _searchError = e.toString();
          _isSearching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('${widget.fileTypeLabel}s in workspace:', style: theme.textTheme.labelMedium),
                const Spacer(),
                if (!_isSearching)
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 18),
                    tooltip: 'Re-search',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                        _searchError = null;
                        _files = null;
                      });
                      _searchForFiles();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),

            if (_isSearching)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_searchError != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Search failed: $_searchError',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                ),
              )
            else if (_files != null && _files!.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'No ${widget.fileTypeLabel} files found in workspace.\nEnter the path manually below.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                  ),
                ),
              )
            else if (_files != null)
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _files!.length,
                  itemBuilder: (context, index) {
                    final file = _files![index];
                    final isSelected = _selectedPath == file.relativePath;
                    return ListTile(
                      dense: true,
                      selected: isSelected,
                      selectedTileColor: theme.colorScheme.primaryContainer,
                      leading: Icon(widget.fileIcon, size: 20),
                      title: Text(
                        file.name,
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${file.relativePath}  (${file.sizeFormatted})',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedPath = file.relativePath;
                          widget.manualPathController.text = file.relativePath;
                        });
                      },
                    );
                  },
                ),
              ),

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),

            TextField(
              controller: widget.manualPathController,
              decoration: InputDecoration(
                labelText: 'Or enter path manually',
                hintText: widget.filePattern == '*.apk'
                    ? 'build/app/outputs/flutter-apk/app-release.apk'
                    : 'build/ios/ipa/Runner.ipa',
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (_) => setState(() => _selectedPath = null),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final path = _selectedPath ?? widget.manualPathController.text.trim();
            if (path.isEmpty) return;
            Navigator.pop(context);
            widget.onFileSelected(path);
          },
          child: Text(widget.actionLabel),
        ),
      ],
    );
  }
}

// ─── Download progress helpers ────────────────────────────────────────────────

@immutable
class _DownloadProgress {
  final int received;
  final int total;

  const _DownloadProgress({this.received = 0, this.total = 0});

  double get fraction => total > 0 ? (received / total).clamp(0.0, 1.0) : 0.0;
  bool get isIndeterminate => total <= 0;

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get receivedLabel => _formatBytes(received);
  String get totalLabel => _formatBytes(total);
  String get percentLabel => isIndeterminate ? '' : '${(fraction * 100).toStringAsFixed(0)}%';
}

class _DownloadProgressDialog extends StatelessWidget {
  final String fileName;
  final ValueNotifier<_DownloadProgress> progress;

  const _DownloadProgressDialog({
    required this.fileName,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.download_rounded, size: 20),
          SizedBox(width: 8),
          Text('Downloading'),
        ],
      ),
      content: ValueListenableBuilder<_DownloadProgress>(
        valueListenable: progress,
        builder: (context, value, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fileName,
                style: theme.textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: value.isIndeterminate ? null : value.fraction,
                minHeight: 6,
                borderRadius: BorderRadius.zero,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value.isIndeterminate
                        ? value.received > 0
                            ? 'Downloaded ${value.receivedLabel}…'
                            : 'Starting download…'
                        : '${value.receivedLabel} / ${value.totalLabel}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (!value.isIndeterminate)
                    Text(
                      value.percentLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
