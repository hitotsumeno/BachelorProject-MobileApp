import 'package:bp_flutter_app/core/theme/theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier 
{
  //Init theme is Light
  ThemeData _themeData = lightMode;

  //method to access the theme from other parts of the code
  ThemeData get themeData => _themeData;

  //method to see if we are in dark mode or not
  bool get isDarkMode => themeData == darkMode;

  // method to set the new theme
  set themeData(ThemeData themeData)
  {
    _themeData = themeData;
    notifyListeners();
  }

  // switch for themes 
  void toggleTheme()
  {
    if (_themeData == lightMode)
    {
      themeData = darkMode;
    }
    else
    {
      themeData = lightMode;
    }
  }
}