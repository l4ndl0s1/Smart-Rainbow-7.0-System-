import 'package:flutter/material.dart';

class TemperatureDifferenceDisplay extends StatelessWidget {
  final double difference;
  final String message;
  final Color textColor;

  const TemperatureDifferenceDisplay({
    Key? key,
    required this.difference,
    required this.message,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Text(
          '${difference.abs().toStringAsFixed(1)}°C',
          style: TextStyle(
              fontSize: 40, color: textColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
