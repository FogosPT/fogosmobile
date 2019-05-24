import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire_details.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

class DetailsHistoryStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DetailsHistory>(
      converter: (Store<AppState> store) => store.state.fireDetailsHistory,
      builder: (BuildContext context, DetailsHistory stats) {
        if (stats == null) {
          return Center(child: CircularProgressIndicator());
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 70),
          child: Column(
            children: <Widget>[
              for (Details details in stats.details) _buildHistory(details),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistory(Details details) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white70),
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            dense: true,
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Container(
                width: 20,
                child: SvgPicture.asset(
                    getCorrectStatusImage(details.statusCode, false),
                    semanticsLabel: 'Acme Logo'),
              ),
            ),
            title: Text(DateFormat('dd-MM-yyyy - H:mm').format(details.label)),
            subtitle: Text(details.status),
          ),
        ),
        Container(height: 50, width: 2, color: Colors.grey)
      ],
    );
  }
}
