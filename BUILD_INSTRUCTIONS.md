# FrameCut — Build & Install Instructions

## Overview

FrameCut is a native Android video editing app built with Flutter. It includes **60+ professional editing features** powered by `pro_video_editor` and `ffmpeg_kit_flutter_new`.

---

## Prerequisites

### 1. Install Flutter SDK (3.24+)

```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

Or download from: https://docs.flutter.dev/get-started/install/linux

### 2. Install Android Studio

- Download from: https://developer.android.com/studio
- During setup, install:
  - Android SDK (API 34 recommended)
  - Android SDK Build-Tools
  - NDK (27.0.12077973)
  - CMake

### 3. Install Java 17

```bash
sudo apt-get install openjdk-17-jdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
```

### 4. Accept Android Licenses

```bash
flutter doctor --android-licenses
# Type 'y' and press Enter for all
```

---

## Build the APK

### Step 1: Get Dependencies

```bash
cd framecut
flutter pub get
```

### Step 2: Build Debug APK (for testing)

```bash
flutter build apk --debug
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

### Step 3: Build Release APK

```bash
# Split by ABI (smaller files, recommended)
flutter build apk --release --split-per-abi

# Or single fat APK (works on all devices)
flutter build apk --release
```

Release APK outputs:
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` — Modern phones (ARM64)
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk` — Older phones (ARM32)
- `build/app/outputs/flutter-apk/app-x86_64-release.apk` — Emulators

### Step 4: Install on Android Device

**Via USB (ADB):**
```bash
# Enable "Developer Options" + "USB Debugging" on your phone
adb devices                          # verify device is connected
adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

**Via file transfer:**
1. Copy the `.apk` to your phone
2. Open it in Files app
3. If prompted, enable "Install from Unknown Sources" in Settings → Security

---

## Run in Development Mode

```bash
# List connected devices
flutter devices

# Run on connected Android device
flutter run

# Run on specific device
flutter run -d <device-id>

# Hot reload is available — press 'r' in terminal
```

---

## Build App Bundle (for Google Play)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

---

## Common Issues

### Issue: NDK version mismatch
```bash
# In android/app/build.gradle, ensure:
ndkVersion "27.0.12077973"
```

### Issue: Java version error
```bash
# Set Java 17 explicitly
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
./gradlew build
```

### Issue: FFmpeg build takes long
FFmpeg is compiled natively — the first build will take 5-10 minutes. Subsequent builds are cached.

### Issue: minSdk version error
The app requires Android API 24+ (Android 7.0+). This is required by `ffmpeg_kit_flutter_new`.

### Issue: "Installed build tools revision 34.x.x is corrupted"
```bash
# Reinstall build tools in Android Studio
# SDK Manager → SDK Tools → Android SDK Build-Tools
```

---

## App Configuration

### App ID
`com.framecut.app`

### Minimum Android Version
Android 7.0 (API 24)

### Target Android Version  
Android 14 (API 34)

### Permissions Required
- Read Media / Videos (pick videos to edit)
- Record Audio (voiceover recording)
- Camera (optional: record video directly)
- Vibrate (haptic feedback)
- Post Notifications (export completion)

---

## Features Included

1. Trim & Cut
2. Video Filters (9 presets)
3. Text & Titles
4. Audio & Music
5. Transitions (8 types)
6. Speed Control (0.25x–8x)
7. Crop & Rotate
8. Color Grading (6 parameters)
9. Stickers & Emoji
10. Voiceover Recording
11. LUT Color Grading
12. HSL Selective Color
13. Curves Editor
14. Vignette
15. Film Grain & Noise
16. Chromatic Aberration
17. Glow & Bloom
18. Sharpen & Clarity
19. Dehaze / Defog
20. Spotlight Effect
21. Color Match
22. Keyframe Animation
23. Chroma Key (Green Screen)
24. Motion Blur
25. Video Stabilization
26. Reverse Clip
27. Freeze Frame
28. Picture-in-Picture
29. Split Screen
30. Audio Equalizer (5-band)
31. Noise Reduction
32. Pitch Shift
33. Beat Detection
34. Sound Effects Library
35. Animated Text Presets
36. Lower Thirds
37. Subtitles & Captions
38. Drawing & Annotation
39. Watermark / Logo
40. Ken Burns Effect
41. Camera Shake Effect
42. Glitch Effect
43. Slow-Motion Ramp
44. Multi-Clip Merge
45. Clip Reverse
46. Ripple Edit
47. Export Presets (Instagram, TikTok, YouTube, etc.)
48. GIF Export
49. 4K Export
50. Frame Rate Selection
51. Burn Subtitles to Video
52. Project Templates Gallery
53. Undo / Redo (50-step history)
54. Auto-Save every 30 seconds
55. Dark Mode
56. Haptic Feedback
57. Video Waveform Display
58. Timeline Zoom
59. Multi-track Timeline
60. Project Search & Sort

---

## Tech Stack

| Library | Purpose |
|---------|---------|
| `flutter` 3.24+ | UI framework, compiles to native Android |
| `pro_video_editor ^2.5.1` | Core video rendering, merge, transitions, filters |
| `ffmpeg_kit_flutter_new ^4.3.2` | Advanced FFmpeg: chroma key, stabilization, LUT, EQ |
| `video_player ^2.9.1` | In-editor playback preview |
| `flutter_riverpod ^2.6.1` | State management |
| `hive_flutter ^1.1.0` | Local project storage |
| `go_router ^14.6.2` | Navigation |
| `google_fonts ^6.2.1` | DM Sans typography |
| `share_plus ^10.1.2` | Export sharing |

---

*Built with ❤️ using Flutter*
