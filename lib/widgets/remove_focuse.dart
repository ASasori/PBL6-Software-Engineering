import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RemoveFocuse extends StatelessWidget {
  final Widget child;
  final VoidCallback? onclick;
  const RemoveFocuse({super.key, required this.child, this.onclick});

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? GestureDetector(
      onTap: onclick,
      child: child,
    ) : InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onclick,
      child: child,
    );
  }
}
