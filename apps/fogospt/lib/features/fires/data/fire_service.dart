import 'package:fogos_api/features/latest_warnings/data/fires_repository.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:fogos_api/features/latest_warnings/domain/history_status.dart';
import 'package:fogos_api/features/latest_warnings/domain/rcm.dart';
import 'package:fogos_api/features/latest_warnings/domain/resources.dart';

class FireService {
  final FiresRepository firesRepository;

  const FireService.FireService(this.firesRepository);

  Future<Fire> fetchFire(String id) async {
    try {
      return await firesRepository.getFireById(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Resources>> fetchResources(String id) async {
    try {
      return await firesRepository.getResources(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<HistoryStatus>> fetchHistoryStatuses(String id) async {
    try {
      return await firesRepository.getFireHistoryStatuses(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RCM>> fetchRCM(String id) async {
    try {
      return firesRepository.getRCM(id);
    } catch (e) {
      rethrow;
    }
  }
}
