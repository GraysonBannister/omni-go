# Omni Go

Omni Go is a Flutter mobile app that serves as a remote client for the Omni Code AI assistant. Connect to your Omni Code desktop instance and interact with AI-powered coding assistance from your mobile device.

## Features

- **AI Chat Interface** - Chat with Omni Code's AI assistant on the go
- **Image Attachments** - Share screenshots and images with the AI
- **Terminal Access** - View and interact with terminal sessions remotely
- **File Management** - Browse files and git status in your workspaces
- **APK/APP Installation** - Build and install Android apps directly from the desktop
- **Browser Access** - Access proxied localhost services from your phone
- **iOS Device Support** - Connect to iOS devices for development

## Prerequisites

Before using Omni Go, you need:

1. **Omni Code Desktop** - Running on your computer ([github.com/GraysonBannister/omni-code](https://github.com/GraysonBannister/omni-code))
2. **Network Connection** - Your phone and computer must be on the same network (or use Cloudflare tunnel)
3. **API Key** - From your Omni Code desktop settings

## Installation

### From GitHub (Build Yourself)

#### Option 1: Install Debug APK (Recommended for Testing)

```bash
# Clone the repository
git clone https://github.com/GraysonBannister/omni-go.git
cd omni-go

# Build debug APK
flutter build apk --debug

# Install to connected Android device
flutter install
# OR manually:
adb install build/app/outputs/flutter-apk/app-debug.apk
```

#### Option 2: Build Release APK

```bash
# Build release APK (signed with debug key)
flutter build apk --release

# APK location: build/app/outputs/flutter-apk/app-release.apk
```

#### Option 3: Build App Bundle (For Play Store)

```bash
# Build release AAB (requires signing keystore)
flutter build appbundle --release

# AAB location: build/app/outputs/bundle/release/app-release.aab
```

### iOS Installation

#### Build for iOS Physical Device (macOS + Xcode required)

**Prerequisites:**
- macOS with Xcode 14+ installed
- Valid Apple Developer account (free or paid)
- iOS device connected via USB

**Steps:**

```bash
# Clone and setup
git clone https://github.com/GraysonBannister/omni-go.git
cd omni-go

# Install dependencies
flutter pub get

# Build for iOS (device only - simulator not supported due to MLKit)
flutter build ios --release

# The build produces an IPA-compatible app bundle at:
# build/ios/iphoneos/Runner.app
```

**Install to Device:**

**Option A: Via Xcode (Easiest)**
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select your connected iPhone/iPad as the target
3. Go to Signing & Capabilities → Select your team
4. Click Product → Run

**Option B: Via Command Line**
```bash
# Install using ios-deploy (if installed)
ios-deploy --bundle build/ios/iphoneos/Runner.app

# Or use Xcode command line tools
xcrun simctl install booted build/ios/iphoneos/Runner.app
```

**Option C: Create IPA for Distribution**
```bash
# Build archive for App Store or ad-hoc distribution
flutter build ipa --release

# IPA location: build/ios/ipa/omni_go.ipa
# Use Apple Configurator or AltStore to install IPA to device
```

#### Important: iOS Simulator Limitation

**Note:** Omni Go cannot run on the iOS Simulator due to the `mobile_scanner` plugin's dependency on Google MLKit, which doesn't support Apple Silicon simulator architecture.

**Workarounds:**
- Use a **physical iOS device** for testing
- Use the **Android emulator** for UI testing
- Test scanning features on a real device only

#### Troubleshooting iOS Build

| Issue | Solution |
|-------|----------|
| "Could not find Developer Disk Image" | Update Xcode or download device support files |
| "Signing for 'Runner' requires a development team" | Select your Apple ID team in Xcode → Signing & Capabilities |
| "Unable to install - application signature invalid" | Trust the developer in Settings → General → VPN & Device Management |
| Build fails with MLKit errors | Ensure you're building for **device**, not simulator |

### Prerequisites for Building

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.0.0+)
- [Android Studio](https://developer.android.com/studio) with Android SDK
- For iOS: Xcode 14+ and macOS (physical device only, simulator not supported)

### Configure Signing (For Release)

1. Create a signing keystore:
```bash
keytool -genkeypair \
  -v \
  -keystore android/app/omni-go-release.jks \
  -alias omni-go-key \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

2. Create `android/key.properties`:
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=omni-go-key
storeFile=omni-go-release.jks
```

## Setup & Usage

### 1. Start Omni Code Desktop

Launch Omni Code on your computer and ensure remote access is enabled:
- Go to Settings → Remote Access
- Enable "Allow Remote Connections"
- Copy your API Key

### 2. Get Connection URL

Your connection URL will be displayed in Omni Code settings:
- **Local Network**: `http://YOUR_COMPUTER_IP:3000`
- **Cloudflare Tunnel**: `https://your-app.trycloudflare.com` (recommended for remote access)

### 3. Connect Omni Go

1. Open Omni Go app
2. Tap "Connect to Server"
3. Enter your connection URL
4. Enter your API Key
5. Tap "Connect"

### 4. Start Using

- **Chat** - Start a conversation and chat with the AI
- **Files** - Browse your project files
- **Devices** - Manage connected Android/iOS devices
- **Browser** - Access proxied localhost services

## Troubleshooting

### Connection Issues

- **"Unable to connect"** - Check that your phone and computer are on the same network
- **"Invalid request signature"** - Ensure your API key matches exactly (copy/paste from settings)
- **"Connection refused"** - Check that Omni Code desktop is running and remote access is enabled

### Build Issues

| Issue | Solution |
|-------|----------|
| **Gradle build fails** | Run `flutter clean` and try again |
| **iOS simulator build fails** | This is expected (mobile_scanner plugin limitation). Use a physical device. |
| **iOS device build fails with MLKit errors** | Omni Go requires a physical iOS device. Simulator is not supported. |
| **ADB not found** | Ensure Android SDK is installed and `ANDROID_HOME` is set |
| **iOS signing errors** | Open Xcode, select your Apple ID in Signing & Capabilities |
| **"Could not find Developer Disk Image"** | Update Xcode to the latest version |

### Development

```bash
# Run in debug mode
flutter run

# Run on specific device
flutter run -d <device-id>

# Check connected devices
flutter devices

# Clean build cache
flutter clean
```

## Architecture

Omni Go uses:
- **Flutter** - Cross-platform UI framework
- **Dio** - HTTP client for API requests
- **SSE (Server-Sent Events)** - Real-time event streaming
- **HMAC Signatures** - Request authentication
- **Riverpod** - State management

## Related Projects

- [Omni Code](https://github.com/GraysonBannister/omni-code) - Desktop AI coding assistant
- [Omni Code Website](https://github.com/GraysonBannister/omni-code-website) - Landing page and docs

## License

MIT License - See LICENSE file for details

---

**Need Help?** Open an issue on GitHub or check the Omni Code documentation.
