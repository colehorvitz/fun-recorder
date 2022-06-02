import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fun_recorder/blocs/simple_int_cubit/simple_int_cubit.dart';
import 'package:fun_recorder/ui/screens/post_recorder.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SimpleIntCubit>(
      create: (_) => SimpleIntCubit(0),
      child: BlocBuilder<SimpleIntCubit, int>(builder: (context, i) {
        return CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              onTap: (index) {
                context.read<SimpleIntCubit>().setInt(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: FaIcon(
                    i == 0 ? CupertinoIcons.mic_fill : CupertinoIcons.mic,
                    color: i == 0
                        ? CupertinoColors.black
                        : CupertinoColors.systemGrey2,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    i == 1 ? CupertinoIcons.folder_fill : CupertinoIcons.folder,
                    color: i == 1
                        ? CupertinoColors.black
                        : CupertinoColors.systemGrey2,
                  ),
                ),
              ],
            ),
            tabBuilder: (context, index) {
              return PostRecorder();
            });
      }),
    );
  }
}
