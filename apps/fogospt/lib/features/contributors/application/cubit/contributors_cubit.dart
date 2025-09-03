import 'package:bloc/bloc.dart';
import 'package:fogos_api/features/mobile_contributors/domain/contributor.dart'
    show Contributor;
import 'package:fogospt/features/contributors/data/contributors_repository.dart'
    show ContributorsRepository;
import 'package:meta/meta.dart';

part 'contributors_state.dart';

class ContributorsCubit extends Cubit<ContributorsState> {
  final ContributorsRepository _contributorsRepository;

  ContributorsCubit()
    : this._contributorsRepository = ContributorsRepository.FireService(),
      super(ContributorsInitial());

  Future<void> fetchContributors() async {
    _contributorsRepository
        .fetchContributors()
        .then((contributors) {
          emit(ContributorsLoaded(contributors: contributors));
        })
        .catchError((error) {
          emit(ContributorsError(error: error.toString()));
        });
  }
}
