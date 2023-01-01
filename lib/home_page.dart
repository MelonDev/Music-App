import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
//import 'package:music_app/MockMusic.dart';
import 'package:music_app/color_helper.dart';
import 'package:music_app/cubit/controller/controller_cubit.dart';
import 'package:music_app/model/music_model.dart';
import 'package:music_app/model/position_data.dart';
import 'package:music_app/player_page.dart';
import 'package:rxdart/rxdart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController playAnimationController;
  late Animation<double> playAnimation;

  ThemeData? theme;

  late EdgeInsets viewPadding;

  //final MusicModel music = mockMusic();

  int _counter = 0;
  int _selectedPageIndex = 0;

  bool _isPlaying = false;
  bool _isPlayerShowing = true;

  void _playStopOnPressed() {
    //context.read<ControllerCubit>().playFromUri(Uri.parse("https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fズットキット・プライマリ.mp3?alt=media&token=010f9203-1d73-48a4-83be-480cb3ad8efe"));

    if (_isPlaying) {
      context.read<ControllerCubit>().stop();
    } else {
      context.read<ControllerCubit>().play();
    }

    setState(() {
      _isPlaying = !_isPlaying;
      _isPlaying
          ? playAnimationController.forward()
          : playAnimationController.reverse();
    });
  }

  void _forwardOnPressed() {}

  void _floatingPlayerOnPressed() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: theme!.colorScheme.secondaryContainer.withOpacity(0.96),
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.95,
            child: PlayerPage(
              viewPadding: viewPadding,
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    playAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    playAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(playAnimationController);
  }

  mockTheme() async {
    //Color color = await extractColor(music.imageUrl);
    setState(() {
      //theme = ThemeData(colorSchemeSeed: color, useMaterial3: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    theme ??= Theme.of(context);
    viewPadding = MediaQuery.of(context).viewPadding;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: theme!.colorScheme.surface,
        systemNavigationBarDividerColor: theme!.colorScheme.surface,
      ),
      child: Scaffold(
        backgroundColor: theme!.colorScheme.background,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            // here the desired height
            child: AppBar(
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.dark,
                  systemNavigationBarColor:
                      theme!.colorScheme.secondaryContainer,
                  statusBarBrightness: Brightness.light,
                  statusBarColor: Colors.transparent),
              title: const Text("Music App"),
            )),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomNavigationBar(),
      ),
    );
  }

  Widget bottomNavigationBar() {
    return BlocBuilder<ControllerCubit, AudioPlayer?>(
        builder: (BuildContext context, AudioPlayer? player) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _isPlayerShowing ? progressBar(player) : Container(),
          _isPlayerShowing ? floatingPlayer(player) : Container(),
          NavigationBar(
            elevation: 0,
            selectedIndex: _selectedPageIndex,
            height: 72,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedPageIndex = index;
              });
            },
            destinations: const <NavigationDestination>[
              NavigationDestination(
                selectedIcon: Icon(CupertinoIcons.house_fill),
                icon: Icon(CupertinoIcons.house),
                label: 'หน้าหลัก',
              ),
              NavigationDestination(
                selectedIcon: Icon(CupertinoIcons.search),
                icon: Icon(CupertinoIcons.search),
                label: 'ค้นหา',
              ),
              NavigationDestination(
                selectedIcon: Icon(CupertinoIcons.music_albums_fill),
                icon: Icon(CupertinoIcons.music_albums),
                label: 'เพลย์ลิสต์',
              ),
            ],
          )
        ],
      );
    });
  }

  Widget progressBar(AudioPlayer? player) {
    if(player != null){
    return StreamBuilder<PositionData>(
        stream: Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
            player.positionStream,
            player.bufferedPositionStream,
            player.durationStream,
            (position, bufferedPosition, duration) => PositionData(
                position, bufferedPosition, duration ?? Duration.zero)),
        builder: (context, snapshot) {
          final positionData = snapshot.data;

          int totalValue =
              positionData != null ? positionData.duration.inMilliseconds : 0;
          int progressValue =
              positionData != null ? positionData.position.inMilliseconds : 0;
          double remainingValue = (progressValue / totalValue).toDouble();

          return Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: theme!.colorScheme.onSurface.withOpacity(0.5),
                    blurRadius: 8.0,
                    offset: const Offset(0.0, -0.0))
              ],
              color: theme!.colorScheme.secondaryContainer,
            ),
            width: MediaQuery.of(context).size.width,
            child: LinearProgressIndicator(
              backgroundColor: theme!.colorScheme.secondary.withOpacity(0.1),
              value: remainingValue > 0 ? remainingValue : null,
              minHeight: 3,
              valueColor:
                  AlwaysStoppedAnimation<Color>(theme!.colorScheme.secondary),
            ),
          );
        });}else {
      return Container();
    }
  }

  Widget floatingPlayer(AudioPlayer? player) {
    if(player != null){
    return GestureDetector(
      onTap: _floatingPlayerOnPressed,
      child: Container(
        height: 70,
        padding: const EdgeInsets.only(bottom: 2),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: theme!.colorScheme.secondaryContainer,
        ),
        child: Stack(
          children: [
            StreamBuilder<SequenceState?>(
                stream: player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state!.currentSource!.tag as MediaItem;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin: const EdgeInsets.only(left: 12),
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                            color: theme!.colorScheme.secondary,
                            borderRadius: BorderRadius.circular(12)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(metadata.artUri.toString()))),
                  );
                }),
            StreamBuilder<SequenceState?>(
                stream: player!.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state!.currentSource!.tag as MediaItem;
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        margin: const EdgeInsets.only(
                            left: 76, top: 8, bottom: 8, right: 122),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              metadata.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: theme!.colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            Text(
                              metadata.album ?? "ไม่ระบุ",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: theme!.colorScheme.secondary
                                      .withOpacity(0.8),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16),
                            ),
                          ],
                        )),
                  );
                }),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  StreamBuilder<PlayerState>(
                    stream: player.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      final processingState = playerState?.processingState;
                      bool playing = playerState?.playing ?? false;
                      playing
                          ? playAnimationController.forward()
                          : playAnimationController.reverse();
                      return IconButton(
                        splashColor: theme!.colorScheme.primary,
                        padding: const EdgeInsets.all(12),
                        onPressed: _playStopOnPressed,
                        icon: AnimatedIcon(
                          icon: AnimatedIcons.play_pause,
                          progress: playAnimation,
                          size: 34.0,
                          color: theme!.colorScheme.secondary,
                        ),
                      );
                    },
                  ),
                  StreamBuilder<SequenceState?>(
                    stream: player.sequenceStateStream,
                    builder: (context, snapshot) => IconButton(
                      splashColor: theme!.colorScheme.primary,
                      padding: const EdgeInsets.all(12),
                      onPressed: player.hasNext ? player.seekToNext : null,
                      icon: Icon(
                        CupertinoIcons.forward_fill,
                        size: 28,
                        color: theme!.colorScheme.secondary.withOpacity(player.hasNext ? 1.0 : 0.3),
                      ),
                    ),
                  ),

                ]),
              ),
            ),
          ],
        ),
      ),
    );}else {
      return Container();
    }
  }

  @override
  void dispose() {
    playAnimationController.dispose();
    super.dispose();
  }
}
