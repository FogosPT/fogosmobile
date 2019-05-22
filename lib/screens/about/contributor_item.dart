import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fogosmobile/models/contributor.dart';
import 'package:fogosmobile/utils/uri_utils.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ContributorItem extends StatelessWidget {
  ContributorItem({this.contributor});

  final Contributor contributor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        elevation: 0.2,
        child: ListTile(
          dense: true,
          contentPadding: EdgeInsets.only(left: 8.0, right: 8.0),
          title: (contributor.name != null && contributor.name.isNotEmpty)
              ? Text('${contributor.name}')
              : Container(),
          subtitle: (contributor.bio != null && contributor.bio.isNotEmpty)
              ? AutoSizeText('${contributor.bio}',
                  minFontSize: 10.0,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis)
              : Container(),
          leading: Container(
            width: 50,
            height: 50,
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(4.0),
              child: Stack(
                alignment: const Alignment(0.0, 1.0),
                children: [
                  CachedNetworkImage(
                    width: 50,
                    height: double.infinity,
                    fit: BoxFit.fill,
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        new Icon(Icons.account_box),
                    imageUrl: contributor.avatarUrl,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(right: 2.0, left: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                    ),
                    child: Center(
                      heightFactor: 1,
                      child: AutoSizeText(
                        contributor.login,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        minFontSize: 9.0,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () => launchURL('https://github.com/${contributor.login}'),
        ),
      ),
    );
  }
}
