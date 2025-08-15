import 'package:fogos_api/features/latest_warnings/data/fires_service.dart'
    show FiresService;
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:fogos_api/features/latest_warnings/domain/history_status.dart';
import 'package:fogos_api/features/latest_warnings/domain/rcm.dart';
import 'package:fogos_api/features/latest_warnings/domain/resources.dart';
import 'package:get_it/get_it.dart';

class FiresRepository {
  late final FiresService firesService;

  FiresRepository.FireService()
    : this.firesService = GetIt.I.get<FiresService>();

  Future<Fire> fetchFire(String id) async {
    try {
      return await firesService.getFireById(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Resources>> fetchResources(String id) async {
    try {
      return await firesService.getResources(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<HistoryStatus>> fetchHistoryStatuses(String id) async {
    try {
      return await firesService.getFireHistoryStatuses(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RCM>> fetchRCM(String id) async {
    try {
      return firesService.getRCM(id);
    } catch (e) {
      rethrow;
    }
  }
}
