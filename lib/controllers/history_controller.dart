import 'package:get/get.dart';
import '../models/history_entry.dart';

class HistoryController extends GetxController {
  var historyList = <BaHistoryEntry>[].obs;
  var searchQuery = ''.obs;
  var selectedStatus = 'Semua'.obs;

  void addEntry(BaHistoryEntry entry) {
    historyList.insert(0, entry);
    // Tidak perlu refresh karena insert otomatis memicu update list
  }

  void updateEntry(BaHistoryEntry entry) {
    final index = historyList.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      historyList[index] = entry;
      historyList.refresh();
      update();
    }
  }

  // Gunakan syntax 'value' yang konsisten untuk reaktivitas maksimal
  List<BaHistoryEntry> get filteredHistory {
    if (searchQuery.value.isEmpty) return historyList;
    final query = searchQuery.value.toLowerCase();
    return historyList.where((e) {
      return e.noBA.toLowerCase().contains(query) ||
          e.customer.toLowerCase().contains(query) ||
          e.title.toLowerCase().contains(query);
    }).toList();
  }

  // Getters untuk Dashboard (ini sudah reaktif karena membaca dari historyList)
  int get totalBA => historyList.length;
  int get draftCount => historyList.where((e) => e.isDraft).length;
  int get approvedCount => historyList.where((e) => e.isApproved).length;
}
