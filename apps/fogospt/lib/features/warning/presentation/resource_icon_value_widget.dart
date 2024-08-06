import 'package:flutter/material.dart';

class ResourceIconValueWidget extends StatelessWidget {
  final Widget icon;
  final int value;
  final int? size;
  const ResourceIconValueWidget({
    super.key,
    required this.icon,
    required this.value,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: icon,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ],
    );
  }
}
