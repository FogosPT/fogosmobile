import 'package:fogos_api/features/latest_warnings/data/fires_service.dart'
    show FiresService;
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:warnings_core/logger.dart';

class FiresLatestService {
  final FiresService firesRepository;

  const FiresLatestService(this.firesRepository);

  Future<List<Fire>> fetchLatestFires() async {
    try {
      final firesData = await firesRepository.listActiveFires();
      return firesData.data;
    } catch (e) {
      log(e);
      rethrow;
    }
  }
}
