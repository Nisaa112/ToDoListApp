import 'package:flutter/material.dart';
import 'package:to_do_list_app/model/label_model.dart';

class LabelViewmodel extends ChangeNotifier {
  List<LabelModel> labelList= LabelModel.getLabelList();
}