# QR Code Connection

The QR Code Connection feature allows you to quickly connect your omni-code-go mobile app to your desktop omni-code instance by scanning a QR code, eliminating the need to manually type URLs and API keys.

## How It Works

1. **Desktop generates QR code**: When the remote server is running in omni-code-v2, a QR code containing the connection URL and API key is displayed
2. **Mobile scans QR code**: This app scans the QR code to automatically extract the connection credentials
3. **Auto-connect**: The app automatically connects to the desktop server using the scanned credentials

## Usage

### First-Time Setup

1. Open the omni-code-go app
2. On the connection screen, tap **Scan QR Code**
3. Point your camera at the QR code displayed on your desktop's omni-code app
4. The app will automatically fill in the server URL and API key
5. Tap **Connect** to establish the connection

### Manual Connection (Alternative)

If you prefer not to use QR codes, you can:
1. Enter the server URL manually (e.g., `https://xxx.ngrok.io`)
2. Enter the API key from your desktop app
3. Tap **Connect**

## Getting the QR Code from Desktop

1. On your desktop, open omni-code-v2
2. Go to Settings and navigate to the **Remote** tab
3. Enable Remote Access and start the server
4. Click **Show QR Code** to display the connection code

## QR Code Data Format

The QR code contains a JSON object with:

```json
{
  "url": "https://xxx.ngrok.io",
  "key": "64-character-api-key",
  "name": "Omni Code Desktop"
}
```

## Security

⚠️ **Keep your QR code private!**

- The QR code contains your API key
- Anyone who scans it can connect to your server
- If you suspect someone has scanned your code, regenerate the API key on your desktop

## Troubleshooting

### Camera Won't Open

- Ensure you've granted camera permissions to the app
- On iOS, check Settings > Privacy > Camera
- On Android, check Settings > Apps > omni_go > Permissions

### QR Code Not Scanning

- Make sure the QR code is clearly visible and not blurry
- Hold your phone steady
- Ensure good lighting
- Try moving the phone slightly closer or further from the screen

### Connection Fails After Scanning

- Verify the desktop server is still running
- Check that your mobile device has internet connectivity
- Ensure you're scanning the correct QR code (it may have been regenerated)
- Try restarting both the desktop and mobile apps

## Platform-Specific Setup

### iOS

If you're building this app for iOS, ensure your `ios/Runner/Info.plist` contains:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan QR codes for connecting to the desktop server</string>
```

### Android

No additional configuration needed. Camera permissions are handled automatically.

## Development

### Dependencies

The QR scanning feature uses the `mobile_scanner` package:

```yaml
dependencies:
  mobile_scanner: ^3.5.5
```

### Key Files

- `lib/presentation/screens/qr_scanner_screen.dart` - The QR scanner UI
- `lib/presentation/screens/connect_screen.dart` - Connection screen with scan button
- `lib/presentation/providers/server_provider.dart` - Server connection management

### Scanning Implementation

The scan result handling in `connect_screen.dart`:

```dart
Future<void> _scanQRCode() async {
  final result = await Navigator.of(context).push<Map<String, dynamic>>(
    MaterialPageRoute(builder: (_) => const QRScannerScreen()),
  );

  if (result != null) {
    final url = result['url'] as String?;
    final apiKey = result['apiKey'] as String?;
    // Auto-fill and connect...
  }
}
```
