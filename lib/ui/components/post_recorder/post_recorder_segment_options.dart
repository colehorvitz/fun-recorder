import 'package:flutter/cupertino.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:fun_recorder/models/recording_filter_model.dart';
import 'package:fun_recorder/models/recording_segment_model.dart';
import 'package:fun_recorder/ui/components/options/option.dart';
import 'package:fun_recorder/ui/components/options/options.dart';

class PostRecorderSegmentOptions extends StatelessWidget {
  final RecordingSegmentModel segment;

  const PostRecorderSegmentOptions({Key key, this.segment}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Options(
      options: [
        Option(
          iconData: CupertinoIcons.trash,
          isDestructive: true,
          text: "Delete Clip",
          onTap: () {
            Navigator.of(context).pop('delete');
          },
        ),
        Option(
          iconData: iconData,
          text: "Change Filter",
          onTap: () {
            Navigator.of(context).pop('change-filter');
          },
        )
      ],
    );
  }
}
