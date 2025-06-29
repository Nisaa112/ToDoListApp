class LabelModel {
  final int id;
  final String nama;
  
  LabelModel({required this.id, required this.nama,});

  static List<LabelModel> getLabelList() {
    return [
      LabelModel(id: 1, nama: "Penting"),
      LabelModel(id: 1, nama: "gaPenting"),
      LabelModel(id: 1, nama: "bebas"),
      LabelModel(id: 1, nama: "apaAja"),
    ];
  }
}