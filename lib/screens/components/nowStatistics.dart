import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/statistics.dart';
import 'package:fogosmobile/screens/assets/icons.dart';
import 'package:fogosmobile/screens/assets/images.dart';
import 'package:redux/redux.dart';

class NowStatistics extends StatelessWidget {
  final TextStyle _body = TextStyle(color: Colors.black, fontSize: 25);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NowStats>(
      converter: (Store<AppState> store) =>
          store.state.nowStats ??
          NowStats(man: '', aerial: '', cars: '', total: ''),
      builder: (BuildContext context, NowStats stats) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildItem(imgSvgIconFire, stats.total, 35),
              _buildItem(imgSvgFireman, stats.man),
              _buildItem(imgSvgFireTruck, stats.cars),
              _buildItem(imgSvgPlane, stats.aerial),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem(
    String imgPath,
    String text, [
    double height = 50.0,
    Color color = Colors.red,
  ]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          imgPath,
          height: height,
          colorFilter: ColorFilter.mode(
            color,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 5),
        Text(text, style: _body),
      ],
    );
  }
}
