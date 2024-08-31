import 'package:fogos_api/features/latest_warnings/data/fires_repository.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:warnings_core/warnings_core.dart';

class FiresLatestService {
  final FiresRepository firesRepository;

  const FiresLatestService(this.firesRepository);

  Future<List<Fire>> fetchLatestFires() async {
    try {
      final firesData = await firesRepository.listActiveFires();
      return firesData.data;
    } catch (e) {
      log(e);
      rethrow;
      // return Fires(data: [], success: false);
    }
  }
}
