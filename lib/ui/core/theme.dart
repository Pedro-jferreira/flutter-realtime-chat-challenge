import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Color(0xFF22C55E); // main: '#22C55E'
  static const secondary = Color(0xFF1BB55C); // secondary main
  static const error = Color(0xFFB71D18); // error main

  // Textos & Backgrounds (Light Mode)
  static const textPrimary = Color(0xFF212B36); // #212B36
  static const textSecondary = Color(0xFF637381); // #637381
  static const textDisabled = Color(0xFF919EAB); // #919EAB
  static const backgroundDefault = Color(0xFFFFFFFF);
  static const backgroundNeutral = Color(0xFFF4F6F8); // background.neutral

  static const divider = Color(0x33919EAB); // #919EAB33 (33 hex ~= 20% opacity)
  static const borderHover = Color(0xFF919EAB); // grey 300/400

  // --- O Tema Light ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        error: error,
        surface: backgroundDefault,
        onPrimary: Colors.white,
        // contrastText: '#FFFFFF'
        onSurface: textPrimary,
      ),

      scaffoldBackgroundColor: backgroundDefault,

      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          // Equivale ao h4
          fontWeight: FontWeight.bold, // 700
          fontSize: 24,
          color: textPrimary,
          height: 1.5, // line-height 36px / 24px = 1.5
        ),
        bodyMedium: TextStyle(
          // Equivale ao body2 (padrão do flutter)
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: textPrimary,
          height: 1.57, // 22px / 14px
        ),
        bodySmall: TextStyle(
          // Equivale ao caption
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: textSecondary,
        ),
        labelLarge: TextStyle(
          // Equivale ao button text
          fontWeight: FontWeight.bold, // 700
          fontSize: 15,
        ),
      ),

      // 4. Inputs (MuiOutlinedInput)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        // MUI default é transparente ou branco
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 14,
        ),
        // Label Style
        labelStyle: const TextStyle(color: textSecondary),
        floatingLabelStyle: const TextStyle(color: secondary),
        // Quando focado fica verde

        // Bordas
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // borderRadius: '8px'
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: divider), // #919EAB33
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: secondary,
            width: 2,
          ), // borderColor: '#1BB55C', borderWidth: '2px'
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: error),
        ),
      ),

      // 5. Botões (MuiButton)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              // Text color
              elevation: 0,
              // boxShadow: 'none'
              minimumSize: const Size(double.infinity, 48),
              // Altura padrão boa
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // borderRadius: '8px'
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ).copyWith(
              // Remove sombra no hover/focus também
              shadowColor: WidgetStateProperty.all(Colors.transparent),
            ),
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 3, // boxShadow: 3 do MUI
        shadowColor: Colors.black..withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
