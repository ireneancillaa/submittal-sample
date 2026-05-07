class VaksinData {
  String name;
  String pemakaian;
  String masuk;
  String sisa;
  String expired;
  String batch;
  bool isExpired;

  VaksinData({
    required this.name,
    required this.pemakaian,
    required this.masuk,
    required this.sisa,
    required this.expired,
    required this.batch,
    this.isExpired = false,
  });

  // Convert to Map for backward compatibility if needed
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'pemakaian': pemakaian,
      'masuk': masuk,
      'sisa': sisa,
      'expired': expired,
      'batch': batch,
      'isExpired': isExpired,
    };
  }

  factory VaksinData.fromMap(Map<String, dynamic> map) {
    return VaksinData(
      name: map['name'] ?? '',
      pemakaian: map['pemakaian'] ?? '',
      masuk: map['masuk'] ?? '',
      sisa: map['sisa'] ?? '',
      expired: map['expired'] ?? '',
      batch: map['batch'] ?? '',
      isExpired: map['isExpired'] ?? false,
    );
  }
}
