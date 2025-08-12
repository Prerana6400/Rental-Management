import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the application.
/// Implements Contemporary Professional Minimalism with Dark Professional theme
/// optimized for enterprise rental business management.
class AppTheme {
  AppTheme._();

  // Enterprise Professional Color Palette
  static const Color primaryDark = Color(0xFF1A1D23);
  static const Color surfaceElevated = Color(0xFF252A32);
  static const Color accentTeal = Color(0xFF00BFA5);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningAmber = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFF44336);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color textDisabled = Color(0xFF546E7A);
  static const Color dividerSubtle = Color(0xFF37474F);

  // Light theme fallback colors (for system compatibility)
  static const Color primaryLight = Color(0xFF00BFA5);
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1A1D23);
  static const Color textSecondaryLight = Color(0xFF546E7A);

  // Shadow and elevation colors
  static const Color shadowDark =
      Color(0x14000000); // 0.08 opacity for subtle elevation
  static const Color shadowLight = Color(0x1A000000);

  /// Dark theme - Primary theme for enterprise users
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: accentTeal,
      onPrimary: primaryDark,
      primaryContainer: accentTeal.withValues(alpha: 0.2),
      onPrimaryContainer: textPrimary,
      secondary: accentTeal,
      onSecondary: primaryDark,
      secondaryContainer: surfaceElevated,
      onSecondaryContainer: textSecondary,
      tertiary: warningAmber,
      onTertiary: primaryDark,
      tertiaryContainer: warningAmber.withValues(alpha: 0.2),
      onTertiaryContainer: textPrimary,
      error: errorRed,
      onError: textPrimary,
      errorContainer: errorRed.withValues(alpha: 0.2),
      onErrorContainer: textPrimary,
      surface: primaryDark,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: dividerSubtle,
      outlineVariant: dividerSubtle.withValues(alpha: 0.5),
      shadow: shadowDark,
      scrim: Color(0x80000000),
      inverseSurface: surfaceLight,
      onInverseSurface: textPrimaryLight,
      inversePrimary: primaryLight,
      surfaceTint: accentTeal,
    ),
    scaffoldBackgroundColor: primaryDark,
    cardColor: surfaceElevated,
    dividerColor: dividerSubtle,

    // AppBar theme for professional header design
    appBarTheme: AppBarTheme(
      backgroundColor: primaryDark,
      foregroundColor: textPrimary,
      elevation: 0,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.15,
      ),
      toolbarTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
    ),

    // Card theme with subtle elevation
    cardTheme: CardTheme(
      color: surfaceElevated,
      elevation: 4,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom navigation for mobile-first design
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceElevated,
      selectedItemColor: accentTeal,
      unselectedItemColor: textSecondary,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),

    // Floating action button with context-sensitive design
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentTeal,
      foregroundColor: primaryDark,
      elevation: 6,
      focusElevation: 8,
      hoverElevation: 8,
      highlightElevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Button themes for professional interactions
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: primaryDark,
        backgroundColor: accentTeal,
        disabledForegroundColor: textDisabled,
        disabledBackgroundColor: textDisabled.withValues(alpha: 0.3),
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentTeal,
        disabledForegroundColor: textDisabled,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: const BorderSide(color: accentTeal, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentTeal,
        disabledForegroundColor: textDisabled,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),

    // Typography system using Inter font family
    textTheme: _buildTextTheme(isLight: false),

    // Input decoration for forms and data entry
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceElevated,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: dividerSubtle, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: dividerSubtle, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: accentTeal, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorRed, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorRed, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide:
            BorderSide(color: textDisabled.withValues(alpha: 0.5), width: 1),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabled,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: errorRed,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Interactive element themes
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accentTeal;
        if (states.contains(WidgetState.disabled)) return textDisabled;
        return textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected))
          return accentTeal.withValues(alpha: 0.5);
        if (states.contains(WidgetState.disabled))
          return textDisabled.withValues(alpha: 0.3);
        return dividerSubtle;
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accentTeal;
        if (states.contains(WidgetState.disabled))
          return textDisabled.withValues(alpha: 0.3);
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(primaryDark),
      side: const BorderSide(color: textSecondary, width: 2),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accentTeal;
        if (states.contains(WidgetState.disabled)) return textDisabled;
        return textSecondary;
      }),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: accentTeal,
      linearTrackColor: dividerSubtle,
      circularTrackColor: dividerSubtle,
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: accentTeal,
      thumbColor: accentTeal,
      overlayColor: accentTeal.withValues(alpha: 0.2),
      inactiveTrackColor: dividerSubtle,
      valueIndicatorColor: accentTeal,
      valueIndicatorTextStyle: GoogleFonts.inter(
        color: primaryDark,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Tab bar theme for navigation
    tabBarTheme: TabBarTheme(
      labelColor: accentTeal,
      unselectedLabelColor: textSecondary,
      indicatorColor: accentTeal,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
    ),

    // Tooltip theme for contextual help
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: shadowDark,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      textStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // Snackbar theme for notifications
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surfaceElevated,
      contentTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentTeal,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 6,
    ),

    // Dialog theme for modal interactions
    dialogTheme: DialogTheme(
      backgroundColor: surfaceElevated,
      elevation: 8,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      titleTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      contentTextStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
    ),

    // List tile theme for data presentation
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      selectedTileColor: accentTeal.withValues(alpha: 0.1),
      iconColor: textSecondary,
      selectedColor: accentTeal,
      textColor: textPrimary,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.15,
      ),
      subtitleTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0.25,
      ),
      leadingAndTrailingTextStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Chip theme for tags and filters
    chipTheme: ChipThemeData(
      backgroundColor: surfaceElevated,
      selectedColor: accentTeal.withValues(alpha: 0.2),
      disabledColor: textDisabled.withValues(alpha: 0.3),
      deleteIconColor: textSecondary,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      secondaryLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: dividerSubtle, width: 1),
      ),
    ),
  );

  /// Light theme - Fallback for system compatibility
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryLight,
      onPrimary: textPrimary,
      primaryContainer: primaryLight.withValues(alpha: 0.1),
      onPrimaryContainer: textPrimaryLight,
      secondary: primaryLight,
      onSecondary: textPrimary,
      secondaryContainer: backgroundLight,
      onSecondaryContainer: textSecondaryLight,
      tertiary: warningAmber,
      onTertiary: textPrimary,
      tertiaryContainer: warningAmber.withValues(alpha: 0.1),
      onTertiaryContainer: textPrimaryLight,
      error: errorRed,
      onError: textPrimary,
      errorContainer: errorRed.withValues(alpha: 0.1),
      onErrorContainer: textPrimaryLight,
      surface: surfaceLight,
      onSurface: textPrimaryLight,
      onSurfaceVariant: textSecondaryLight,
      outline: textSecondaryLight.withValues(alpha: 0.5),
      outlineVariant: textSecondaryLight.withValues(alpha: 0.3),
      shadow: shadowLight,
      scrim: Color(0x80000000),
      inverseSurface: primaryDark,
      onInverseSurface: textPrimary,
      inversePrimary: accentTeal,
      surfaceTint: primaryLight,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: surfaceLight,
    dividerColor: textSecondaryLight.withValues(alpha: 0.3),
    textTheme: _buildTextTheme(isLight: true), dialogTheme: DialogThemeData(backgroundColor: surfaceLight),
    // Additional light theme configurations would follow the same pattern
    // but are abbreviated here since dark theme is primary
  );

  /// Helper method to build text theme with Inter font family
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis = isLight ? textPrimaryLight : textPrimary;
    final Color textMediumEmphasis =
        isLight ? textSecondaryLight : textSecondary;
    final Color textLowEmphasis =
        isLight ? textSecondaryLight.withValues(alpha: 0.6) : textDisabled;

    return TextTheme(
      // Display styles for large headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles for section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles for cards and components
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body styles for content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasis,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles for UI elements
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 1.25,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textMediumEmphasis,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textLowEmphasis,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Data display text style using JetBrains Mono for numerical precision
  static TextStyle dataTextStyle({
    required bool isLight,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: isLight ? textPrimaryLight : textPrimary,
      letterSpacing: 0,
      height: 1.4,
    );
  }

  /// Success state color getter
  static Color get successColor => successGreen;

  /// Warning state color getter
  static Color get warningColor => warningAmber;

  /// Error state color getter
  static Color get errorColor => errorRed;

  /// Accent color getter
  static Color get accentColor => accentTeal;
}
