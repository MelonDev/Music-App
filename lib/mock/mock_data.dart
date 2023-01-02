import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class PlaylistModel {
  String name;
  List<dynamic> playlist;

  PlaylistModel({required this.name, required this.playlist});
}

List<AudioSource> myRecentMusic = [
  AudioSource.uri(
    Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fc1924137-03b7-4e2d-913e-8c886def861e.mp3?alt=media&token=bfb3cd5e-3a79-4e44-9cb5-3f1341469ad4"),
    tag: MediaItem(
      id: '0',
      album: "sasakure.UK",
      title: "ズットキット･プライマリ",
      artUri: Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fc1924137-03b7-4e2d-913e-8c886def861e_base_resized.jpg?alt=media&token=b420500c-5479-40d3-91ed-e1a0266bec49"),
    ),
  ),
  AudioSource.uri(
    Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2FiMeiden%20-%20Tower%20Light%20Fireworks%20(feat.%20Rachie).mp3?alt=media&token=134ac5f0-0756-4800-8195-50ea8e5dc57f"),
    tag: MediaItem(
      id: '1',
      album: "Tower Light Fireworks",
      title: "Rachie",
      artUri: Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fartworks-000354253638-9o84p6-t500x500.jpg?alt=media&token=74d98208-6075-4f5e-b814-262c04a08f91"),
    ),
  ),
  AudioSource.uri(
    Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2FI'm%20Moving%20On.mp3?alt=media&token=28be6e6d-49b6-44de-9f0b-2892680e6e29"),
    tag: MediaItem(
      id: '2',
      album: "Happy Republic",
      title: "I'm Moving On",
      artUri: Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fpedro-lastra-Nyvq2juw4_o-unsplash.jpg?alt=media&token=15a1f1bb-fe6d-4042-96b2-eab4ef5e41df"),
    ),
  ),


];

List<AudioSource> mockSuggestionPlaylists = [
  AudioSource.uri(
    Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2FiMeiden%20-%20Tower%20Light%20Fireworks%20(feat.%20Rachie).mp3?alt=media&token=134ac5f0-0756-4800-8195-50ea8e5dc57f"),
    tag: MediaItem(
      id: '0',
      album: "Rachie",
      title: "Tower Light Fireworks",
      artUri: Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fartworks-000354253638-9o84p6-t500x500.jpg?alt=media&token=74d98208-6075-4f5e-b814-262c04a08f91"),
    ),
  ),
  AudioSource.uri(
    Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2FShooting%20Star%20(feat.%20Rachie).mp3?alt=media&token=2af57590-1fa0-4117-bfb0-84fb16876059"),
    tag: MediaItem(
      id: '1',
      album: "Rachie",
      title: "Shooting Star",
      artUri: Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fd66bfc491ee1eaa18e5d30a74642cbdc.700x700x1.jpg?alt=media&token=e6d85750-96eb-4e2b-ae74-6599eb6a8dc5"),
    ),
  ),
  AudioSource.uri(
    Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fc1924137-03b7-4e2d-913e-8c886def861e.mp3?alt=media&token=bfb3cd5e-3a79-4e44-9cb5-3f1341469ad4"),
    tag: MediaItem(
      id: '2',
      album: "sasakure.UK",
      title: "ズットキット･プライマリ",
      artUri: Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fc1924137-03b7-4e2d-913e-8c886def861e_base_resized.jpg?alt=media&token=b420500c-5479-40d3-91ed-e1a0266bec49"),
    ),
  ),
  ClippingAudioSource(
    start: const Duration(seconds: 33),
    end: const Duration(seconds: 69),
    child: AudioSource.uri(Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2F%5BTropical%20House%5D%20-%20Hyper%20Potions%20-%20Unbreakable%20(feat.%20Danyka%20Nadeau)%20%5BMonstercat%20Release%5D.mp3?alt=media&token=fb07ce32-c853-495c-8523-47ccedabb694")),
    tag: MediaItem(
      id: '1',
      album: "Hyper Potions",
      title: "Unbreakable (36 วินาที)",
      artUri: Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2FHyper_Potions_-_Unbreakable_%2528feat._Danyka_Nadeau%2529.jpg?alt=media&token=ee5b93fd-a848-4f33-8082-3db4281bc9b8"),
    ),
  ),
  AudioSource.uri(
    Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fc1924137-03b7-4e2d-913e-8c886def861e.mp3?alt=media&token=bfb3cd5e-3a79-4e44-9cb5-3f1341469ad4"),
    tag: MediaItem(
      id: '3',
      album: "Hyper Potions",
      title: "Unbreakable",
      artUri: Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2FHyper_Potions_-_Unbreakable_%2528feat._Danyka_Nadeau%2529.jpg?alt=media&token=ee5b93fd-a848-4f33-8082-3db4281bc9b8"),
    ),
  ),
  AudioSource.uri(
    Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2FI'm%20Moving%20On.mp3?alt=media&token=28be6e6d-49b6-44de-9f0b-2892680e6e29"),
    tag: MediaItem(
      id: '4',
      album: "I'm Moving On",
      title: "Happy Republic",
      artUri: Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fpedro-lastra-Nyvq2juw4_o-unsplash.jpg?alt=media&token=15a1f1bb-fe6d-4042-96b2-eab4ef5e41df"),
    ),
  ),
];

List<PlaylistModel> groupPlaylists = [PlaylistModel(name: "HNY 2022", playlist: mockPlaylist1),PlaylistModel(name: "HNY 2023", playlist: mockPlaylist2)];

List<AudioSource> mockPlaylist1 = [
  AudioSource.uri(
    Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fc1924137-03b7-4e2d-913e-8c886def861e.mp3?alt=media&token=bfb3cd5e-3a79-4e44-9cb5-3f1341469ad4"),
    tag: MediaItem(
      id: '0',
      album: "sasakure.UK",
      title: "ズットキット･プライマリ",
      artUri: Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fc1924137-03b7-4e2d-913e-8c886def861e_base_resized.jpg?alt=media&token=b420500c-5479-40d3-91ed-e1a0266bec49"),
    ),
  ),
  ClippingAudioSource(
    start: const Duration(seconds: 33),
    end: const Duration(seconds: 69),
    child: AudioSource.uri(Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2F%5BTropical%20House%5D%20-%20Hyper%20Potions%20-%20Unbreakable%20(feat.%20Danyka%20Nadeau)%20%5BMonstercat%20Release%5D.mp3?alt=media&token=fb07ce32-c853-495c-8523-47ccedabb694")),
    tag: MediaItem(
      id: '1',
      album: "Hyper Potions",
      title: "Unbreakable (36 วินาที)",
      artUri: Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2FHyper_Potions_-_Unbreakable_%2528feat._Danyka_Nadeau%2529.jpg?alt=media&token=ee5b93fd-a848-4f33-8082-3db4281bc9b8"),
    ),
  ),
  AudioSource.uri(
    Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2FiMeiden%20-%20Tower%20Light%20Fireworks%20(feat.%20Rachie).mp3?alt=media&token=134ac5f0-0756-4800-8195-50ea8e5dc57f"),
    tag: MediaItem(
      id: '2',
      album: "Tower Light Fireworks",
      title: "Rachie",
      artUri: Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fartworks-000354253638-9o84p6-t500x500.jpg?alt=media&token=74d98208-6075-4f5e-b814-262c04a08f91"),
    ),
  ),
  AudioSource.uri(
    Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2FI'm%20Moving%20On.mp3?alt=media&token=28be6e6d-49b6-44de-9f0b-2892680e6e29"),
    tag: MediaItem(
      id: '3',
      album: "I'm Moving On",
      title: "Happy Republic",
      artUri: Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fpedro-lastra-Nyvq2juw4_o-unsplash.jpg?alt=media&token=15a1f1bb-fe6d-4042-96b2-eab4ef5e41df"),
    ),
  ),
];

List<AudioSource> mockPlaylist2 = [
  AudioSource.uri(
    Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2FI'm%20Moving%20On.mp3?alt=media&token=28be6e6d-49b6-44de-9f0b-2892680e6e29"),
    tag: MediaItem(
      id: '2',
      album: "I'm Moving On",
      title: "Happy Republic",
      artUri: Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fpedro-lastra-Nyvq2juw4_o-unsplash.jpg?alt=media&token=15a1f1bb-fe6d-4042-96b2-eab4ef5e41df"),
    ),
  ),
  AudioSource.uri(
    Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fc1924137-03b7-4e2d-913e-8c886def861e.mp3?alt=media&token=bfb3cd5e-3a79-4e44-9cb5-3f1341469ad4"),
    tag: MediaItem(
      id: '0',
      album: "sasakure.UK",
      title: "ズットキット･プライマリ",
      artUri: Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/meloncloud-d2fb8.appspot.com/o/Music%2Fc1924137-03b7-4e2d-913e-8c886def861e_base_resized.jpg?alt=media&token=b420500c-5479-40d3-91ed-e1a0266bec49"),
    ),
  ),
];
