import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:just_audio/just_audio.dart';

//import 'package:music_app/MockMusic.dart';
import 'package:music_app/color_helper.dart';
import 'package:music_app/cubit/controller/controller_cubit.dart';
import 'package:music_app/mock/mock_data.dart';
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
  List<NavigationDestination> destinations = const <NavigationDestination>[
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
      label: 'ของฉัน',
    ),
  ];

  late AnimationController playAnimationController;
  late Animation<double> playAnimation;

  ThemeData? theme;

  late EdgeInsets viewPadding;

  //final MusicModel music = mockMusic();

  int _selectedPageIndex = 0;

  void _playPauseOnPressed(ControllerMediaState state) {
    if (state is ControllerPlayingState) {
      context.read<ControllerCubit>().pause(previousState: state);
      playAnimationController.forward();
    } else {
      context.read<ControllerCubit>().play(previousState: state);
      playAnimationController.reverse();
    }
    setState(() {});
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
    SchedulerBinding.instance.addPostFrameCallback((_) {
      fetchAll();
    });
    playAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    playAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(playAnimationController);
  }

  Future<void> fetchAll() async {
    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS) {
        await FlutterDisplayMode.setHighRefreshRate();
      }
    }
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
            preferredSize: const Size.fromHeight(60.0),
            // here the desired height
            child: AppBar(
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.dark,
                  systemNavigationBarColor:
                      theme!.colorScheme.secondaryContainer,
                  statusBarBrightness: Brightness.light,
                  statusBarColor: Colors.transparent),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                      child: Text(
                    destinations[_selectedPageIndex].label,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        color: theme!.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 32),
                  )),
                  Container(
                      width: 50,
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(CupertinoIcons.settings,
                              size: 28,
                              color: theme!.colorScheme.onPrimaryContainer))),
                  Container(
                      margin: const EdgeInsets.only(left: 12),
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                          color: theme!.colorScheme.secondary,
                          borderRadius: BorderRadius.circular(50)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                              "https://scontent.fbkk5-4.fna.fbcdn.net/v/t39.30808-6/274264548_2709545309190948_3396109224404836456_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=09cbfe&_nc_eui2=AeGLd79jiN9p7YkfIxeM2qfDLs3u7Tha8iouze7tOFryKnE6-xGTgH58oAjwsnZl4QHk7ZoN6IAe-Zc-ScQBR4ID&_nc_ohc=X5GXqjuKrkIAX_nrTb8&tn=xlatnNlzJE6SJacN&_nc_ht=scontent.fbkk5-4.fna&oh=00_AfAWPopR5DegQPn1z96MvCuGsStsHBDSEMR38XqBNKeTLA&oe=63B7ACA3"))),
                ],
              ),
            )),
        body: BlocBuilder<ControllerCubit, ControllerState>(
            builder: (BuildContext context, ControllerState state) {
          if (state is ControllerMediaState) {
            return body(state);
          } else {
            return Container();
          }
        }),
        bottomNavigationBar: bottomNavigationBar(),
      ),
    );
  }

  Widget bottomNavigationBar() {
    return BlocBuilder<ControllerCubit, ControllerState>(
        builder: (BuildContext context, ControllerState state) {
      if (state is ControllerMediaState) {
        bool isShowPlayer =
            state is ControllerPlayingState || state is ControllerPauseState;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isShowPlayer
                ? Dismissible(
                    key: ValueKey(state.playlist?.children[0]),
                    onDismissed: (dismissDirection) {
                      context
                          .read<ControllerCubit>()
                          .stop(previousState: state);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [progressBar(state), floatingPlayer(state)],
                    ),
                  )
                : Container(),
            NavigationBar(
              elevation: 0,
              selectedIndex: _selectedPageIndex,
              height: 72,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedPageIndex = index;
                });
              },
              destinations: destinations,
            )
          ],
        );
      } else {
        return Container();
      }
    });
  }

  Widget progressBar(ControllerMediaState state) {
    return StreamBuilder<PositionData>(
        stream: Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
            state.player.positionStream,
            state.player.bufferedPositionStream,
            state.player.durationStream,
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
        });
  }

  Widget floatingPlayer(ControllerMediaState state) {
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
                stream: state.player.sequenceStateStream,
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
                stream: state.player.sequenceStateStream,
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
                    stream: state.player.playerStateStream,
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
                        onPressed: () {
                          _playPauseOnPressed(state);
                        },
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
                    stream: state.player.sequenceStateStream,
                    builder: (context, snapshot) => IconButton(
                      splashColor: theme!.colorScheme.primary,
                      padding: const EdgeInsets.all(12),
                      onPressed:
                          state.player.hasNext ? state.player.seekToNext : null,
                      icon: Icon(
                        CupertinoIcons.forward_fill,
                        size: 28,
                        color: theme!.colorScheme.secondary
                            .withOpacity(state.player.hasNext ? 1.0 : 0.3),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget body(ControllerMediaState state) {
    switch (_selectedPageIndex) {
      case 0:
        return homePage(state);
      case 1:
        return Container();
      case 2:
        return Container();
      default:
        return Container();
    }
  }

  Widget homePage(ControllerMediaState state) {
    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      scrollDirection: Axis.vertical,
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "ฟังล่าสุด",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  color: theme!.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 26),
            )),
        Container(height: 6),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 0.0),
          height: 240.0,
          child: ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16),
              scrollDirection: Axis.horizontal,
              itemCount: myRecentMusic.length,
              itemBuilder: (BuildContext context, int index) {
                return musicTileWidget(state, myRecentMusic[index]);
              }),
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "แนะนำ",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  color: theme!.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 26),
            )),
        Container(height: 6),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 0.0),
          height: 240.0,
          child: ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16),
              scrollDirection: Axis.horizontal,
              itemCount: mockSuggestionPlaylists.length,
              itemBuilder: (BuildContext context, int index) {
                return musicTileWidget(state, mockSuggestionPlaylists[index]);
              }),
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "เพลย์ลิสต์",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  color: theme!.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 26),
            )),
        Container(height: 6),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 0.0),
          height: 210.0,
          child: ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16),
              scrollDirection: Axis.horizontal,
              itemCount: groupPlaylists.length,
              itemBuilder: (BuildContext context, int index) {
                return groupMusicTileWidget(state, groupPlaylists[index]);
              }),
        ),
      ],
    );
  }

  Widget musicTileWidget(ControllerMediaState state, dynamic source) {
    return GestureDetector(
      onTap: () {
        context
            .read<ControllerCubit>()
            .newPlaylist(playlist: [source], previousState: state);
      },
      child: Container(
        width: 140.0,
        padding: const EdgeInsets.only(left: 0, right: 0, top: 6),
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                  color: theme!.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(16)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network("${source.tag.artUri}", fit: BoxFit.cover),
              ),
            ),
            Container(height: 10),
            Text(
              "${source.tag.title}",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                  color: theme!.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Text(
              "${source.tag.album}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  color: theme!.colorScheme.onPrimaryContainer.withOpacity(0.8),
                  fontWeight: FontWeight.normal,
                  fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  Widget groupMusicTileWidget(
      ControllerMediaState state, PlaylistModel playlist) {
    return GestureDetector(
      onTap: () {
        context.read<ControllerCubit>().newPlaylist(
            playlist: playlist.playlist as List<AudioSource>,
            previousState: state);
      },
      child: Container(
        width: 140.0,
        padding: const EdgeInsets.only(left: 0, right: 0, top: 6),
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                  color: theme!.colorScheme.secondaryContainer.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16)),
              child: Row(children: [
                Container(
                    height: 140,
                    width: 70,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16)),
                      child: Image.network(
                        "${playlist.playlist[0].tag.artUri}",
                        fit: BoxFit.cover,
                      ),
                    )),
                Column(children: [
                  Container(
                      height: 70,
                      width: 70,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(16)),
                        child: Image.network(
                          "${playlist.playlist[1].tag.artUri}",
                          fit: BoxFit.cover,
                        ),
                      )),
                  Container(
                      height: 70,
                      width: 70,
                      child: playlist.playlist.asMap().containsKey(2)
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(16)),
                              child: Image.network(
                                "${playlist.playlist[2].tag.artUri}",
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container())
                ])
              ]),
            ),
            Container(height: 10),
            Text(
              playlist.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                  color: theme!.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    playAnimationController.dispose();
    super.dispose();
  }
}
