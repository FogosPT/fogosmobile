import 'package:fogospt/features/contributors/data/contributors_service.dart'
    show ContributorsService;
import 'package:fogospt/features/contributors/domain/contributor.dart';
import 'package:get_it/get_it.dart' show GetIt;

class ContributorsRepository {
  late final ContributorsService contributorsService;

  ContributorsRepository.FireService()
    : this.contributorsService = GetIt.I.get<ContributorsService>();

  Future<List<Contributor>> fetchContributors(String id) async {
    try {
      return await contributorsService.getContributors();
    } catch (e) {
      rethrow;
    }
  }
}
