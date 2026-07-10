import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FfmpegService {
  static final FfmpegService _instance = FfmpegService._internal();
  factory FfmpegService() => _instance;
  FfmpegService._internal();

  Future<String?> _tempPath(String name) async {
    final dir = await getTemporaryDirectory();
    return '${dir.path}/$name';
  }

  Future<bool> _run(String command) async {
    final session = await FFmpegKit.execute(command);
    final rc = await session.getReturnCode();
    return ReturnCode.isSuccess(rc);
  }

  // ── Chroma Key (Green Screen) ─────────────────────────────────────────
  Future<String?> applyChromaKey({
    required String inputPath,
    required String color, // hex e.g. '00FF00'
    required double similarity,
    required double blend,
  }) async {
    final out = await _tempPath('chroma_${DateTime.now().millisecondsSinceEpoch}.mp4');
    final cmd = '-i "$inputPath" -vf "chromakey=0x$color:$similarity:$blend" -c:a copy "$out"';
    return await _run(cmd) ? out : null;
  }

  // ── Vignette ──────────────────────────────────────────────────────────
  Future<String?> applyVignette({
    required String inputPath,
    required double intensity,
    required double angle,
  }) async {
    final out = await _tempPath('vignette_${DateTime.now().millisecondsSinceEpoch}.mp4');
    final cmd = '-i "$inputPath" -vf "vignette=angle=${angle * 3.14159}:mode=backward" -c:a copy "$out"';
    return await _run(cmd) ? out : null;
  }

  // ── Grain / Noise ─────────────────────────────────────────────────────
  Future<String?> applyGrain({
    required String inputPath,
    required double strength,
    required bool color,
  }) async {
    final out = await _tempPath('grain_${DateTime.now().millisecondsSinceEpoch}.mp4');
    final allf = color ? 1 : 0;
    final cmd = '-i "$inputPath" -vf "noise=alls=${(strength * 50).toInt()}:allf=$allf+temporal" -c:a copy "$out"';
    return await _run(cmd) ? out : null;
  }

  // ── Chromatic Aberration ──────────────────────────────────────────────
  Future<String?> applyChromaticAberration({
    required String inputPath,
    required double intensity,
  }) async {
    final out = await _tempPath('chroma_ab_${DateTime.now().millisecondsSinceEpoch}.mp4');
    final shift = (intensity * 5).toInt();
    final cmd = '-i "$inputPath" -vf "rgbashift=rh=$shift:gh=0:bh=-$shift" -c:a copy "$out"';
    return await _run(cmd) ? out : null;
  }

  // ── Glow / Bloom ──────────────────────────────────────────────────────
  Future<String?> applyGlow({
    required String inputPath,
    required double radius,
    required double intensity,
  }) async {
    final out = await _tempPath('glow_${DateTime.now().millisecondsSinceEpoch}.mp4');
    final r = (radius * 20).toInt();
    final cmd = '-i "$inputPath" -vf "gblur=sigma=$r,blend=all_mode=screen:all_opacity=${intensity * 0.5}" -c:a copy "$out"';
    return await _run(cmd) ? out : null;
  }

  // ── Sharpen ───────────────────────────────────────────────────────────
  Future<String?> applySharpen({
    required String inputPath,
    required double luma,
    required double chroma,
  }) async {
    final out = await _tempPath('sharpen_${DateTime.now().millisecondsSinceEpoch}.mp4');
    final cmd = '-i "$inputPath" -vf "unsharp=luma_msize_x=5:luma_msize_y=5:luma_amount=$luma:chroma_msize_x=5:chroma_msize_y=5:chroma_amount=$chroma" -c:a copy "$out"';
    return await _run(cmd) ? out : null;
  }

  // ── Motion Blur ───────────────────────────────────────────────────────
  Future<String?> applyMotionBlur({
    required String inputPath,
    required double strength,
  }) async {
    final out = await _tempPath('mblur_${DateTime.now().millisecondsSinceEpoch}.mp4');
    final cmd = '-i "$inputPath" -vf "tblend=all_mode=average,framestep=${(strength * 3 + 1).toInt()}" -c:a copy "$out"';
    return await _run(cmd) ? out : null;
  }

  // ── Video Stabilization (2-pass) ─────────────────────────────────────
  Future<String?> stabilizeVideo({
    required String inputPath,
    required double strength,
  }) async {
    final dir = await getTemporaryDirectory();
    final transforms = '${dir.path}/transforms.trf';
    final out = await _tempPath('stable_${DateTime.now().millisecondsSinceEpoch}.mp4');

    // Pass 1: detect
    final pass1 = '-i "$inputPath" -vf "vidstabdetect=stepsize=6:shakiness=${(strength * 10).toInt()}:accuracy=9:result=$transforms" -f null -';
    if (!await _run(pass1)) return null;

    // Pass 2: transform
    final pass2 = '-i "$inputPath" -vf "vidstabtransform=input=$transforms:zoom=1:smoothing=30,unsharp=5:5:0.8:3:3:0.4" -c:a copy "$out"';
    return await _run(pass2) ? out : null;
  }

  // ── GIF Export ────────────────────────────────────────────────────────
  Future<String?> exportAsGif({
    required String inputPath,
    required int fps,
    required int width,
  }) async {
    final dir = await getTemporaryDirectory();
    final palette = '${dir.path}/palette_${DateTime.now().millisecondsSinceEpoch}.png';
    final out = await _tempPath('export_${DateTime.now().millisecondsSinceEpoch}.gif');

    final pass1 = '-i "$inputPath" -vf "fps=$fps,scale=$width:-1:flags=lanczos,palettegen" "$palette"';
    if (!await _run(pass1)) return null;

    final pass2 = '-i "$inputPath" -i "$palette" -filter_complex "fps=$fps,scale=$width:-1:flags=lanczos[x];[x][1:v]paletteuse" "$out"';
    return await _run(pass2) ? out : null;
  }

  // ── Audio Equalizer (5-band) ─────────────────────────────────────────
  Future<String?> applyEqualizer({
    required String inputPath,
    required List<double> bands, // [bass, lowMid, mid, highMid, treble] in dB
  }) async {
    final out = await _tempPath('eq_${DateTime.now().millisecondsSinceEpoch}.mp4');
    final eqFilters = [
      'equalizer=f=80:width_type=o:width=2:g=${bands[0]}',
      'equalizer=f=250:width_type=o:width=2:g=${bands[1]}',
      'equalizer=f=1000:width_type=o:width=2:g=${bands[2]}',
      'equalizer=f=4000:width_type=o:width=2:g=${bands[3]}',
      'equalizer=f=12000:width_type=o:width=2:g=${bands[4]}',
    ].join(',');
    final cmd = '-i "$inputPath" -af "$eqFilters" -vcodec copy "$out"';
    return await _run(cmd) ? out : null;
  }

  // ── Noise Reduction ───────────────────────────────────────────────────
  Future<String?> applyNoiseReduction({
    required String inputPath,
    required double strength,
  }) async {
    final out = await _tempPath('denoise_${DateTime.now().millisecondsSinceEpoch}.mp4');
    final cmd = '-i "$inputPath" -af "afftdn=nf=${-20 - strength * 40}" -vcodec copy "$out"';
    return await _run(cmd) ? out : null;
  }

  // ── Pitch Shift ───────────────────────────────────────────────────────
  Future<String?> applyPitchShift({
    required String inputPath,
    required double semitones,
  }) async {
    final out = await _tempPath('pitch_${DateTime.now().millisecondsSinceEpoch}.mp4');
    final rate = 44100 * (1.0 + semitones / 12.0);
    final cmd = '-i "$inputPath" -af "asetrate=$rate,aresample=44100,atempo=${1.0 / (1.0 + semitones / 12.0)}" -vcodec copy "$out"';
    return await _run(cmd) ? out : null;
  }

  // ── Glitch Effect ─────────────────────────────────────────────────────
  Future<String?> applyGlitch({
    required String inputPath,
    required double intensity,
  }) async {
    final out = await _tempPath('glitch_${DateTime.now().millisecondsSinceEpoch}.mp4');
    final shift = (intensity * 20).toInt();
    final cmd = '-i "$inputPath" -vf "rgbashift=rh=$shift:gh=-${shift ~/ 2}:bh=0,noise=alls=${(intensity * 30).toInt()}" -c:a copy "$out"';
    return await _run(cmd) ? out : null;
  }

  // ── LUT Apply (.cube) ─────────────────────────────────────────────────
  Future<String?> applyLut({
    required String inputPath,
    required String lutPath,
    required double intensity,
  }) async {
    final out = await _tempPath('lut_${DateTime.now().millisecondsSinceEpoch}.mp4');
    final cmd = '-i "$inputPath" -vf "lut3d=$lutPath:interp=trilinear" -c:a copy "$out"';
    return await _run(cmd) ? out : null;
  }

  // ── Dehaze ────────────────────────────────────────────────────────────
  Future<String?> applyDehaze({
    required String inputPath,
    required double strength,
  }) async {
    final out = await _tempPath('dehaze_${DateTime.now().millisecondsSinceEpoch}.mp4');
    final gamma = 1.0 + strength * 0.5;
    final cmd = '-i "$inputPath" -vf "curves=all=0/0 0.5/${0.5 / gamma} 1/1,unsharp=3:3:${strength * 0.5}" -c:a copy "$out"';
    return await _run(cmd) ? out : null;
  }

  // ── Cleanup temp files ─────────────────────────────────────────────────
  Future<void> cleanupTemp() async {
    final dir = await getTemporaryDirectory();
    final files = dir.listSync().whereType<File>().where((f) =>
        f.path.endsWith('.mp4') || f.path.endsWith('.gif') || f.path.endsWith('.trf'));
    for (final f in files) {
      try { await f.delete(); } catch (_) {}
    }
  }
}
