import 'package:flutter/cupertino.dart';

class TapEffect extends StatefulWidget {
  final bool isClickable;
  final VoidCallback onclick;
  final Widget child;
  const TapEffect({super.key, this.isClickable = true, required this.onclick, required this.child});
  @override
  State<StatefulWidget> createState() => _TapEffectState();
}

class _TapEffectState extends State<TapEffect> with SingleTickerProviderStateMixin{
  AnimationController? animationController;
  DateTime tapTime = DateTime.now();
  bool isProgress = false;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: Duration(microseconds: 800),
    );
    animationController!.animateTo(1.0, duration: Duration(microseconds: 0), curve: Curves.fastOutSlowIn);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  Future<void> onTapCancel() async {
    if (widget.isClickable) {
      await _onDelayed();
      animationController!.animateTo(1.0, duration: Duration(microseconds: 240), curve: Curves.fastOutSlowIn);
    }
    isProgress = false;
  }


  Future<void> _onDelayed() async{
    if (widget.isClickable) {
      // this logic cretor like more press experience with some delay
      final int tapDuration = DateTime.now().millisecondsSinceEpoch - tapTime.millisecondsSinceEpoch;
      if (tapDuration < 120){
        await Future<dynamic>.delayed(Duration(milliseconds: 120 - tapDuration ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.isClickable) {
          await Future<dynamic>.delayed(const Duration(milliseconds: 280));
          try {
            if (!isProgress) {
              widget.onclick();
              isProgress = true;
            }
          } catch (_) {}
        }
      },
      onTapDown: (TapDownDetails details){
        if (widget.isClickable) {
          tapTime = DateTime.now();
          animationController!.animateTo(0.9, duration: Duration(milliseconds: 120), curve: Curves.fastOutSlowIn);

        }
        isProgress = true;
      },
      onTapUp: (TapUpDetails details){
        onTapCancel();
      },
      onTapCancel: () {
        onTapCancel();
      },
      child: AnimatedBuilder(
          animation: animationController!,
          builder: (BuildContext context, Widget? child){
            return Transform.scale(
              scale: animationController!.value,
              origin: Offset(0.0, 0.0),
              child: widget.child,
            );
          }
      ),
    );
  }
}