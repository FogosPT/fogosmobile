part of 'contributors_cubit.dart';

@immutable
sealed class ContributorsState {}

final class ContributorsInitial extends ContributorsState {}

final class ContributorsLoaded extends ContributorsState {
  final List<Contributor> contributors;

  ContributorsLoaded({required this.contributors});
}

final class ContributorsError extends ContributorsState {
  final String error;

  ContributorsError({required this.error});
}
