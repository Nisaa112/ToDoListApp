class KategoriModel {
  final int id;
  final String nama;

  KategoriModel({
    required this.id, 
    required this.nama
  });

  static List<KategoriModel> getKategoriList() {
    return [
      KategoriModel(id: 1, nama: "Semua"),
      KategoriModel(id: 1, nama: "Pribadi"),
      KategoriModel(id: 1, nama: "Pekerjaan"),
    ];
  }
}