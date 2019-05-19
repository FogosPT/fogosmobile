import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/statistics.dart';
import 'package:fogosmobile/screens/assets/icons.dart';
import 'package:fogosmobile/screens/assets/images.dart';
import 'package:redux/redux.dart';

class NowStatistics extends StatelessWidget {
  final TextStyle _body = TextStyle(color: Colors.black, fontSize: 30);

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
              children: <Widget>[
                SvgPicture.asset(
                  imgSvgIconFire,
                  height: 35,
                  color: Colors.red,
                ),
                Text(stats.total, style: _body),
                SizedBox(width: 25),
                SvgPicture.asset(imgSvgFireman, height: 50),
                Text(stats.man, style: _body),
                SizedBox(width: 25),
                SvgPicture.asset(imgSvgFireTruck, height: 50),
                Text(stats.cars, style: _body),
                SizedBox(width: 25),
                SvgPicture.asset(imgSvgPlane, height: 50),
                Text(stats.aerial, style: _body),
              ],
            ),
          );
        });
  }
}
