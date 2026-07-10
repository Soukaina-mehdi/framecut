import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import '../../app/theme.dart';
import '../../providers/editor_provider.dart';
import '../../widgets/bottom_tool_bar.dart';
import 'video_preview.dart';
import 'editor_toolbar.dart';
import 'timeline/timeline_widget.dart';
import 'tools/trim_tool.dart';
import 'tools/filters_tool.dart';
import 'tools/text_tool.dart';
import 'tools/audio_tool.dart';
import 'tools/transitions_tool.dart';
import 'tools/speed_tool.dart';
import 'tools/crop_rotate_tool.dart';
import 'tools/color_grading_tool.dart';
import 'tools/stickers_tool.dart';
import 'tools/voiceover_tool.dart';
import 'tools/lut_tool.dart';
import 'tools/hsl_tool.dart';
import 'tools/curves_tool.dart';
import 'tools/vignette_tool.dart';
import 'tools/grain_tool.dart';
import 'tools/chromatic_aberration_tool.dart';
import 'tools/glow_tool.dart';
import 'tools/sharpen_tool.dart';
import 'tools/dehaze_tool.dart';
import 'tools/spotlight_tool.dart';
import 'tools/color_match_tool.dart';
import 'tools/keyframe_tool.dart';
import 'tools/chroma_key_tool.dart';
import 'tools/motion_blur_tool.dart';
import 'tools/stabilize_tool.dart';
import 'tools/reverse_tool.dart';
import 'tools/freeze_frame_tool.dart';
import 'tools/pip_tool.dart';
import 'tools/split_screen_tool.dart';
import 'tools/equalizer_tool.dart';
import 'tools/noise_reduction_tool.dart';
import 'tools/pitch_tool.dart';
import 'tools/beat_detection_tool.dart';
import 'tools/sfx_tool.dart';
import 'tools/animated_text_tool.dart';
import 'tools/lower_thirds_tool.dart';
import 'tools/subtitles_tool.dart';
import 'tools/drawing_tool.dart';
import 'tools/watermark_tool.dart';
import 'tools/ken_burns_tool.dart';
import 'tools/shake_tool.dart';
import 'tools/glitch_tool.dart';
import 'tools/slow_mo_ramp_tool.dart';

class EditorScreen extends ConsumerWidget {
  final String projectId;
  const EditorScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(editorProvider);
    if (editorState.project == null) {
      return const Scaffold(
        backgroundColor: AppTheme.timelineBackground,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.timelineBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top toolbar
            EditorToolbar(projectId: projectId),
            // Video preview
            const Expanded(flex: 4, child: VideoPreview()),
            // Timeline
            const SizedBox(
              height: 120,
              child: TimelineWidget(),
            ),
            // Tool panels
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: editorState.activeTool != ActiveTool.none ? 220 : 0,
              curve: Curves.easeInOut,
              child: editorState.activeTool != ActiveTool.none
                  ? _buildToolPanel(context, ref, editorState.activeTool)
                  : const SizedBox.shrink(),
            ),
            // Bottom tool bar
            BottomToolBar(
              activeTool: editorState.activeTool,
              onToolSelected: (tool) {
                ref.read(editorProvider.notifier).setActiveTool(tool);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolPanel(BuildContext context, WidgetRef ref, ActiveTool tool) {
    switch (tool) {
      case ActiveTool.trim:           return const TrimTool();
      case ActiveTool.filters:        return const FiltersTool();
      case ActiveTool.text:           return const TextTool();
      case ActiveTool.audio:          return const AudioTool();
      case ActiveTool.transitions:    return const TransitionsTool();
      case ActiveTool.speed:          return const SpeedTool();
      case ActiveTool.crop:           return const CropRotateTool();
      case ActiveTool.colorGrading:   return const ColorGradingTool();
      case ActiveTool.stickers:       return const StickersTool();
      case ActiveTool.voiceover:      return const VoiceoverTool();
      case ActiveTool.lut:            return const LutTool();
      case ActiveTool.hsl:            return const HslTool();
      case ActiveTool.curves:         return const CurvesTool();
      case ActiveTool.vignette:       return const VignetteTool();
      case ActiveTool.grain:          return const GrainTool();
      case ActiveTool.chromaticAberration: return const ChromaticAberrationTool();
      case ActiveTool.glow:           return const GlowTool();
      case ActiveTool.sharpen:        return const SharpenTool();
      case ActiveTool.dehaze:         return const DehazeTool();
      case ActiveTool.spotlight:      return const SpotlightTool();
      case ActiveTool.colorMatch:     return const ColorMatchTool();
      case ActiveTool.keyframe:       return const KeyframeTool();
      case ActiveTool.chromaKey:      return const ChromaKeyTool();
      case ActiveTool.motionBlur:     return const MotionBlurTool();
      case ActiveTool.stabilize:      return const StabilizeTool();
      case ActiveTool.reverse:        return const ReverseTool();
      case ActiveTool.freezeFrame:    return const FreezeFrameTool();
      case ActiveTool.pip:            return const PipTool();
      case ActiveTool.splitScreen:    return const SplitScreenTool();
      case ActiveTool.equalizer:      return const EqualizerTool();
      case ActiveTool.noiseReduction: return const NoiseReductionTool();
      case ActiveTool.pitch:          return const PitchTool();
      case ActiveTool.beatDetection:  return const BeatDetectionTool();
      case ActiveTool.sfx:            return const SfxTool();
      case ActiveTool.animatedText:   return const AnimatedTextTool();
      case ActiveTool.lowerThirds:    return const LowerThirdsTool();
      case ActiveTool.subtitles:      return const SubtitlesTool();
      case ActiveTool.drawing:        return const DrawingTool();
      case ActiveTool.watermark:      return const WatermarkTool();
      case ActiveTool.kenBurns:       return const KenBurnsTool();
      case ActiveTool.shake:          return const ShakeTool();
      case ActiveTool.glitch:         return const GlitchTool();
      case ActiveTool.slowMoRamp:     return const SlowMoRampTool();
      default:                        return const SizedBox.shrink();
    }
  }
}
