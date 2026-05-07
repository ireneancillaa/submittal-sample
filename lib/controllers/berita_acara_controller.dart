import 'dart:async';
import 'package:flutter/material.dart';
import '../models/history_entry.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../models/vaksinator_data.dart';
import '../models/vaksin_data.dart';

class BeritaAcaraController extends GetxController {
  Timer? _clockTimer;

  @override
  void onInit() {
    super.onInit();
    _startClock();
  }

  @override
  void onClose() {
    _clockTimer?.cancel();
    super.onClose();
  }

  void loadFromHistory(BaHistoryEntry entry) {
    noBA.value = entry.noBA;
    selectedDate.value = entry.date;
    customer.value = entry.customer;
    lokasi.value = entry.lokasi ?? '';
    
    // Parse time from entry.date if needed, or use a default
    jamMulai.value = TimeOfDay.fromDateTime(entry.date);
    
    if (entry.data != null) {
      final d = entry.data!;
      if (d['jamSelesai'] != null) {
        // Simple mock parsing or actual logic if stored
      }
      boxTervaksin.value = d['boxTervaksin'] ?? '';
      totalProduksi.value = d['totalProduksi'] ?? '';
      suhuShowcase.value = d['suhuShowcase'] ?? '';
      ketShowcase.value = d['ketShowcase'] ?? '';
      // ... load more fields as needed ...
    }
  }

  void _startClock() {
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isStartTimeManual.value) {
        jamMulai.value = TimeOfDay.now();
      }
    });
  }

  void toggleManualStartTime(bool manual) {
    isStartTimeManual.value = manual;
  }
  // Step 2: Data Umum
  var noBA = ''.obs;
  var selectedDate = DateTime.now().obs;
  var customer = ''.obs;
  var lokasi = ''.obs;
  var jamMulai = TimeOfDay.now().obs;
  var jamSelesai = Rxn<TimeOfDay>();
  var boxTervaksin = ''.obs;
  var totalProduksi = ''.obs;
  var isStartTimeManual = false.obs;

  // Step 3: Pemakaian Vaksin
  var vaksinList = <VaksinData>[].obs;

  // Step 4: Penyimpanan
  var suhuShowcase = ''.obs;
  var isSuhuShowcaseOk = true.obs;
  var ketShowcase = ''.obs;
  var isFifoRunning = true.obs;
  final isFifoOk = true.obs;
  var ketFifo = ''.obs;
  var suhuRuangan = ''.obs;
  final isSuhuRuanganOk = true.obs;
  var ketRuangan = ''.obs;
  var ketTambahanPenyimpanan = ''.obs;

  // Step 1 & 12: Location & Photos
  final currentPosition = Rxn<LatLng>();
  final markers = <Marker>{}.obs;
  final pickedImageCheckIn = Rxn<XFile>();
  final pickedImageCheckOut = Rxn<XFile>();
  final deskripsiCheckOut = ''.obs;

  // Step 5: Persiapan Vaksin Subcutan
  final thawingStatus = 'Ya'.obs;
  final thawingDurasi = ''.obs;
  final thawingKet = ''.obs;
  final thawingFoto = ''.obs;
  final cuciTanganStatusSC = 'Ya'.obs;
  final cuciTanganKetSC = ''.obs;
  final cuciTanganFotoSC = ''.obs;
  final jarumMixingUkuranSC = ''.obs;
  final jarumMixingStatusSC = 'Ya'.obs;
  final jarumMixingKetSC = ''.obs;
  final jarumMixingFotoSC = ''.obs;
  final bilasVialStatusSC = 'Ya'.obs;
  final bilasVialKetSC = ''.obs;
  final bilasVialFotoSC = ''.obs;
  final disinfeksiVialStatusSC = 'Ya'.obs;
  final disinfeksiVialKetSC = ''.obs;
  final disinfeksiVialFotoSC = ''.obs;
  final catatanPersiapanSC = ''.obs;
  final fotoPersiapanSC = ''.obs;

  // Step 6: Persiapan Vaksin Spray
  final cuciTanganStatusSP = 'Ya'.obs;
  final cuciTanganKetSP = ''.obs;
  final cuciTanganFotoSP = ''.obs;
  final suhuPelarutSP = ''.obs;
  final suhuStatusOkSP = true.obs;
  final suhuKetSP = ''.obs;
  final suhuFotoSP = ''.obs;
  final phPelarutSP = ''.obs;
  final phStatusOkSP = true.obs;
  final phKetSP = ''.obs;
  final phFotoSP = ''.obs;
  final bilasVialStatusSP = 'Ya'.obs;
  final bilasVialKetSP = ''.obs;
  final bilasVialFotoSP = ''.obs;
  final jarumUkuranSP = ''.obs;
  final jarumStatusSP = 'Ya'.obs;
  final jarumKetSP = ''.obs;
  final jarumFotoSP = ''.obs;
  final disinfeksiStatusSP = 'Ya'.obs;
  final disinfeksiKetSP = ''.obs;
  final disinfeksiFotoSP = ''.obs;
  final catatanPersiapanSP = ''.obs;
  final fotoPersiapanSP = ''.obs;

  // Step 7: Setting Mesin Subcutan
  final merekAlatSC = ''.obs;
  final merekKetSC = ''.obs;
  final settingJarumSC = ''.obs;
  final settingJarumOkSC = true.obs;
  final settingJarumKetSC = ''.obs;
  final ukuranJarumSC = ''.obs;
  final ukuranJarumOkSC = true.obs;
  final ukuranJarumKetSC = ''.obs;
  final tekananAlatSC = ''.obs;
  final tekananAlatOkSC = true.obs;
  final tekananAlatKetSC = ''.obs;
  final dosisSyringeSC = ''.obs;
  final dosisSyringeOkSC = true.obs;
  final dosisSyringeKetSC = ''.obs;
  final cekCounterOkSC = true.obs;
  final cekCounterKetSC = ''.obs;
  final jumlahDOCVialSC = ''.obs;
  final jumlahDOCVialOkSC = true.obs;
  final jumlahDOCVialKetSC = ''.obs;
  final jumlahDOCBotolSC = ''.obs;
  final jumlahDOCBotolOkSC = true.obs;
  final jumlahDOCBotolKetSC = ''.obs;
  final waktuAplikasiSC = ''.obs;
  final waktuAplikasiOkSC = true.obs;
  final waktuAplikasiKetSC = ''.obs;
  final jarumGantiOkSC = true.obs;
  final jarumGantiKetSC = ''.obs;
  final catatanSettingSC = ''.obs;

  // Step 8: Setting Mesin Spray
  final merekAlatSP = ''.obs;
  final merekKetSP = ''.obs;
  final tekananSP = ''.obs;
  final tekananOkSP = true.obs;
  final tekananKetSP = ''.obs;
  final dosisBoxSP = ''.obs;
  final dosisBoxOkSP = true.obs;
  final dosisBoxKetSP = ''.obs;
  final cekDosisNozzleOkSP = true.obs;
  final cekDosisNozzleKetSP = ''.obs;
  final cekKerataanOkSP = true.obs;
  final cekKerataanKetSP = ''.obs;
  final waktuAplikasiSP = ''.obs;
  final waktuAplikasiOkSP = true.obs;
  final waktuAplikasiKetSP = ''.obs;
  final seleksiDOCCullingOkSP = true.obs;
  final seleksiDOCCullingKetSP = ''.obs;
  final catatanSettingSP = ''.obs;

  // Step 9: Sterilisasi
  final spraySteril1Ok = true.obs;
  final spraySteril1Ket = ''.obs;
  final spraySteril2Ok = true.obs;
  final spraySteril2Ket = ''.obs;
  final spraySteril3Ok = true.obs;
  final spraySteril3Ket = ''.obs;
  final spraySteril4Ok = true.obs;
  final spraySteril4Ket = ''.obs;
  final subcSteril1Ok = true.obs;
  final subcSteril1Ket = ''.obs;
  final subcSteril2Ok = true.obs;
  final subcSteril2Ket = ''.obs;
  final activeTabSterilisasi = 'spray'.obs;
  final catatanSterilisasi = ''.obs;

  // Step 10: Culling
  var vaksinatorList = <VaksinatorData>[].obs;

  // Audit & Approval Fields
  var createdAt = DateTime.now().obs;
  var submittedAt = Rxn<DateTime>();
  var isApproved = false.obs;
  var approvedAt = Rxn<DateTime>();
  var approvedBy = ''.obs;

  // Helper getters for Step 11
  String get formattedDate => DateFormat('d MMMM yyyy', 'id_ID').format(selectedDate.value);
  
  int get totalCulling => vaksinatorList.fold(0, (sum, item) => sum + item.jumlahCulling);
  int get totalDOC => vaksinatorList.fold(0, (sum, item) => sum + item.jumlahDOC);
  double get avgCullingPersen => totalDOC > 0 ? (totalCulling / totalDOC) * 100 : 0;

  int get totalVialMasuk => vaksinList.fold(0, (sum, item) => sum + (int.tryParse(item.masuk.split(' ')[0]) ?? 0));
  int get totalVialTerpakai => vaksinList.fold(0, (sum, item) => sum + (int.tryParse(item.pemakaian.split(' ')[0]) ?? 0));

  Map<String, dynamic> toJson() {
    return {
      'noBA': noBA.value,
      'selectedDate': selectedDate.value.toIso8601String(),
      'customer': customer.value,
      'lokasi': lokasi.value,
      'jamMulai': '${jamMulai.value.hour}:${jamMulai.value.minute}',
      'jamSelesai': jamSelesai.value != null ? '${jamSelesai.value!.hour}:${jamSelesai.value!.minute}' : null,
      'boxTervaksin': boxTervaksin.value,
      'totalProduksi': totalProduksi.value,
      'deskripsiCheckOut': deskripsiCheckOut.value,
      'fotoCheckOut': pickedImageCheckOut.value?.path,
      'metode': activeTabSterilisasi.value == 'spray' ? 'Spray' : 'Subcutan',
      'vaksinList': vaksinList.map((v) => v.toMap()).toList(),
      'vaksinatorList': vaksinatorList.map((v) => {
        'nama': v.nama,
        'jumlahDOC': v.jumlahDOC,
        'cullingBasah': v.cullingBasah,
        'cullingBerdarah': v.cullingBerdarah,
        'cullingMati': v.cullingMati,
        'gantiJarum': v.gantiJarum,
      }).toList(),
      // Add other fields as needed for a full save
    };
  }

  void fromJson(Map<String, dynamic> json) {
    noBA.value = json['noBA'] ?? '';
    selectedDate.value = DateTime.parse(json['selectedDate']);
    customer.value = json['customer'] ?? '';
    lokasi.value = json['lokasi'] ?? '';
    
    if (json['jamMulai'] != null) {
      final parts = json['jamMulai'].split(':');
      jamMulai.value = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
    
    if (json['jamSelesai'] != null) {
      final parts = json['jamSelesai'].split(':');
      jamSelesai.value = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    boxTervaksin.value = json['boxTervaksin'] ?? '';
    totalProduksi.value = json['totalProduksi'] ?? '';
    deskripsiCheckOut.value = json['deskripsiCheckOut'] ?? '';
    
    if (json['fotoCheckOut'] != null) {
      pickedImageCheckOut.value = XFile(json['fotoCheckOut']);
    }

    if (json['metode'] != null) {
      activeTabSterilisasi.value = json['metode'] == 'Spray' ? 'spray' : 'subcutan';
    }

    if (json['vaksinList'] != null) {
      vaksinList.value = (json['vaksinList'] as List).map((v) => VaksinData.fromMap(v)).toList();
    }

    if (json['vaksinatorList'] != null) {
      vaksinatorList.value = (json['vaksinatorList'] as List).map((v) => VaksinatorData(
        nama: v['nama'],
        jumlahDOC: v['jumlahDOC'],
        cullingBasah: v['cullingBasah'],
        cullingBerdarah: v['cullingBerdarah'],
        cullingMati: v['cullingMati'],
        gantiJarum: v['gantiJarum'],
      )).toList();
    }
  }
}
