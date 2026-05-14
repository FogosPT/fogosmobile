import 'package:fogosmobile/actions/ipma_actions.dart';

Set<String> ipmaLayersReducer(Set<String> state, action) {
  if (action is ToggleIpmaLayerAction) {
    final next = Set<String>.from(state);
    if (next.contains(action.key)) {
      next.remove(action.key);
    } else {
      next.add(action.key);
    }
    return next;
  } else if (action is IpmaLayersLoadedAction) {
    return Set<String>.from(action.keys);
  }
  return state;
}

class IpmaReferenceTimeState {
  final String? value;
  final bool loaded;
  const IpmaReferenceTimeState(this.value, this.loaded);
}

IpmaReferenceTimeState ipmaReferenceTimeReducer(
    IpmaReferenceTimeState state, action) {
  if (action is IpmaReferenceTimeLoadedAction) {
    return IpmaReferenceTimeState(action.referenceTime, true);
  }
  return state;
}
