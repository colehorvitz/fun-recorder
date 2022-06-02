import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fun_recorder/blocs/simple_double_cubit/simple_double_cubit.dart';
import '../../../../constants/constants.dart';
import '../../../../models/recording_filter_model.dart';
import 'default_record_button.dart';
import 'echo_record_button.dart';
import 'high_pitch_record_button.dart';
import 'loud_record_button.dart';
import 'low_pitch_record_button.dart';
import 'reverse_record_button.dart';
import 'robot_record_button.dart';
import 'wobble_record_button.dart';

class MessageRoomRecorderPageView extends StatefulWidget {
  final PageController controller;
  final Function(RecordingFilter) onFilterChanged;
  final Function(RecordingFilter) onTapActiveButton;
  final Function(RecordingFilter) onLongPressButton;
  final Function(RecordingFilter) onLongPressButtonEnd;
  final bool isRecording;
  final RecordingFilter activeFilter;
  final double buttonSize;
  final double iconSize;

  const MessageRoomRecorderPageView(
      {Key key,
      this.controller,
      this.onFilterChanged,
      this.onTapActiveButton,
      this.onLongPressButton,
      this.isRecording,
      this.activeFilter,
      this.onLongPressButtonEnd,
      this.buttonSize,
      this.iconSize})
      : super(key: key);

  @override
  State<MessageRoomRecorderPageView> createState() =>
      _MessageRoomRecorderPageViewState();
}

class _MessageRoomRecorderPageViewState
    extends State<MessageRoomRecorderPageView> {
  SimpleDoubleCubit _pageCubit;

  void _onTapInactiveButton(int index) {
    widget.controller.animateToPage(index,
        duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_pageCubit != null) {
      _pageCubit.setDouble(widget.controller.page);
    }
  }

  RecordingFilter _getFilter(int index) {
    switch (index) {
      case robotRecorderIndex:
        return RecordingFilter.robot;
      case highPitchRecorderIndex:
        return RecordingFilter.high;
      case lowPitchRecorderIndex:
        return RecordingFilter.low;
      case echoRecorderIndex:
        return RecordingFilter.echo;
      case wobbleRecorderIndex:
        return RecordingFilter.wobble;
      case reverseRecorderIndex:
        return RecordingFilter.reverse;
      case loudRecorderIndex:
        return RecordingFilter.loud;
      case defaultRecorderIndex:
      default:
        return RecordingFilter.normal;
    }
  }

  int _getFilterIndex(RecordingFilter filter) {
    switch (filter) {
      case RecordingFilter.robot:
        return robotRecorderIndex;
      case RecordingFilter.high:
        return highPitchRecorderIndex;
      case RecordingFilter.low:
        return lowPitchRecorderIndex;
      case RecordingFilter.echo:
        return echoRecorderIndex;
      case RecordingFilter.wobble:
        return wobbleRecorderIndex;
      case RecordingFilter.reverse:
        return reverseRecorderIndex;
      case RecordingFilter.loud:
        return loudRecorderIndex;
      case RecordingFilter.normal:
      default:
        return defaultRecorderIndex;
    }
  }

  int _getDistance(RecordingFilter activeFilter, int index) {
    final activeIndex = _getFilterIndex(activeFilter);
    return (index - activeIndex).abs();
  }

  double _getSize(int index, double page, double maxSize) {
    final diff = index - page;
    final baseline = .75;
    final magnification = 1 - baseline;
    if (diff.abs() < 1) {
      return (baseline + (magnification * (1 - diff.abs()))) * maxSize;
    }
    return baseline * maxSize;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SimpleDoubleCubit>(
      create: (_) => _pageCubit = SimpleDoubleCubit(0),
      child: BlocBuilder<SimpleDoubleCubit, double>(builder: (context, page) {
        return Container(
          height: 64,
          child: PageView(
            physics: BouncingScrollPhysics(),
            controller: widget.controller,
            padEnds: true,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index) {
              widget.onFilterChanged(_getFilter(index));
              HapticFeedback.lightImpact();
            },
            children: [
              DefaultRecordButton(
                size: _getSize(0, page, widget.buttonSize),
                onTap: () => widget.onTapActiveButton(RecordingFilter.normal),
                onLongPress: () =>
                    widget.onLongPressButton(RecordingFilter.normal),
                onLongPressEnd: () =>
                    widget.onLongPressButtonEnd(RecordingFilter.normal),
                distance:
                    _getDistance(widget.activeFilter, defaultRecorderIndex),
                onTapWhileDisabled: () =>
                    _onTapInactiveButton(defaultRecorderIndex),
                recording: widget.isRecording,
                selected: widget.activeFilter == RecordingFilter.normal,
              ),
              RobotRecordButton(
                  size: _getSize(1, page, widget.buttonSize),
                  iconSize: _getSize(1, page, widget.iconSize),
                  onTap: () => widget.onTapActiveButton(RecordingFilter.robot),
                  onLongPress: () =>
                      widget.onLongPressButton(RecordingFilter.robot),
                  onLongPressEnd: () =>
                      widget.onLongPressButtonEnd(RecordingFilter.robot),
                  distance:
                      _getDistance(widget.activeFilter, robotRecorderIndex),
                  onTapWhileDisabled: () =>
                      _onTapInactiveButton(robotRecorderIndex),
                  recording: widget.isRecording,
                  selected: widget.activeFilter == RecordingFilter.robot),
              HighPitchRecordButton(
                  size: _getSize(2, page, widget.buttonSize),
                  iconSize: _getSize(2, page, widget.iconSize),
                  onTap: () => widget.onTapActiveButton(RecordingFilter.high),
                  onLongPress: () =>
                      widget.onLongPressButton(RecordingFilter.high),
                  onLongPressEnd: () =>
                      widget.onLongPressButtonEnd(RecordingFilter.high),
                  distance:
                      _getDistance(widget.activeFilter, highPitchRecorderIndex),
                  onTapWhileDisabled: () =>
                      _onTapInactiveButton(highPitchRecorderIndex),
                  recording: widget.isRecording,
                  selected: widget.activeFilter == RecordingFilter.high),
              LowPitchRecordButton(
                  size: _getSize(3, page, widget.buttonSize),
                  iconSize: _getSize(3, page, widget.iconSize),
                  onLongPress: () =>
                      widget.onLongPressButton(RecordingFilter.low),
                  onLongPressEnd: () =>
                      widget.onLongPressButtonEnd(RecordingFilter.low),
                  distance:
                      _getDistance(widget.activeFilter, lowPitchRecorderIndex),
                  onTap: () => widget.onTapActiveButton(RecordingFilter.low),
                  onTapWhileDisabled: () =>
                      _onTapInactiveButton(lowPitchRecorderIndex),
                  recording: widget.isRecording,
                  selected: widget.activeFilter == RecordingFilter.low),
              EchoRecordButton(
                  size: _getSize(4, page, widget.buttonSize),
                  iconSize: _getSize(4, page, widget.iconSize),
                  onLongPress: () =>
                      widget.onLongPressButton(RecordingFilter.echo),
                  onLongPressEnd: () =>
                      widget.onLongPressButtonEnd(RecordingFilter.echo),
                  onTap: () => widget.onTapActiveButton(RecordingFilter.echo),
                  distance:
                      _getDistance(widget.activeFilter, echoRecorderIndex),
                  onTapWhileDisabled: () =>
                      _onTapInactiveButton(echoRecorderIndex),
                  recording: widget.isRecording,
                  selected: widget.activeFilter == RecordingFilter.echo),
              WobbleRecordButton(
                  size: _getSize(5, page, widget.buttonSize),
                  iconSize: _getSize(5, page, widget.iconSize),
                  onLongPress: () =>
                      widget.onLongPressButton(RecordingFilter.wobble),
                  onLongPressEnd: () =>
                      widget.onLongPressButtonEnd(RecordingFilter.wobble),
                  onTap: () => widget.onTapActiveButton(RecordingFilter.wobble),
                  distance:
                      _getDistance(widget.activeFilter, wobbleRecorderIndex),
                  onTapWhileDisabled: () =>
                      _onTapInactiveButton(wobbleRecorderIndex),
                  recording: widget.isRecording,
                  selected: widget.activeFilter == RecordingFilter.wobble),
              ReverseRecordButton(
                  size: _getSize(6, page, widget.buttonSize),
                  iconSize: _getSize(6, page, widget.iconSize),
                  onLongPress: () =>
                      widget.onLongPressButton(RecordingFilter.reverse),
                  onLongPressEnd: () =>
                      widget.onLongPressButtonEnd(RecordingFilter.reverse),
                  onTap: () =>
                      widget.onTapActiveButton(RecordingFilter.reverse),
                  distance:
                      _getDistance(widget.activeFilter, reverseRecorderIndex),
                  onTapWhileDisabled: () =>
                      _onTapInactiveButton(reverseRecorderIndex),
                  recording: widget.isRecording,
                  selected: widget.activeFilter == RecordingFilter.reverse),
              LoudRecordButton(
                  size: _getSize(7, page, widget.buttonSize),
                  iconSize: _getSize(7, page, widget.iconSize),
                  onLongPress: () =>
                      widget.onLongPressButton(RecordingFilter.loud),
                  onLongPressEnd: () =>
                      widget.onLongPressButtonEnd(RecordingFilter.loud),
                  onTap: () => widget.onTapActiveButton(RecordingFilter.loud),
                  distance:
                      _getDistance(widget.activeFilter, loudRecorderIndex),
                  onTapWhileDisabled: () =>
                      _onTapInactiveButton(loudRecorderIndex),
                  recording: widget.isRecording,
                  selected: widget.activeFilter == RecordingFilter.loud),
            ],
          ),
        );
      }),
    );
  }
}
