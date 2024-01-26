import 'package:flutter/material.dart';
import 'package:web3_wallet/screen/home_page.dart';
import 'package:web3modal_flutter/theme/w3m_colors.dart';
import 'package:web3modal_flutter/theme/w3m_radiuses.dart';
import 'package:web3modal_flutter/theme/w3m_theme_data.dart';
import 'package:web3modal_flutter/theme/w3m_theme_widget.dart';

void main() {
  const bool isDarkMode = false;

  final themeData = Web3ModalThemeData(
    lightColors: Web3ModalColors.lightMode.copyWith(
      accent100: Colors.green,
      background125: Colors.white,
    ),
    darkColors: Web3ModalColors.darkMode.copyWith(
      accent100: Colors.green,
      background125: Colors.brown,
    ),
    radiuses: Web3ModalRadiuses.circular,
  );
  runApp(Web3ModalTheme(
      isDarkMode: isDarkMode, themeData: themeData, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web3 Wallet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
