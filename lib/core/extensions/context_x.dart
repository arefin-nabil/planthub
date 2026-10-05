import 'package:flutter/material.dart';
import '../theme/app_palette.dart';

/// Ergonomic build context extensions for clean, concise UI code.
extension ContextX on BuildContext {
  /// Theme Data
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;

  /// Custom Botanical Palette (ThemeExtension)
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;

  /// Brightness shortcuts
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Screen Dimensions & Responsiveness
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  bool get isTablet => screenWidth >= 600;
  bool get isDesktop => screenWidth >= 1024;

  /// Focus & Keyboard
  void unFocus() => FocusScope.of(this).unfocus();

  /// Scaffold & Navigation helpers
  void showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
