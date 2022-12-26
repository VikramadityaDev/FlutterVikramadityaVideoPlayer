library vikramaditya_video_player;

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:vikramaditya_video_player/model/video_model.dart';
import 'package:vikramaditya_video_player/style/style1.dart';
import 'package:vikramaditya_video_player/style/style2.dart';
import 'package:vikramaditya_video_player/util/constant/constants.dart';
import 'package:vikramaditya_video_player/util/theme_util.dart';

class VideosPlayer extends StatefulWidget {
  final List<NetworkVideo> networkVideos;
  final Style playlistStyle;
  final double maxVideoPlayerHeight;

  VideosPlayer(
      {required this.networkVideos,
        this.playlistStyle = Style.Style1,
        this.maxVideoPlayerHeight = kMaxVideoPlayerHeight});

  @override
  _VideosPlayerState createState() => _VideosPlayerState();
}

class _VideosPlayerState extends State<VideosPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  late NetworkVideo selectedVideo;
  late double _maxHeight;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _maxHeight = widget.maxVideoPlayerHeight;
    if (widget.networkVideos.length > 0) {
      playNetworkVideos(widget.networkVideos[0], true);
    }
  }

  playNetworkVideos(NetworkVideo video, bool initialLoad) async {
    if (!loading) {
      setState(() {
        loading = true;
      });

      if (!initialLoad) {
        _chewieController!.dispose();
        await _videoPlayerController.pause();
        await _videoPlayerController.seekTo(const Duration(seconds: 0));
      }

      VideoPlayerController videoPlayer =
      VideoPlayerController.network(video.videoUrl);
      await videoPlayer.initialize();

      double aspectRatio =
          videoPlayer.value.size.width / videoPlayer.value.size.height;

      setState(() {
        loading = false;
        selectedVideo = video;
        _videoPlayerController = videoPlayer;
        _chewieController = ChewieController(
          videoPlayerController: videoPlayer,
          aspectRatio: aspectRatio,
          autoPlay: (video.videoControl != null)
              ? video.videoControl!.autoPlay
              : false,
          startAt:
          (video.videoControl != null) ? video.videoControl!.startAt : null,
          looping:
          (video.videoControl != null) ? video.videoControl!.looping : false,
          fullScreenByDefault: (video.videoControl != null)
              ? video.videoControl!.fullScreenByDefault
              : false,
          cupertinoProgressColors: (video.videoControl != null)
              ? video.videoControl!.cupertinoProgressColors
              : null,
          materialProgressColors: (video.videoControl != null)
              ? video.videoControl!.materialProgressColors
              : null,
          placeholder: (video.videoControl != null)
              ? video.videoControl!.placeholder
              : null,
          overlay:
          (video.videoControl != null) ? video.videoControl!.overlay : null,
          showControlsOnInitialize: (video.videoControl != null)
              ? video.videoControl!.showControlsOnInitialize
              : true,
          showControls: (video.videoControl != null)
              ? video.videoControl!.showControls
              : true,
          customControls: (video.videoControl != null)
              ? video.videoControl!.customControls
              : null,
          errorBuilder: (video.videoControl != null)
              ? video.videoControl!.errorBuilder
              : null,
          allowedScreenSleep: (video.videoControl != null)
              ? video.videoControl!.allowedScreenSleep
              : true,
          isLive:
          (video.videoControl != null) ? video.videoControl!.isLive : false,
          allowFullScreen: (video.videoControl != null)
              ? video.videoControl!.allowFullScreen
              : true,
          allowMuting: (video.videoControl != null)
              ? video.videoControl!.allowMuting
              : true,
          systemOverlaysAfterFullScreen: (video.videoControl != null)
              ? video.videoControl!.systemOverlaysAfterFullScreen
              : SystemUiOverlay.values,
          deviceOrientationsAfterFullScreen: (video.videoControl != null)
              ? video.videoControl!.deviceOrientationsAfterFullScreen
              : const [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ],
          routePageBuilder: (video.videoControl != null)
              ? video.videoControl!.routePageBuilder
              : null,
        );
        _maxHeight = (MediaQuery.of(context).size.width / aspectRatio) >
            widget.maxVideoPlayerHeight
            ? widget.maxVideoPlayerHeight
            : (MediaQuery.of(context).size.width / aspectRatio);
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          (_chewieController == null)
              ? Container(
              height: _maxHeight,
              color: Colors.white,
              child: const Center(child: CupertinoActivityIndicator()))
              : Container(
            height: _maxHeight,
            color: Colors.white,
            child: Stack(children: <Widget>[
              Chewie(
                controller: _chewieController!,
              ),
              (widget.playlistStyle == Style.Style1)
                  ? Style1(
                maxHeight: _maxHeight,
                networkVideos: widget.networkVideos,
                selectedVideo: selectedVideo,
                onVideoChange: playNetworkVideos,
              )
                  : Container(),
            ]),
          ),
          (widget.playlistStyle == Style.Style2 && _chewieController != null)
              ? Style2(
              maxHeight: _maxHeight,
              networkVideos: widget.networkVideos,
              selectedVideo: selectedVideo,
              onVideoChange: playNetworkVideos)
              : Container(),
        ],
      ),
    );
  }
}
