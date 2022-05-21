import 'package:flutter/material.dart';

/**
 * Eye icon toggle switch used to hide or show passwords
 */
class EyeToggle extends StatelessWidget {
  Function _fn;
  bool _eyeState;
  EyeToggle({Key? key, required Function fn, required bool eyeState})
      : _fn = fn,
        _eyeState = eyeState,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        // Based on passwordVisible state choose the icon
        _eyeState ? Icons.visibility : Icons.visibility_off,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () => _fn(),
    );
  }
}
