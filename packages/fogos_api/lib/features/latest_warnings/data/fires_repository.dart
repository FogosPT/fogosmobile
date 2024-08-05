import 'dart:convert';

import 'package:fogos_api/constants/logger.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:fogos_api/features/latest_warnings/domain/fires.dart';
import 'package:fogos_api/features/latest_warnings/domain/history_status.dart';
import 'package:fogos_api/features/latest_warnings/domain/rcm.dart';
import 'package:fogos_api/features/latest_warnings/domain/resources.dart';
import 'package:fogos_api/networking/fogos_base_client.dart';

class FiresRepository {
  final FogosBaseClient _fogosApi;

  FiresRepository(this._fogosApi);

  Future<Fires> listActiveFires() async {
    final response = await _fogosApi.listActiveFires();

    if (response.statusCode != 200) {
      throw Exception('Failed to list active fires');
    }

    final body = json.decode(response.body);
    log(body);

    final fires = Fires.fromJson(body);
    log(fires);

    fires.data
        .map(
          (fire) => fire.copyWith(
            fireStatus: Fire.fromStatusToFireStatus(fire.status),
          ),
        )
        .toList();

    return fires;
  }

  Future<List<Resources>> getResources(String id) async {
    final response =
        await _fogosApi.getFireHistoryResourcesManAerialTerrain(id);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch resources information');
    }
    final body = json.decode(response.body);
    log(body);

    if (body['success']) {
      final data = body['data'] as List<dynamic>;
      final resources = data
          .map((item) => Resources.fromJson(item as Map<String, dynamic>))
          .toList();
      log(resources);

      return resources;
    } else {
      throw Exception('Failed to fetch fire information');
    }
  }

  Future<Fire> getFireById(String id) async {
    final response = await _fogosApi.getSingleFireInformation(id);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch fire information');
    }

    final body = json.decode(response.body);
    log(body);

    if (body['success']) {
      final fire = Fire.fromJson(body['data']);
      log(fire);

      return fire;
    } else {
      throw Exception('Failed to fetch fire information');
    }
  }

  Future<List<HistoryStatus>> getFireHistoryStatuses(String id) async {
    final response = await _fogosApi.getFireHistoryStatus(id);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch fire information');
    }

    final body = json.decode(response.body);
    log(body);

    if (body['success']) {
      final data = body['data'] as List<dynamic>;
      final historyStatus = data
          .map((item) => HistoryStatus.fromJson(item as Map<String, dynamic>))
          .toList();
      log(historyStatus);

      return historyStatus;
    } else {
      throw Exception('Failed to fetch fire information');
    }
  }

  Future<List<RCM>> getRCM(String id) async {
    final response = await _fogosApi.getFireRCMForTodayTomorrowAndAfter(id);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch fire information');
    }

    final body = json.decode(response.body);
    log(body);

    if (body['success']) {
      final data = body['data'] as List<dynamic>;
      final rcm = data
          .map((item) => RCM.fromJson(item as Map<String, dynamic>))
          .toList();
      log(rcm);

      return rcm;
    } else {
      throw Exception('Failed to fetch fire information');
    }
  }
}
