import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';
import '../models/history_entry.dart';
import 'detail_laporan_page.dart';

class LaporanPage extends StatelessWidget {
  const LaporanPage({super.key});

  static const Color _blue = Color(0xFF008CFF);
  static const Color _darkBlue = Color(0xFF002A56);
  static const Color _mutedText = Color(0xFF68748A);
  static const Color _border = Color(0xFFE7ECF3);
  static const Color _green = Color(0xFF10A83A);
  static const Color _orange = Color(0xFFF59E0B);
  static const Color _cyan = Color(0xFF06B6D4);

  @override
  Widget build(BuildContext context) {
    final HistoryController historyController = Get.find<HistoryController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fixed Header Section
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Riwayat Laporan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _darkBlue,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Daftar berita acara yang telah dibuat',
                style: TextStyle(
                  fontSize: 12,
                  color: _mutedText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              _buildSearchAndFilter(historyController),
              const SizedBox(height: 20),
              _buildSummaryStats(historyController),
              Obx(() {
                final query = historyController.searchQuery.value;
                if (query.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'Hasil pencarian untuk "$query"',
                    style: const TextStyle(
                      color: _mutedText,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        // Scrollable List Section
        // lib/pages/laporan_page.dart
        Expanded(
          child: Obx(() {
            // Memanggil filteredHistory di dalam Obx agar GetX tahu
            // bahwa widget ini bergantung pada historyList.
            final entries = historyController.filteredHistory;

            if (entries.isEmpty) {
              return _buildEmptyState(historyController.searchQuery.value);
            }

            return ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                // Data entry di sini harus datang dari hasil filteredHistory yang reaktif
                final entry = entries[index];
                return _buildReportCard(
                  context,
                  entry,
                  index == entries.length - 1,
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String query) {
    if (query.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 48,
                color: _mutedText.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'Tidak ditemukan hasil untuk "$query"',
                textAlign: TextAlign.center,
                style: const TextStyle(color: _mutedText, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 48,
            color: _mutedText.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada Berita Acara',
            style: TextStyle(
              color: _mutedText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(HistoryController controller) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: _mutedText, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: (value) => controller.searchQuery.value = value,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: const InputDecoration(
                      hintText: 'Cari customer / nomor BA',
                      hintStyle: TextStyle(
                        color: _mutedText,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(
                      color: _darkBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Obx(
          () => PopupMenuButton<String>(
            onSelected: (value) {
              controller.selectedStatus.value = value;
            },
            offset: const Offset(0, 45),
            color: const Color(0xFFF8FAFC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE7ECF3)),
            ),
            itemBuilder: (context) =>
                ['Semua', 'Draft', 'In Progress', 'Selesai']
                    .map(
                      (status) => PopupMenuItem(
                        value: status,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: controller.selectedStatus.value == status
                                ? _blue.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                status == 'Semua'
                                    ? Icons.list_alt
                                    : (status == 'Draft'
                                          ? Icons.edit_note
                                          : (status == 'In Progress'
                                                ? Icons.sync_rounded
                                                : Icons.check_circle_outline)),
                                size: 18,
                                color: controller.selectedStatus.value == status
                                    ? _blue
                                    : _mutedText,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                      controller.selectedStatus.value == status
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: controller.selectedStatus.value == status
                                      ? _blue
                                      : _darkBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: controller.selectedStatus.value != 'Semua'
                    ? _blue.withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: controller.selectedStatus.value != 'Semua'
                      ? _blue
                      : const Color(0xFFE7ECF3),
                ),
              ),
              child: Center(
                child: Icon(
                  controller.selectedStatus.value != 'Semua'
                      ? Icons.filter_alt
                      : Icons.filter_alt_outlined,
                  color: controller.selectedStatus.value != 'Semua'
                      ? _blue
                      : _mutedText,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryStats(HistoryController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildStatCard(
                'Total Laporan',
                controller.historyList.length.toString(),
                'Semua laporan',
                _blue,
                const Color(0xFFEEF2FF),
                Icons.description_rounded,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                'Draft',
                controller.historyList
                    .where((e) => e.isDraft)
                    .length
                    .toString(),
                'Belum selesai',
                _orange,
                const Color(0xFFFFFBEB),
                Icons.edit_note_rounded,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                'In progress',
                controller.historyList
                    .where((e) => !e.isDraft && !e.isApproved)
                    .length
                    .toString(),
                'Dalam proses',
                _cyan,
                const Color(0xFFDEFCFE),
                Icons.sync_rounded,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                'Selesai',
                controller.historyList
                    .where((e) => e.isApproved)
                    .length
                    .toString(),
                'Telah selesai',
                _green,
                const Color(0xFFE8F9EE),
                Icons.check_circle_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    String subtitle,
    Color color,
    Color bgColor,
    IconData icon,
  ) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _mutedText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 9,
                    color: _mutedText.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    BaHistoryEntry entry,
    bool isLast,
  ) {
    // 1. Logika Penentuan Status (Disinkronkan dengan Dashboard)
    Color statusColor;
    Color statusBg;
    String statusText;

    if (entry.isApproved) {
      // Status: Selesai
      statusColor = _green;
      statusBg = const Color(0xFFECFDF5);
      statusText = 'Selesai';
    } else if (entry.isDraft) {
      // Status: Draft
      statusColor = _orange;
      statusBg = const Color(0xFFFFFBEB);
      statusText = 'Draft';
    } else {
      // Status: In Progress (Bukan Draft & Belum Approved)
      statusColor = _cyan;
      statusBg = const Color(0xFFDEFCFE);
      statusText = 'In Progress';
    }

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: InkWell(
        onTap: () => Get.to(() => DetailLaporanPage(entry: entry)),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // PDF Icon Section
                  Container(
                    width: 58,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.picture_as_pdf, color: Colors.red, size: 24),
                        Text(
                          'PDF',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Info Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                entry.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: _darkBlue,
                                ),
                              ),
                            ),
                            // Badge disesuaikan dengan variabel status di atas
                            _buildStatusBadge(
                              statusText,
                              statusColor,
                              statusBg,
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: _blue,
                              size: 20,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              entry.noBA,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF475569),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.copy,
                              size: 12,
                              color: Color(0xFF94A3B8),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow(
                                    Icons.business_outlined,
                                    entry.customer,
                                  ),
                                  const SizedBox(height: 4),
                                  _buildInfoRow(
                                    Icons.location_on_outlined,
                                    entry.lokasi ?? '-',
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow(
                                    Icons.calendar_today_outlined,
                                    entry.formattedDate,
                                  ),
                                  const SizedBox(height: 4),
                                  _buildInfoRow(
                                    Icons.access_time_rounded,
                                    entry.formattedTime,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // 2. Action Button Section
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 38,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _blue,
                    disabledBackgroundColor: const Color(0xFFF1F5F9),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Tombol DISABLE jika statusnya 'Draft'
                  onPressed: entry.isDraft
                      ? null
                      : () {
                          // Logika Accept Report
                        },
                  child: Text(
                    'Accept Report',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: entry.isDraft
                          ? const Color(0xFF94A3B8)
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            text == 'Selesai'
                ? Icons.check_circle_rounded
                : (text == 'In Progress'
                      ? Icons.sync_rounded
                      : Icons.edit_note_rounded),
            color: color,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: const Color(0xFF64748B)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
