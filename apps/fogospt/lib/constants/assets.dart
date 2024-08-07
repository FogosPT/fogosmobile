import 'package:flutter_svg/flutter_svg.dart';

enum ResourcesType {
  man,
  terrain,
  aerial,
}

class FogosAppAssets {
  static SvgPicture getAsset(ResourcesType type) => switch (type) {
        ResourcesType.man => _man,
        ResourcesType.terrain => _terrain,
        ResourcesType.aerial => _aerial,
      };

  static SvgPicture _man = SvgPicture.asset(
    'assets/fireman.svg',
  );

  static SvgPicture _terrain = SvgPicture.asset(
    'assets/firetruck.svg',
  );

  static SvgPicture _aerial = SvgPicture.asset(
    'assets/plane.svg',
  );
}

SvgPicture icoFire = SvgPicture.asset(
  'assets/icons/ico_fire.svg',
);
SvgPicture icoPointer = SvgPicture.asset(
  'assets/icons/ico_pointer.svg',
);
SvgPicture icoAlarm = SvgPicture.asset(
  'assets/icons/ico_alarm.svg',
);
SvgPicture icoFake = SvgPicture.asset(
  'assets/icons/ico_fake.svg',
);
SvgPicture icoWatch = SvgPicture.asset(
  'assets/icons/ico_watch.svg',
);
