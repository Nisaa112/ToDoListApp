import 'package:flutter/material.dart';
import '../model/kategori_model.dart';

class KategoriViewModel extends ChangeNotifier {
  List<KategoriModel> kategoriList = KategoriModel.getKategoriList();
}