class ToggleIpmaLayerAction {
  final String key;
  ToggleIpmaLayerAction(this.key);
}

class IpmaLayersLoadedAction {
  final Set<String> keys;
  IpmaLayersLoadedAction(this.keys);
}

class LoadIpmaReferenceTimeAction {}

class IpmaReferenceTimeLoadedAction {
  final String? referenceTime;
  IpmaReferenceTimeLoadedAction(this.referenceTime);
}
