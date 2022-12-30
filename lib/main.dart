import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme =
        ThemeData(colorSchemeSeed: Colors.lightGreen, useMaterial3: true);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: theme.colorScheme,
          useMaterial3: theme.useMaterial3,
          splashColor: Colors.transparent,
          textTheme: GoogleFonts.itimTextTheme(theme.textTheme),
          navigationBarTheme: NavigationBarThemeData(
            //backgroundColor: Color(0xff0100f5b),
            //indicatorColor: Color(0xff5454c2),

            labelTextStyle: MaterialStateProperty.all(TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            )),
            iconTheme: MaterialStateProperty.all(IconThemeData(
              color: theme.colorScheme.onPrimaryContainer,
              size: 25,
            )),
          )),
      home: const HomePage(),
    );
  }
}