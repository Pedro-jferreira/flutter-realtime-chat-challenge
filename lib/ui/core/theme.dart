import 'package:flutter/material.dart';

// 1. Definição das Cores Base (Baseado no getPalette do MUI)
class AppPalette {
  // Cores Comuns
  static const primaryMain = Color(0xFF22C55E);
  static const primaryContrast = Color(0xFFFFFFFF);
  static const secondaryMain = Color(0xFF1BB55C);

  // LIGHT MODE Colors
  static const lightTextPrimary = Color(0xFF212B36);
  static const lightTextSecondary = Color(0xFF637381);
  static const lightTextDisabled = Color(0xFF919EAB);
  static const lightBgDefault = Color(0xFFFFFFFF);
  static const lightBgPaper = Color(0xFFFDFFFC);
  static const lightBgNeutral = Color(0xFFF4F6F8); // A cor customizada
  static const lightActionDisabled = Color(0xCC919EAB); // #919EABCC
  static const lightActionDisabledBg = Color(0x33919EAB); // #919EAB33
  static const lightGrey300 = Color(0xFF919EAB);
  static const lightGrey400 = Color(0xFF637381);
  static const lightDivider = Color(0x33919EAB); // #919EAB33
  static const lightError = Color(0xFFB71D18);
  static const lightSuccess = Color(0xFF118D57);

  // DARK MODE Colors
  static const darkTextPrimary = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xFF919EAB);
  static const darkTextDisabled = Color(0xFF637381);
  static const darkBgDefault = Color(0xFF161C24);
  static const darkBgPaper = Color(0xFF212B36);
  static const darkBgNeutral = Color(0x1F919EAB); // #919EAB1F
  static const darkActionDisabled = Color(0xCC919EAB);
  static const darkActionDisabledBg = Color(0xFF212B36);
  static const darkGrey300 = Color(0xFF637381);
  static const darkGrey400 = Color(0xFF919EAB);
  static const darkDivider = Color.fromRGBO(145, 158, 171, 0.24);
  static const darkError = Color(0xFFFFAC82);
  static const darkSuccess = Color(0xFF77ED8B);
}

// 2. Extension para a cor 'Neutral' (Equivalente ao TypeBackground customizado do TS)
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color neutralBackground;
  final Color textSecondary;
  final Color textDisabled;
  final Color actionDisabled;
  final Color actionDisabledBg;
  final Color grey300;
  final Color grey400;
  final Color success;

  const AppColorsExtension({
    required this.neutralBackground,
    required this.textSecondary,
    required this.textDisabled,
    required this.actionDisabled,
    required this.actionDisabledBg,
    required this.grey300,
    required this.grey400,
    required this.success,
  });

  @override
  AppColorsExtension copyWith({
    Color? neutralBackground,
    Color? textSecondary,
    Color? textDisabled,
    Color? actionDisabled,
    Color? actionDisabledBg,
    Color? grey300,
    Color? grey400,
    Color? success,
  }) {
    return AppColorsExtension(
      neutralBackground: neutralBackground ?? this.neutralBackground,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      actionDisabled: actionDisabled ?? this.actionDisabled,
      actionDisabledBg: actionDisabledBg ?? this.actionDisabledBg,
      grey300: grey300 ?? this.grey300,
      grey400: grey400 ?? this.grey400,
      success: success ?? this.success,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      neutralBackground: Color.lerp(
          neutralBackground, other.neutralBackground, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      actionDisabled: Color.lerp(actionDisabled, other.actionDisabled, t)!,
      actionDisabledBg: Color.lerp(
          actionDisabledBg, other.actionDisabledBg, t)!,
      grey300: Color.lerp(grey300, other.grey300, t)!,
      grey400: Color.lerp(grey400, other.grey400, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }
}

class AppTheme {
  static final _inputBorderRadius = BorderRadius.circular(8);
  static const _inputContentPadding = EdgeInsets.symmetric(
      vertical: 16, horizontal: 14);
  static final _buttonBorderRadius = BorderRadius.circular(8);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: const ColorScheme.light(
        primary: AppPalette.primaryMain,
        onPrimary: AppPalette.primaryContrast,
        secondary: AppPalette.secondaryMain,
        onSecondary: Colors.white,
        surface: AppPalette.lightBgPaper,
        onSurface: AppPalette.lightTextPrimary,
        error: AppPalette.lightError,
        onError: Colors.white,
      ),

      scaffoldBackgroundColor: AppPalette.lightBgDefault,
      dividerColor: AppPalette.lightDivider,
      disabledColor: AppPalette.lightActionDisabled,
      extensions: [
        const AppColorsExtension(
          neutralBackground: AppPalette.lightBgNeutral,
          textSecondary: AppPalette.lightTextSecondary,
          textDisabled: AppPalette.lightTextDisabled,
          actionDisabled: AppPalette.lightActionDisabled,
          actionDisabledBg: AppPalette.lightActionDisabledBg,
          grey300: AppPalette.lightGrey300,
          grey400: AppPalette.lightGrey400,
          success: AppPalette.lightSuccess,
        ),
      ],
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: _inputContentPadding,
        labelStyle: const TextStyle(color: AppPalette.lightTextSecondary),
        floatingLabelStyle: const TextStyle(color: AppPalette.secondaryMain),

        enabledBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: AppPalette
              .lightDivider), // MuiOutlinedInput-notchedOutline
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(
              color: AppPalette.secondaryMain, width: 2), // Mui-focused
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: AppPalette.lightError),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.primaryMain,
          foregroundColor: AppPalette.primaryContrast,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: _buttonBorderRadius),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) return Colors.transparent;
            return null;
          }),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: _buttonBorderRadius),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppPalette.lightBgPaper,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: const ColorScheme.dark(
        primary: AppPalette.primaryMain,
        onPrimary: AppPalette.primaryContrast,
        secondary: AppPalette.secondaryMain,
        onSecondary: Colors.white,
        surface: AppPalette.darkBgPaper,
        onSurface: AppPalette.darkTextPrimary,
        error: AppPalette.darkError,
        onError: Colors.black,
      ),

      scaffoldBackgroundColor: AppPalette.darkBgDefault,
      dividerColor: AppPalette.darkDivider,
      disabledColor: AppPalette.darkActionDisabled,

      extensions: [
        const AppColorsExtension(
          neutralBackground: AppPalette.darkBgNeutral,
          textSecondary: AppPalette.darkTextSecondary,
          textDisabled: AppPalette.darkTextDisabled,
          actionDisabled: AppPalette.darkActionDisabled,
          actionDisabledBg: AppPalette.darkActionDisabledBg,
          grey300: AppPalette.darkGrey300,
          grey400: AppPalette.darkGrey400,
          success: AppPalette.darkSuccess,
        ),
      ],

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: _inputContentPadding,
        labelStyle: const TextStyle(color: AppPalette.darkTextSecondary),
        floatingLabelStyle: const TextStyle(color: AppPalette.secondaryMain),
        enabledBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: AppPalette.darkDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(
              color: AppPalette.secondaryMain, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: _inputBorderRadius,
          borderSide: const BorderSide(color: AppPalette.darkError),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.primaryMain,
          foregroundColor: AppPalette.primaryContrast,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: _buttonBorderRadius),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppPalette.darkBgPaper,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}