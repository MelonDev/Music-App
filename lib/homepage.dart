import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController playAnimationController;
  late Animation<double> playAnimation;

  late ThemeData theme;

  int _counter = 0;
  int _selectedPageIndex = 0;

  bool _isPlaying = false;
  bool _isPlayerShowing = true;

  void _incrementCounter() {
    setState(() {
      _counter++;
      _isPlayerShowing = !_isPlayerShowing;
    });
  }

  void _playStopOnPressed(){
    setState(() {
      _isPlaying = !_isPlaying;
      _isPlaying
          ? playAnimationController.forward()
          : playAnimationController.reverse();
    });
  }

  void _forwardOnPressed(){

  }

  void _floatingPlayerOnPressed(){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 1.0,
            child: Container(),
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

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: theme.colorScheme.secondaryContainer,
            statusBarBrightness: Brightness.light,
            statusBarColor: Colors.transparent),
        title: const Text("Music App"),
      ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget bottomNavigationBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _isPlayerShowing ? progressBar() : Container(),
        _isPlayerShowing ? floatingPlayer() : Container(),
        NavigationBar(
          selectedIndex: _selectedPageIndex,
          height: 72,
          backgroundColor: theme.colorScheme.surface,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedPageIndex = index;
            });
          },
          destinations: const <NavigationDestination>[
            NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outline),
              label: 'Learn',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.engineering),
              icon: Icon(Icons.engineering_outlined),
              label: 'Relearn',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.bookmark),
              icon: Icon(Icons.bookmark_border),
              label: 'Unlearn',
            ),
          ],
        )
      ],
    );
  }

  Widget progressBar() {
    return Container(
      color: theme.colorScheme.secondaryContainer,
      width: MediaQuery.of(context).size.width,
      child: LinearProgressIndicator(
        backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
        value: 0.6,
        minHeight: 3,
        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.secondary),
      ),
    );
  }

  Widget floatingPlayer() {
    return GestureDetector(
      onTap: _floatingPlayerOnPressed,
      child: Container(
        height: 70,
        padding: const EdgeInsets.only(bottom: 2),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 12),
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                  margin: const EdgeInsets.only(
                      left: 76, top: 8, bottom: 8, right: 122),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ชื่อเพลง",
                        style: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Text(
                        "นักร้อง",
                        style: TextStyle(
                            color: theme.colorScheme.secondary.withOpacity(0.8),
                            fontWeight: FontWeight.normal,
                            fontSize: 16),
                      ),
                    ],
                  )),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                    splashColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.all(12),
                    onPressed: _playStopOnPressed,
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: playAnimation,
                      size: 34.0,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  IconButton(
                    splashColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.all(12),
                    onPressed: _forwardOnPressed,
                    icon: Icon(
                      CupertinoIcons.forward_fill,
                      size: 28,
                      color: theme.colorScheme.secondary,
                    ),
                  )
                ]),
              ),
            )
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
