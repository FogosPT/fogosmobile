import 'package:flutter/material.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:fogospt/constants/assets.dart';
import 'package:fogospt/widgets/app_fogos_title_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:warnings/warnings.dart';

class MapPageModalContentView extends StatelessWidget {
  final Fire fire;
  const MapPageModalContentView({
    super.key,
    required this.fire,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
        left: 8,
        right: 8,
        top: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// First column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FireModalUpdatedWidget(fire: fire),
                    _FireModalLocationWidget(fire: fire),
                    _FireModalStatusWidget(fire: fire),
                  ],
                ),
              ),

              /// Second column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _FireModalResourcesWidget(fire: fire),
                  ],
                ),
              ),
            ],
          ),
          TextButton.icon(
              onPressed: () {
                _navigateToDetail(context, fire.id);
              },
              icon: Icon(
                Icons.info_outline,
                color: Colors.blue,
              ),
              label: Text(
                'mais informações'.toUpperCase(),
                style: TextStyle(
                  color: Colors.blue,
                ),
              ))
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context, String fireId) {
    /// Navigates to detail.
    context.go('/fire-detail', extra: fireId);

    /// Pops the bottom sheet opened.
    context.pop();
  }
}

class _FireModalLocationWidget extends StatelessWidget {
  final Fire fire;
  const _FireModalLocationWidget({
    required this.fire,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFogosTitleWidget(
          title: "local",
        ),
        Text(
          fire.location,
          style: context.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _FireModalStatusWidget extends StatelessWidget {
  final Fire fire;
  const _FireModalStatusWidget({
    required this.fire,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFogosTitleWidget(
          title: "estado",
        ),
        Text(
          fire.status,
          style: context.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _FireModalResourcesWidget extends StatelessWidget {
  final Fire fire;
  const _FireModalResourcesWidget({
    required this.fire,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFogosTitleWidget(
          title: "meios",
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconAndValueWidget(
              icon: FogosAppAssets.getAsset(ResourcesType.man),
              value: fire.man,
            ),
            IconAndValueWidget(
              icon: FogosAppAssets.getAsset(ResourcesType.terrain),
              value: fire.terrain,
            ),
            IconAndValueWidget(
              icon: FogosAppAssets.getAsset(ResourcesType.aerial),
              value: fire.aerial,
            ),
          ],
        ),
      ],
    );
  }
}

class _FireModalUpdatedWidget extends StatelessWidget {
  final Fire fire;
  const _FireModalUpdatedWidget({
    required this.fire,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFogosTitleWidget(
          title: "Início",
        ),
        Text(
          "${fire.date} ${fire.hour}",
          style: context.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
