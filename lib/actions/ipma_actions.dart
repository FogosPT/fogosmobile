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

class LoadIpmaWindAction {}

class IpmaWindGridLoadedAction {
  final dynamic grid; // IpmaWindGrid? — kept dynamic to avoid model coupling
  IpmaWindGridLoadedAction(this.grid);
}

class IpmaWindGridLoadingAction {
  final bool loading;
  IpmaWindGridLoadingAction(this.loading);
}
