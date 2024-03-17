import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/contributors_actions.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/contributor.dart';
import 'package:fogosmobile/screens/about/contributor_item.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/utils/uri_utils.dart';
import 'package:redux/redux.dart';

class About extends StatelessWidget {
  const About();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FireGradientAppBar(
        bottom: TabBar(tabs: []),
        actions: [],
        title: Text('Sobre', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '${FogosLocalizations.of(context).textRecordsFrom} ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text:
                            FogosLocalizations.of(context).textCivilProtection,
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchURL('http://www.prociv.pt/'),
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
                child: Text(
                  FogosLocalizations.of(context).textLocationApproximate,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: FogosLocalizations.of(context).textBugs,
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: ' mail@fogos.pt.',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchURL('mailto:mail@fogos.pt'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text('Made with ♥ by:'),
              ),
              Flexible(child: contributorsWidget()),
            ],
          ),
        ),
      ),
    );
  }

  Widget contributorsWidget() {
    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      onInit: (Store<AppState> store) {
        if (!(store.state.hasContributors ?? false)) {
          store.dispatch(LoadContributorsAction());
        }
      },
      builder: (BuildContext context, AppState state) {
        if (state.hasContributors ?? false) {
          return StoreConnector<AppState, List<Contributor>>(
            converter: (Store<AppState> store) =>
                store.state.contributors ?? [],
            builder: (BuildContext context, List<Contributor>? contributors) {
              return Scrollbar(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 8.0),
                  itemBuilder: (_, int i) {
                    return ContributorItem(contributor: contributors![i]);
                  },
                  itemCount: contributors?.length ?? 0,
                ),
              );
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
