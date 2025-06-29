import 'package:flutter/foundation.dart';
import 'package:to_do_list_app/model/pengaturan_model.dart';

class PengaturanViewmodel extends ChangeNotifier {
  PengaturanModel _setting = PengaturanModel();

  bool get kunciTugas => _setting.kunciTugas;
  bool get notifikasi => _setting.notifikasi;
  bool get refleksi => _setting.refleksi;

  void setKunciTugas(bool value) {
    _setting.kunciTugas = value;
    notifyListeners();
  }

  void setNotifikasi(bool value) {
    _setting.notifikasi = value;
    notifyListeners();
  }

  void setRefleksi(bool value) {
    _setting.refleksi = value;
    notifyListeners();
  }
}
