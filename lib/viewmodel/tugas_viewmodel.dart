import 'package:flutter/material.dart';
import '../model/tugas_model.dart';

class TugasViewModel extends ChangeNotifier {
  List<TugasModel> tugasList = TugasModel.getTugasList();
  void toggleCheckbox(int index) {
    tugasList[index].isChecked = !(tugasList[index].isChecked ?? false);
    notifyListeners();
  }
}