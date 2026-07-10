# FrameCut ProGuard rules

# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# FFmpeg
-keep class com.arthenica.ffmpegkit.** { *; }
-keep class com.antonkarpenko.ffmpeg_kit_flutter_new.** { *; }

# pro_video_editor
-keep class ch.waio.pro_video_editor.** { *; }

# Hive
-keep class com.hive.** { *; }
-keepattributes *Annotation*

# General
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
