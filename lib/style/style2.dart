import 'package:flutter/material.dart';
import 'package:vikramaditya_video_player/model/video_model.dart';
import 'package:vikramaditya_video_player/util/constant/constants.dart';
import 'package:vikramaditya_video_player/util/constant/style2_constant.dart';

class Style2 extends StatefulWidget {
  final double maxHeight;
  final List<NetworkVideo> networkVideos;
  final NetworkVideo selectedVideo;
  final Function onVideoChange;

  Style2(
      {required this.maxHeight,
        required this.networkVideos,
        required this.selectedVideo,
        required this.onVideoChange});

  @override
  _Style2State createState() => _Style2State();
}

class _Style2State extends State<Style2> {
  Widget getRowWidget(NetworkVideo networkVideo, bool listView) {
    return Container(
      color: (networkVideo.id == widget.selectedVideo.id)
          ? kBackgroundColor
          : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              (networkVideo.thumbnailUrl != null)
                  ? Container(
                  width: listView ? kVideosWidth * 1.5 : kVideosWidth,
                  height: listView ? kVideosHeight * 1.5 : kVideosHeight,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kImageBorderColor,
                      width: (networkVideo.id == widget.selectedVideo.id)
                          ? 2
                          : 0,
                    ),
                    image: DecorationImage(
                        image: NetworkImage(networkVideo.thumbnailUrl),
                        fit: BoxFit.fitWidth),
                  ))
                  : Container(
                height: listView ? kVideosHeight * 1.5 : kVideosHeight,
                margin: const EdgeInsets.all(5),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(networkVideo.name),
            ],
          ),
          (listView) ? Container() : const Icon(Icons.keyboard_arrow_down)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (widget.networkVideos.length > 1)
        ? Container(
      child: InkWell(
        child: getRowWidget(widget.selectedVideo, false),
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                height: modalHeight,
                child: ListView.builder(
                  itemCount: widget.networkVideos.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        child: getRowWidget(
                            widget.networkVideos[index], true),
                        onTap: () {
                          widget.onVideoChange(
                              widget.networkVideos[index], false);
                          Navigator.pop(context);
                        });
                  },
                ),
              ));
        },
      ),
    )
        : Container();
  }
}