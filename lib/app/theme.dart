import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Minimalism palette
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color primary = Color(0xFF111111);
  static const Color muted = Color(0xFF888888);
  static const Color border = Color(0xFFE5E5E5);
  static const Color accent = Color(0xFF000000);
  static const Color destructive = Color(0xFFDC2626);

  // Dark mode palette
  static const Color darkBackground = Color(0xFF111111);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkPrimary = Color(0xFFFFFFFF);
  static const Color darkMuted = Color(0xFF888888);
  static const Color darkBorder = Color(0xFF2A2A2A);

  // Editor-specific
  static const Color timelineBackground = Color(0xFF0D0D0D);
  static const Color timelineTrack = Color(0xFF1C1C1C);
  static const Color timelineClip = Color(0xFF2D2D2D);
  static const Color playhead = Color(0xFFFFFFFF);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          surface: background,
          primary: primary,
          secondary: surface,
          outline: border,
          onSurface: primary,
          onPrimary: background,
          error: destructive,
        ),
        textTheme: GoogleFonts.dmSansTextTheme(
          const TextTheme(
            displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: primary),
            displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: primary),
            titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primary),
            titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: primary),
            titleSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: primary),
            bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: primary),
            bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: primary),
            bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: muted),
            labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: primary),
            labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: muted),
          ),
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: AppBarTheme(
          backgroundColor: background,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: primary,
          ),
          iconTheme: const IconThemeData(color: primary, size: 22),
          actionsIconTheme: const IconThemeData(color: primary, size: 22),
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          color: background,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            side: BorderSide(color: border),
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: border,
          thickness: 1,
          space: 0,
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: primary,
          inactiveTrackColor: border,
          thumbColor: primary,
          overlayColor: Color(0x1A111111),
          trackHeight: 2,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: background,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            textStyle: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            side: const BorderSide(color: border),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            textStyle: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            textStyle: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: primary, width: 1.5),
          ),
          hintStyle: GoogleFonts.dmSans(color: muted, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: surface,
          selectedColor: primary,
          labelStyle: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w500, color: primary),
          secondaryLabelStyle: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w500, color: background),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: border),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        ),
        iconTheme: const IconThemeData(color: primary, size: 20),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return background;
            return muted;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return primary;
            return border;
          }),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return primary;
            return Colors.transparent;
          }),
          side: const BorderSide(color: border, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          surface: darkBackground,
          primary: darkPrimary,
          secondary: darkSurface,
          outline: darkBorder,
          onSurface: darkPrimary,
          onPrimary: darkBackground,
          error: destructive,
        ),
        textTheme: GoogleFonts.dmSansTextTheme(
          const TextTheme(
            displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: darkPrimary),
            displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: darkPrimary),
            titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: darkPrimary),
            titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: darkPrimary),
            titleSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: darkPrimary),
            bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: darkPrimary),
            bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: darkPrimary),
            bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: darkMuted),
            labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: darkPrimary),
            labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: darkMuted),
          ),
        ),
        scaffoldBackgroundColor: darkBackground,
        appBarTheme: AppBarTheme(
          backgroundColor: darkBackground,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: darkPrimary,
          ),
          iconTheme: const IconThemeData(color: darkPrimary, size: 22),
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          color: darkSurface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            side: BorderSide(color: darkBorder),
          ),
        ),
        dividerTheme: const DividerThemeData(color: darkBorder, thickness: 1, space: 0),
        scaffoldBackgroundColor: darkBackground,
      );
}
