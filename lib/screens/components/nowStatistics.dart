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
      converter: (Store<AppState> store) => store.state.nowStats,
      builder: (BuildContext context, NowStats stats) {
        if (stats == null) {
          return Center(child: CircularProgressIndicator());
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildItem(imgSvgIconFire, stats.total, 35, Colors.red),
              _buildItem(imgSvgFireman, stats.man),
              _buildItem(imgSvgFireTruck, stats.cars),
              _buildItem(imgSvgPlane, stats.aerial),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem(String imgPath, String text,
      [double height = 50.0, Color color]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          imgPath,
          height: height,
          color: color,
        ),
        SizedBox(
          width: 5,
        ),
        Text(text, style: _body),
      ],
    );
  }
}
