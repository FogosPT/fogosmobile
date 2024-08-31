import 'package:bloc/bloc.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:fogospt/features/selected_fire/application/selected_fire/selected_fire_state.dart';

class SelectedFireCubit extends Cubit<SelectedFireState> {
  SelectedFireCubit() : super(SelectedFireInitialState());

  void selectFire(Fire fire) {
    emit(SelectedFireLoadingState());
    emit(SelectedFireLoadedState(fire));
  }
}
