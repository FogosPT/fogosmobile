import 'package:fogosmobile/actions/ipma_actions.dart';
import 'package:fogosmobile/constants/ipma_layers.dart';

Set<String> ipmaLayersReducer(Set<String> state, action) {
  if (action is ToggleIpmaLayerAction) {
    final next = Set<String>.from(state);
    if (next.contains(action.key)) {
      next.remove(action.key);
      return next;
    }
    // AROME forecast layers are mutually exclusive (radio behaviour, matching
    // the web). Picking one drops any other AROME layer currently active.
    final isArome =
        ipmaAromeGroups.any((g) => g.key == action.key);
    if (isArome) {
      next.removeWhere(
          (k) => ipmaAromeGroups.any((g) => g.key == k));
    }
    next.add(action.key);
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
