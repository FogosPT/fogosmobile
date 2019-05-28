import 'package:flutter/gestures.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/contributors_actions.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/screens/about/contributor_item.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/utils/uri_utils.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class About extends StatelessWidget {
  Widget contributorsWidget() {
    return new StoreConnector<AppState, AppState>(
        converter: (Store<AppState> store) => store.state,
        onInit: (Store<AppState> store) {
          if(!store.state.hasContributors) {
            store.dispatch(LoadContributorsAction());
          }
        },
        builder: (BuildContext context, AppState state) {
          if (state.hasContributors) {
            return new StoreConnector<AppState, List>(
                converter: (Store<AppState> store) => store.state.contributors,
                builder: (BuildContext context, List contributors) {
                  if (contributors != null) {
                    return Scrollbar(
                        child: ListView.builder(
                          padding: EdgeInsets.only(top: 8.0),
                          itemBuilder: (_, int i) => ContributorItem(contributor: contributors[i]),
                          itemCount: contributors.length,
                        ));
                  }
                });
          } else {
            return new Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new FireGradientAppBar(
          title: new Text(
            'Sobre',
            style: new TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: RichText(
                    text: new TextSpan(
                      children: [
                        new TextSpan(
                          text: FogosLocalizations.of(context).textRecordsFrom,
                          style: new TextStyle(color: Colors.black),
                        ),
                        new TextSpan(
                          text: FogosLocalizations.of(context).textCivilProtection,
                          style: new TextStyle(color: Colors.blue),
                          recognizer: new TapGestureRecognizer()..onTap = () => launchURL('http://www.prociv.pt/'),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(FogosLocalizations.of(context).textDataUpdate),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(FogosLocalizations.of(context).textLocationApproximate),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: RichText(
                    text: new TextSpan(
                      children: [
                        new TextSpan(
                          text: FogosLocalizations.of(context).textBugs,
                          style: new TextStyle(color: Colors.black),
                        ),
                        new TextSpan(
                          text: 'mail@fogos.pt.',
                          style: new TextStyle(color: Colors.blue),
                          recognizer: new TapGestureRecognizer()..onTap = () => launchURL('mailto:mail@fogos.pt'),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text('Made with ♥ by:'),
                ),
                Flexible(child: contributorsWidget())
              ],
            ),
          ),
        ));
  }
}
