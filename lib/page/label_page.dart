import 'package:flutter/material.dart';
import 'package:to_do_list_app/page/content/label_content.dart';

class LabelPage extends StatefulWidget {
  const LabelPage({super.key});

  @override
  State<LabelPage> createState() => _LabelPageState();
}

class _LabelPageState extends State<LabelPage> {
  @override
  Widget build(BuildContext context) {
    return const LabelContent();
  }
}
