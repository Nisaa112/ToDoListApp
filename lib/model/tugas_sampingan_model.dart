class TugasSampinganModel {
  final DateTime tanggal;
  final String nama;
  bool ? isDone;

  TugasSampinganModel({required this.tanggal, required this.nama, this.isDone});

  static List<TugasSampinganModel> getTugasSampinganList() {
    return[
      TugasSampinganModel(tanggal: DateTime(2025, 6, 30), nama: 'rapihin meja nya', isDone: false),
      TugasSampinganModel(tanggal: DateTime(2025, 6, 30), nama: 'rapihin isi kulkas', isDone: false),
    ];
  }
}