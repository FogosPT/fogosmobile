import 'package:flutter/material.dart';
import 'package:warnings/state_management/base_state.dart';

class StateWidget extends StatelessWidget {
  final BaseState state;
  final Widget child;
  final bool onSuccessExtraConditionals;
  final Widget? failureWidget;
  final Widget? customLoadingWidget;

  const StateWidget._({
    required this.state,
    required this.child,
    this.onSuccessExtraConditionals = true,
    this.failureWidget,
    this.customLoadingWidget,
  });

  factory StateWidget.simple(
    BaseState state, {
    required Widget child,
  }) {
    return StateWidget._(
      state: state,
      child: child,
    );
  }

  factory StateWidget.simpleWithConditionals(
    BaseState state, {
    required Widget child,
    required bool onSuccessExtraConditionals,
  }) {
    return StateWidget._(
      state: state,
      onSuccessExtraConditionals: onSuccessExtraConditionals,
      failureWidget: null,
      customLoadingWidget: null,
      child: child,
    );
  }

  factory StateWidget.simpleWithCustomFailure(
    BaseState state, {
    required Widget child,
    required Widget errorWidget,
  }) {
    return StateWidget._(
      state: state,
      failureWidget: errorWidget,
      child: child,
    );
  }

  factory StateWidget.withCustomLoading(
    BaseState state, {
    required Widget child,
    required Widget customLoadingWidget,
  }) {
    return StateWidget._(
      state: state,
      customLoadingWidget: customLoadingWidget,
      child: child,
    );
  }

  /// This is a custom state widget that allows for custom loading and error widgets
  factory StateWidget.custom(
    BaseState state, {
    required Widget child,
    bool onSuccessExtraConditionals = true,
    Widget? errorWidget,
    Widget? customLoadingWidget,
  }) {
    return StateWidget._(
      state: state,
      onSuccessExtraConditionals: onSuccessExtraConditionals,
      failureWidget: errorWidget,
      customLoadingWidget: customLoadingWidget,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      _ when state.isLoading =>
        customLoadingWidget ?? const Center(child: CircularProgressIndicator()),
      _ when state.isSuccess && onSuccessExtraConditionals => child,
      _ => failureWidget ?? const SizedBox.shrink(),
    };
  }
}
