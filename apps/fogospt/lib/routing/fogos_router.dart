import 'package:flutter/material.dart';
import 'package:fogospt/constants/assets.dart';
import 'package:fogospt/features/fires/presentation/pages/fire_detail_page.dart';
import 'package:fogospt/features/map/presentation/pages/fires_map_page.dart';
import 'package:fogospt/features/see_partners/presentation/partners_page.dart';
import 'package:go_router/go_router.dart';

final fogos_router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => FiresMapPage(),
      routes: [
        GoRoute(
          path: 'fire-detail',
          builder: (context, state) {
            if (state.extra is! String) {
              throw Exception('Invalid fire id');
            }

            final fireId = state.extra as String;
            return FireDetailPage(fireId: fireId);
          },
        ),
        GoRoute(
          path: 'about',
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('About'),
              ),
              body: const Center(
                child: Text('About'),
              ),
            );
          },
        ),
        GoRoute(
          path: 'partners',
          builder: (context, state) {
            return PartnersPage(
              partners: [
                partnerMapbox,
                partnerOfficelan,
                partnerFundacaoLapalobo,
              ],
            );
          },
        )
      ],
    ),
  ],
);
