import 'package:fogosmobile/models/fire.dart';

//region Fire
const average = "average";

/// Calculates the importance of each fire

const numberOfFires = "numberOfFires";
const topImportance = "topImportance";

// List<Fire> calculateFireImportance(List<Fire> fires) {
//   var firesStatus = {numberOfFires: 0, topImportance: 0.0, average: 0.0};
//   for (var fire in fires) {
//     if (fire.important == true) {
//       fire.importance = 1 * 1.5;
//     }
//   }

//   for (var fire in fires) {
//     fire.scale = getPonderatedImportanceFactor(
//             fire.importance, fire.statusCode, firesStatus) /
//         1.5;
//   }
//   return fires;
// }

double getPonderatedImportanceFactor(
  double importance,
  statusCode,
  Map<String, dynamic> status,
) {
  var importanceScale = 0.0;

  // check for fake alarm's or calls
  if (statusCode == 11 || statusCode == 12) {
    return 0.8;
  }

  if (importance > status[average]) {
    var topPercentage = importance / status[topImportance];
    topPercentage *= 2.3;
    topPercentage += 0.5;

    var avgPercentage = status[average] / importance;

    importanceScale = topPercentage - avgPercentage;

    if (importanceScale > 1.75) {
      importanceScale = 1.75;
    }

    if (importanceScale < 1) {
      importanceScale = 1;
    }
  }

  if (importance < status[average]) {
    var avgPercentage = importance / status[average] * 0.8;
    if (avgPercentage < 0.9) {
      importanceScale = 0.9;
    } else {
      importanceScale = avgPercentage;
    }
  }
  return importanceScale;
}

/// TODO(FB): Currently not used but definitely should be.
// ignore: unused_element
double _calculateImportanceValue(Fire data, Map<String, dynamic> status) {
  var manFactor = 1.0;
  var terrainFactor = 3.0;
  var aerialFactor = 7.0;
  var importantFireFactor = 1.0;

  if (data.important == true) {
    importantFireFactor = 2.0;
  }

  var importance = data.human * manFactor +
      data.terrain * terrainFactor +
      data.aerial * aerialFactor * importantFireFactor;
  status[numberOfFires] += 1;
  if (status[topImportance] < importance) {
    status[topImportance] = importance;
  }

  status[average] =
      (status[average] * (status[numberOfFires] - 1) + importance) /
          (status[numberOfFires]);
  return importance;
}
//endregion
