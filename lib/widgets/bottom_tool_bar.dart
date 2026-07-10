import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import '../app/theme.dart';
import '../providers/editor_provider.dart';

class ToolItem {
  final ActiveTool tool;
  final IconData icon;
  final String label;
  const ToolItem(this.tool, this.icon, this.label);
}

class BottomToolBar extends StatelessWidget {
  final ActiveTool activeTool;
  final ValueChanged<ActiveTool> onToolSelected;

  const BottomToolBar({
    super.key,
    required this.activeTool,
    required this.onToolSelected,
  });

  static const _tools = [
    ToolItem(ActiveTool.trim,      Icons.content_cut_rounded,       'Trim'),
    ToolItem(ActiveTool.filters,   Icons.auto_awesome_rounded,      'Filters'),
    ToolItem(ActiveTool.text,      Icons.title_rounded,             'Text'),
    ToolItem(ActiveTool.audio,     Icons.music_note_rounded,        'Audio'),
    ToolItem(ActiveTool.transitions, Icons.compare_arrows_rounded,  'Trans'),
    ToolItem(ActiveTool.speed,     Icons.speed_rounded,             'Speed'),
    ToolItem(ActiveTool.crop,      Icons.crop_rounded,              'Crop'),
    ToolItem(ActiveTool.colorGrading, Icons.tune_rounded,           'Color'),
    ToolItem(ActiveTool.stickers,  Icons.emoji_emotions_outlined,   'Stickers'),
    ToolItem(ActiveTool.voiceover, Icons.mic_rounded,               'Voice'),
    ToolItem(ActiveTool.lut,       Icons.gradient_rounded,          'LUT'),
    ToolItem(ActiveTool.hsl,       Icons.palette_rounded,           'HSL'),
    ToolItem(ActiveTool.curves,    Icons.show_chart_rounded,        'Curves'),
    ToolItem(ActiveTool.vignette,  Icons.vignette_rounded,          'Vignette'),
    ToolItem(ActiveTool.grain,     Icons.grain_rounded,             'Grain'),
    ToolItem(ActiveTool.chromaticAberration, Icons.lens_blur_rounded, 'Aberr'),
    ToolItem(ActiveTool.glow,      Icons.flare_rounded,             'Glow'),
    ToolItem(ActiveTool.sharpen,   Icons.texture_rounded,           'Sharpen'),
    ToolItem(ActiveTool.dehaze,    Icons.cloud_off_rounded,         'Dehaze'),
    ToolItem(ActiveTool.spotlight, Icons.highlight_rounded,         'Spot'),
    ToolItem(ActiveTool.colorMatch, Icons.colorize_rounded,         'Match'),
    ToolItem(ActiveTool.keyframe,  Icons.linear_scale_rounded,      'Keys'),
    ToolItem(ActiveTool.chromaKey, Icons.layers_clear_rounded,      'Chroma'),
    ToolItem(ActiveTool.motionBlur, Icons.motion_blur_rounded,      'Blur'),
    ToolItem(ActiveTool.stabilize, Icons.stabilization_rounded,     'Stable'),
    ToolItem(ActiveTool.reverse,   Icons.fast_rewind_rounded,       'Reverse'),
    ToolItem(ActiveTool.freezeFrame, Icons.pause_circle_rounded,    'Freeze'),
    ToolItem(ActiveTool.pip,       Icons.picture_in_picture_rounded,'PIP'),
    ToolItem(ActiveTool.splitScreen, Icons.grid_view_rounded,       'Split'),
    ToolItem(ActiveTool.equalizer, Icons.equalizer_rounded,         'EQ'),
    ToolItem(ActiveTool.noiseReduction, Icons.hearing_disabled_rounded,'Denoise'),
    ToolItem(ActiveTool.pitch,     Icons.music_note_rounded,        'Pitch'),
    ToolItem(ActiveTool.beatDetection, Icons.graphic_eq_rounded,    'Beat'),
    ToolItem(ActiveTool.sfx,       Icons.surround_sound_rounded,    'SFX'),
    ToolItem(ActiveTool.animatedText, Icons.animation_rounded,      'AnimText'),
    ToolItem(ActiveTool.lowerThirds, Icons.subtitles_rounded,       'Lower3'),
    ToolItem(ActiveTool.subtitles, Icons.closed_caption_rounded,    'Subs'),
    ToolItem(ActiveTool.drawing,   Icons.brush_rounded,             'Draw'),
    ToolItem(ActiveTool.watermark, Icons.branding_watermark_rounded,'Wmark'),
    ToolItem(ActiveTool.kenBurns,  Icons.zoom_in_map_rounded,       'KenBurns'),
    ToolItem(ActiveTool.shake,     Icons.vibration_rounded,         'Shake'),
    ToolItem(ActiveTool.glitch,    Icons.broken_image_rounded,      'Glitch'),
    ToolItem(ActiveTool.slowMoRamp, Icons.slow_motion_video_rounded,'S-Ramp'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      color: AppTheme.timelineBackground,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _tools.length,
        itemBuilder: (context, i) {
          final tool = _tools[i];
          final isActive = activeTool == tool.tool;
          return _ToolButton(
            item: tool,
            isActive: isActive,
            onTap: () async {
              await HapticFeedback.selectionClick();
              onToolSelected(tool.tool);
            },
          );
        },
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final ToolItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _ToolButton({required this.item, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              size: 20,
              color: isActive ? AppTheme.primary : Colors.white60,
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: isActive ? AppTheme.primary : Colors.white54,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
