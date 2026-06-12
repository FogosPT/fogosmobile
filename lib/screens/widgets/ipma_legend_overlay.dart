import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/constants/ipma_layers.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:redux/redux.dart';

class IpmaLegendOverlay extends StatelessWidget {
  const IpmaLegendOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Set<String>>(
      distinct: true,
      converter: (Store<AppState> store) => store.state.activeIpmaLayers,
      builder: (context, active) {
        final visible = ipmaAllGroups
            .where((g) => active.contains(g.key) && g.key != ipmaFrpGroup.key)
            .toList();
        if (visible.isEmpty) return const SizedBox.shrink();

        return Positioned(
          bottom: 12,
          left: 8,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(6),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final group in visible)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            group.label,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Image.network(
                            ipmaLegendUrl(group.legendLayerName),
                            height: 200,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                                const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
