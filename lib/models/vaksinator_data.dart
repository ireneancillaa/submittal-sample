class VaksinatorData {
  String nama;
  int jumlahDOC;
  int cullingBasah;
  int cullingBerdarah;
  int cullingMati;
  int gantiJarum;

  VaksinatorData({
    required this.nama,
    required this.jumlahDOC,
    required this.cullingBasah,
    required this.cullingBerdarah,
    required this.cullingMati,
    required this.gantiJarum,
  });

  int get jumlahCulling => cullingBasah + cullingBerdarah + cullingMati;
  double get persentase => jumlahDOC > 0 ? (jumlahCulling / jumlahDOC) * 100 : 0;
}
