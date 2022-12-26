import 'package:vikramaditya_video_player/model/control_model.dart';

class NetworkVideo {
  final String id;
  final String name;
  final String videoUrl;
  final String thumbnailUrl;
  final NetworkVideoControl? videoControl;

  NetworkVideo(
      {required this.id,
      required this.name,
      required this.videoUrl,
      required this.thumbnailUrl,
      this.videoControl});
}
