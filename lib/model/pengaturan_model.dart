class PengaturanModel {
  bool kunciTugas;
  bool notifikasi;
  bool refleksi;

  PengaturanModel({
    this.kunciTugas = true,
    this.notifikasi = false,
    this.refleksi = true,
  });

  // Untuk SharedPreferences atau simpan sebagai Map:
  Map<String, dynamic> toMap() {
    return {
      'kunciTugas': kunciTugas,
      'notifikasi': notifikasi,
      'refleksi': refleksi,
    };
  }

  factory PengaturanModel.fromMap(Map<String, dynamic> map) {
    return PengaturanModel(
      kunciTugas: map['kunciTugas'] ?? true,
      notifikasi: map['notifikasi'] ?? false,
      refleksi: map['refleksi'] ?? true,
    );
  }
}
