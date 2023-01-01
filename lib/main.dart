import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/cubit/controller/controller_cubit.dart';

import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.melondev.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(colorSchemeSeed: Colors.orange, useMaterial3: true);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiBlocProvider(
        providers: [
          BlocProvider<ControllerCubit>(
            create: (context) => ControllerCubit()..setup(),
            lazy: false,
          ),
        ],
        child: MaterialApp(
          title: 'Music App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              colorScheme: theme.colorScheme,
              useMaterial3: theme.useMaterial3,
              splashColor: Colors.transparent,
              textTheme: GoogleFonts.itimTextTheme(theme.textTheme),
              navigationBarTheme: NavigationBarThemeData(
                backgroundColor: theme.colorScheme.surface,
                indicatorColor: theme.colorScheme.secondaryContainer,
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
        ));
  }
}
