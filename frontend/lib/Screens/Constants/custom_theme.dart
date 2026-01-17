import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

String extractJson(String text) {
  final start = text.indexOf('[');
  final end = text.lastIndexOf(']');
  if (start == -1 || end == -1) {
    throw Exception("No JSON array found in response");
  }
  return text.substring(start, end + 1);
}

class CustomTheme {
  // Primary Brand Colors
  static const Color primaryGold = Color(0xFFFFD88E);
  static const Color primaryGoldLight = Color(0xFFFFD994);
  static const Color primaryGoldDark = Color(0xFFDAA950);
  static const Color primaryGoldAccent = Color(0xFFEDD19F);
  
  // Background Colors
  static const Color backgroundColor = Colors.black;
  static const Color cardBackground = Color(0xFF171717);
  static const Color cardBackgroundTransparent = Color(0xFF171717);
  
  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textGold = Color(0xFFFFD88E);
  static const Color textGoldLight = Color(0xFFFFD994);
  
  // Border Colors
  static const Color borderGold = Color(0xFFFFD88E);
  static const Color borderGoldLight = Color(0xFFFFD994);
  
  // Status Colors
  static const Color successColor = Color(0xFF02C17E);
  static const Color errorColor = Color(0xFFC73C3C);
  static const Color warningColor = Color(0xFFFFA726);
  
  // Legacy colors for compatibility
  static const Color primaryColor = primaryGold;
  static const Color cardColor = cardBackground;
  static const Color textPrimaryColor = textPrimary;
  static const Color textSecondaryColor = textSecondary;
  static const Color borderColor = borderGold;

  // Standardized Spacing
  static double get spacingXS => 4.0.h;
  static double get spacingS => 8.0.h;
  static double get spacingM => 16.0.h;
  static double get spacingL => 24.0.h;
  static double get spacingXL => 32.0.h;
  static double get spacingXXL => 48.0.h;
  
  // Standardized Border Radius
  static double get radiusS => 5.0.r;
  static double get radiusM => 10.0.r;
  static double get radiusL => 15.0.r;
  static double get radiusXL => 20.0.r;
  
  // Standardized Card Styling
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardBackground.withOpacity(0.7),
    border: Border.all(color: borderGold, width: 1.0.w),
    borderRadius: BorderRadius.circular(radiusM),
  );
  
  static BoxDecoration get cardDecorationTransparent => BoxDecoration(
    color: cardBackground.withOpacity(0.7),
    border: Border.all(color: borderGold, width: 1.0.w),
    borderRadius: BorderRadius.circular(radiusM),
  );
  
  // Standardized Button Styling
  static BoxDecoration get buttonDecoration => BoxDecoration(
    border: Border.all(color: borderGold, width: 1.0.w),
    borderRadius: BorderRadius.circular(radiusS),
  );
  
  static BoxDecoration get buttonDecorationFilled => BoxDecoration(
    color: primaryGold.withOpacity(0.1),
    border: Border.all(color: borderGold, width: 1.0.w),
    borderRadius: BorderRadius.circular(radiusS),
  );

  static TextTheme get textTheme {
    return TextTheme(
      // Display styles for main titles
      displayLarge: TextStyle(
        fontFamily: 'PlayfairDisplaySC',
        fontSize: 55.0.w,
        fontWeight: FontWeight.w400,
        color: textGold,
        letterSpacing: 2.0.w,
      ),
      displayMedium: TextStyle(
        fontFamily: 'PlayfairDisplaySC',
        fontSize: 43.0.w,
        fontWeight: FontWeight.w400,
        color: textGold,
        letterSpacing: 1.5.w,
      ),
      displaySmall: TextStyle(
        fontFamily: 'PlayfairDisplaySC',
        fontSize: 30.0.w,
        fontWeight: FontWeight.w400,
        color: textGold,
        letterSpacing: 1.0.w,
      ),
      
      // Headline styles for section titles
      headlineLarge: TextStyle(
        fontFamily: 'PlayfairDisplaySC',
        fontSize: 25.0.w,
        fontWeight: FontWeight.w400,
        color: textGold,
        letterSpacing: 1.0.w,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'PlayfairDisplaySC',
        fontSize: 20.0.w,
        fontWeight: FontWeight.w400,
        color: textGold,
        letterSpacing: 1.0.w,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'PlayfairDisplaySC',
        fontSize: 18.0.w,
        fontWeight: FontWeight.w400,
        color: textGold,
        letterSpacing: 0.8.w,
      ),
      
      // Title styles for card titles
      titleLarge: TextStyle(
        fontFamily: 'PlayfairDisplaySC',
        fontSize: 20.0.w,
        fontWeight: FontWeight.w400,
        color: textGold,
        letterSpacing: 10.0.w,
      ),
      titleMedium: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 15.0.w,
        fontWeight: FontWeight.w400,
        color: textGold,
        letterSpacing: 7.5.w,
      ),
      titleSmall: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 12.0.w,
        fontWeight: FontWeight.w400,
        color: textGold,
        letterSpacing: 5.0.w,
      ),
      
      // Body styles for content
      bodyLarge: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 16.0.w,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 14.0.w,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),
      bodySmall: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 12.0.w,
        fontWeight: FontWeight.normal,
        color: textSecondary,
      ),
      
      // Label styles for buttons and small text
      labelLarge: TextStyle(
        fontFamily: 'PlayfairDisplaySC',
        fontSize: 20.0.w,
        fontWeight: FontWeight.w400,
        color: textGold,
        letterSpacing: 12.0.w,
      ),
      labelMedium: TextStyle(
        fontFamily: 'PlayfairDisplaySC',
        fontSize: 16.0.w,
        fontWeight: FontWeight.w400,
        color: textGold,
        letterSpacing: 8.0.w,
      ),
      labelSmall: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 11.0.w,
        fontWeight: FontWeight.w400,
        color: textGold,
        letterSpacing: 5.0.w,
      ),
    );
  }

  // Standardized AppBar Theme
  static AppBarTheme get appBarTheme => AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: textPrimary,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: textTheme.headlineMedium,
    iconTheme: IconThemeData(
      color: textGold,
      size: 24.0.w,
    ),
    leadingWidth: 60.0.w,
  );

  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryGold,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardBackground,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      colorScheme: const ColorScheme.dark(
        primary: primaryGold,
        secondary: cardBackground,
        background: backgroundColor,
        error: errorColor,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onBackground: textPrimary,
        onError: textPrimary,
      ),
      appBarTheme: appBarTheme,
      textTheme: textTheme,
      dividerTheme: const DividerThemeData(
        color: borderGold,
        thickness: 1,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGold,
          textStyle: textTheme.labelLarge,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: textPrimary,
          backgroundColor: primaryGold,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusS),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusL),
          side: const BorderSide(color: borderGold, width: 1),
        ),
        titleTextStyle: textTheme.displaySmall,
        contentTextStyle: textTheme.bodyLarge,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cardBackground,
        contentTextStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground.withOpacity(0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: borderGold, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: borderGold, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: primaryGold, width: 2),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: textSecondary,
        ),
      ),
    );
  }

  // Legacy method for backward compatibility
  static BoxDecoration containerDecoration({double borderRadius = 10.0}) {
    return BoxDecoration(
      color: cardBackground.withOpacity(0.7),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderGold,
        width: 1.0.w,
      ),
    );
  }

  static BoxDecoration successStatusDecoration() {
    return BoxDecoration(
      color: successColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(radiusXL),
      border: Border.all(color: successColor, width: 1.0.w),
    );
  }

  static BoxDecoration errorStatusDecoration() {
    return BoxDecoration(
      color: errorColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(radiusXL),
      border: Border.all(color: errorColor, width: 1.0.w),
    );
  }
  
  static BoxDecoration warningStatusDecoration() {
    return BoxDecoration(
      color: warningColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(radiusXL),
      border: Border.all(color: warningColor, width: 1.0.w),
    );
  }
}