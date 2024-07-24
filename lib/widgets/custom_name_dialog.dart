import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tsar_wars/blocs/blocs.dart';

void showCustomNameDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) =>
        CustomNameDialog(animation: animation),
  );
}

class CustomNameDialog extends StatefulWidget {
  final Animation<double> animation;

  const CustomNameDialog({
    super.key,
    required this.animation,
  });

  @override
  State<CustomNameDialog> createState() => _CustomNameDialogState();
}

class _CustomNameDialogState extends State<CustomNameDialog> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // controller.text = context.read<SettingsController>().playerName.value;
    controller.text = context.read<SettingsBloc>().state.playerName;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: widget.animation,
        curve: Curves.easeOutCubic,
      ),
      child: SimpleDialog(
        title: Center(
          child: Text(
            'Change name',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            maxLength: 12,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              context.read<SettingsBloc>().add(
                    SetPlayerName(
                      name: value,
                    ),
                  );
            },
            onSubmitted: (value) {
              Navigator.pop(context);
            },
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
