import 'package:flutter/material.dart';

class TransitionPage extends StatefulWidget {
  final Future<void> Function(BuildContext context) onLoad;
  final Widget? loadingUI;

  const TransitionPage({super.key, required this.onLoad, this.loadingUI});

  @override
  State<TransitionPage> createState() => _TransitionPageState();
}

class _TransitionPageState extends State<TransitionPage> {
  @override
  void initState() {
    super.initState();
    widget.onLoad(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child:
            widget.loadingUI ??
            const CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
