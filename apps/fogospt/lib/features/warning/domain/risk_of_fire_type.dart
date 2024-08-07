import 'package:flutter/material.dart';

enum RiskOfFireType {
  reduced, // Reduzido
  moderated, // Moderado
  elevated, // Elevado
  highElevated, // Muito Elevado
  maximum; // Maximo

  Color get color {
    return switch (this) {
      RiskOfFireType.reduced => Colors.green,
      RiskOfFireType.moderated => Colors.yellow,
      RiskOfFireType.elevated => Colors.orange,
      RiskOfFireType.highElevated => Colors.red,
      RiskOfFireType.maximum => Colors.brown,
    };
  }

  static RiskOfFireType fromText(String text) {
    return switch (text) {
      "Reduzido" => RiskOfFireType.reduced,
      "Moderado" => RiskOfFireType.moderated,
      "Elevado" => RiskOfFireType.elevated,
      "Muito Elevado" => RiskOfFireType.highElevated,
      "Maximo" => RiskOfFireType.maximum,
      _ => throw Exception("Unknown RiskOfFire type"),
    };
  }

  String get text {
    return switch (this) {
      RiskOfFireType.reduced => "Reduzido",
      RiskOfFireType.moderated => "Moderado",
      RiskOfFireType.elevated => "Elevado",
      RiskOfFireType.highElevated => "Muito Elevado",
      RiskOfFireType.maximum => "Maximo",
    };
  }
}
