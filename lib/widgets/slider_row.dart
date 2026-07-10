import 'package:flutter/material.dart';
import '../app/theme.dart';

class SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String? unit;
  final ValueChanged<double> onChanged;
  final bool showValue;

  const SliderRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions = 100,
    this.unit,
    this.showValue = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 82,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.muted,
              ),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: const SliderThemeData(
                activeTrackColor: Colors.white,
                inactiveTrackColor: Color(0xFF333333),
                thumbColor: Colors.white,
                overlayColor: Color(0x1AFFFFFF),
                trackHeight: 2,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: Slider(
                value: value.clamp(min, max),
                min: min,
                max: max,
                divisions: divisions,
                onChanged: onChanged,
              ),
            ),
          ),
          if (showValue)
            SizedBox(
              width: 44,
              child: Text(
                unit != null
                    ? '${value.toStringAsFixed(1)}$unit'
                    : value.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.right,
              ),
            ),
        ],
      ),
    );
  }
}

class LightSliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String? unit;
  final ValueChanged<double> onChanged;

  const LightSliderRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.primary,
              ),
            ),
          ),
          Expanded(
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: 100,
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: 44,
            child: Text(
              unit != null ? '${value.toStringAsFixed(1)}$unit' : value.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.muted,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
