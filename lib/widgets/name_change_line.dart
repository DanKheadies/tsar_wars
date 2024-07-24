import 'package:flutter/material.dart';
import 'package:tsar_wars/widgets/widgets.dart';

class NameChangeLine extends StatelessWidget {
  final String name;

  const NameChangeLine({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    String playerName = name == '' ? 'Enter a name' : name;

    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: () => showCustomNameDialog(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Name',
              style: TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 30,
              ),
            ),
            const Spacer(),
            Text(
              playerName,
              style: const TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 30,
              ),
            )
          ],
        ),
      ),
    );
  }
}
