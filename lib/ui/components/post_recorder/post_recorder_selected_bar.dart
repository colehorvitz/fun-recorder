import 'package:flutter/cupertino.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:fun_recorder/models/recording_filter_model.dart';
import 'package:fun_recorder/models/recording_segment_model.dart';
import 'package:fun_recorder/services/hex_color.dart';
import 'package:fun_recorder/ui/components/responsive_buttons/responsive_tap_widget.dart';

class PostRecorderSelectedBar extends StatelessWidget {
  final RecordingSegmentModel segment;
  final VoidCallback onDelete;

  const PostRecorderSelectedBar({Key key, this.segment, this.onDelete})
      : super(key: key);

  IconData get iconData {
    switch (segment.filter) {
      case RecordingFilter.robot:
        return MaterialCommunityIcons.robot;
      case RecordingFilter.high:
        return MaterialCommunityIcons.waveform;
      case RecordingFilter.low:
        return MaterialCommunityIcons.wave;
      case RecordingFilter.echo:
        return CupertinoIcons.antenna_radiowaves_left_right;
      case RecordingFilter.wobble:
        return MaterialCommunityIcons.sine_wave;
      case RecordingFilter.reverse:
        return Foundation.refresh;
      case RecordingFilter.loud:
        return FontAwesome.bomb;
      case RecordingFilter.normal:
      default:
        return CupertinoIcons.home;
    }
  }

  Color get color {
    switch (segment.filter) {
      case RecordingFilter.robot:
        return HexColor('5F5FFF');
      case RecordingFilter.high:
        return HexColor('52D885');
      case RecordingFilter.low:
        return HexColor('FF9A19');
      case RecordingFilter.echo:
        return HexColor('BB48EB');
      case RecordingFilter.wobble:
        return HexColor('8BCB27');
      case RecordingFilter.reverse:
        return HexColor('F56780');
      case RecordingFilter.loud:
        return HexColor('2FC6F8');
      case RecordingFilter.normal:
      default:
        return HexColor('FF4545');
    }
  }

  String get text {
    switch (segment.filter) {
      case RecordingFilter.robot:
        return "Robot".toUpperCase();
      case RecordingFilter.high:
        return "High-Pitch".toUpperCase();
      case RecordingFilter.low:
        return "Low-Pitch".toUpperCase();
      case RecordingFilter.echo:
        return "Echo".toUpperCase();
      case RecordingFilter.wobble:
        return "Wobble".toUpperCase();
      case RecordingFilter.reverse:
        return "Reverse".toUpperCase();
      case RecordingFilter.loud:
        return "Loud".toUpperCase();
      case RecordingFilter.normal:
      default:
        return "Normal".toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: EdgeInsets.symmetric(horizontal: 42),
      child: ResponsiveTapWidget(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: CupertinoColors.systemGrey5),
        defaultColor: CupertinoColors.white,
        activeColor: CupertinoColors.systemGrey6,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconData,
                    color: color,
                  ),
                  SizedBox(width: 8),
                  RichText(
                    text: TextSpan(
                      style:
                          TextStyle(color: CupertinoColors.black, fontSize: 16),
                      children: [
                        TextSpan(
                            text: text,
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${segment.duration.inSeconds}s',
                    style: TextStyle(color: CupertinoColors.systemGrey),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    CupertinoIcons.xmark,
                    color: CupertinoColors.systemGrey,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
