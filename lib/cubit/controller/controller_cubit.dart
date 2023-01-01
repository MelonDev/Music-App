import 'package:audio_service/audio_service.dart';
import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';
import 'package:music_app/services/audio_handler.dart';
import 'package:audio_session/audio_session.dart';


part 'controller_state.dart';

class ControllerCubit extends Cubit<AudioPlayer?> {
  ControllerCubit() : super(null);

  static int _nextMediaId = 0;

  final _playlist = ConcatenatingAudioSource(children: [
    AudioSource.uri(
      Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fc1924137-03b7-4e2d-913e-8c886def861e.mp3?alt=media&token=bfb3cd5e-3a79-4e44-9cb5-3f1341469ad4"),
      tag: MediaItem(
        id: '${_nextMediaId++}',
        album: "sasakure.UK",
        title: "ズットキット･プライマリ",
        artUri: Uri.parse(
            "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fc1924137-03b7-4e2d-913e-8c886def861e_base_resized.jpg?alt=media&token=b420500c-5479-40d3-91ed-e1a0266bec49"),
      ),
    ),
    ClippingAudioSource(
      start: const Duration(seconds: 60),
      end: const Duration(seconds: 90),
      child: AudioSource.uri(Uri.parse(
          "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")),
      tag: MediaItem(
        id: '${_nextMediaId++}',
        album: "Science Friday",
        title: "A Salute To Head-Scratching Science (30 seconds)",
        artUri: Uri.parse(
            "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
      ),
    ),
    AudioSource.uri(
      Uri.parse(
          "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"),
      tag: MediaItem(
        id: '${_nextMediaId++}',
        album: "Science Friday",
        title: "A Salute To Head-Scratching Science",
        artUri: Uri.parse(
            "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
      ),
    ),
    AudioSource.uri(
      Uri.parse("https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3"),
      tag: MediaItem(
        id: '${_nextMediaId++}',
        album: "Science Friday",
        title: "From Cat Rheology To Operatic Incompetence",
        artUri: Uri.parse(
            "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
      ),
    ),
  ]);

  setup() async {
    print("setup");
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    AudioPlayer player = AudioPlayer();

    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    try {
      await player.setAudioSource(_playlist);

      emit(player);

    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
      print(stackTrace);
    }
  }

  play() async{
    state?.play();
  }

  stop() async{
    state?.pause();
  }
}
