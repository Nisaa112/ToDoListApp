class TugasModel {
  final DateTime tanggal;
  final String nama;
  final String deskripsi;
  bool? isChecked;

  TugasModel({
    required this.tanggal,
    required this.nama,
    required this.deskripsi,
    this.isChecked,
  });

  static List<TugasModel> getTugasList() {
    return[
      TugasModel(
        tanggal: DateTime(2025, 6, 24),
        nama: 'Bersihin kamar',
        deskripsi: 'Bersihin meja kamar',
        isChecked: false, // WAJIB disebut jika model nullable
      ),
      TugasModel(
        tanggal: DateTime(2025, 6, 25),
        nama: 'Bersihin WC',
        deskripsi: 'Bersihin semua WC',
        isChecked: false, // WAJIB disebut jika model nullable
      ),
      TugasModel(
        tanggal: DateTime(2025, 6, 27),
        nama: 'Cuci motor',
        deskripsi: 'Cuci motor nya sampe kinclong',
        isChecked: false, // WAJIB disebut jika model nullable
      ),
      TugasModel(
        tanggal: DateTime(2025, 6, 28),
        nama: 'Kerjain Projek',
        deskripsi: 'Kerjain minimal sampai 50%',
        isChecked: false, // WAJIB disebut jika model nullable
      ),
    ];
  }
}