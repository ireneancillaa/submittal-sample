import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/history_entry.dart';
import '../controllers/berita_acara_controller.dart';
import '../services/pdf_generator_service.dart';
import 'pdf_preview_page.dart';

class DetailLaporanPage extends StatefulWidget {
  final BaHistoryEntry entry;
  const DetailLaporanPage({super.key, required this.entry});

  @override
  State<DetailLaporanPage> createState() => _DetailLaporanPageState();
}

class _DetailLaporanPageState extends State<DetailLaporanPage> {
  static const Color _primaryBlue = Color(0xFF008CFF);
  static const Color _textMuted = Color(0xFF6B7280);
  static const Color _darkBlue = Color(0xFF002A56);

  int _pdfSize = 0;
  int _pdfPages = 0;
  bool _isLoadingPdf = true;

  @override
  void initState() {
    super.initState();
    _loadPdfMetadata();
  }

  Future<void> _loadPdfMetadata() async {
    try {
      final controller = Get.put(BeritaAcaraController());
      controller.fromJson(widget.entry.data ?? {});

      final meta = await PdfGeneratorService.getMetadata(
        controller: controller,
        isDraft: widget.entry.isDraft,
      );

      if (mounted) {
        setState(() {
          _pdfSize = meta['size'];
          _pdfPages = meta['pages'];
          _isLoadingPdf = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingPdf = false);
      }
    }
  }

  // Helper getters for dynamic data
  String get _checkInTime {
    final raw = widget.entry.data?['jamMulai'];
    if (raw == null) return '-';
    try {
      final parts = raw.toString().split(':');
      final hour = parts[0].padLeft(2, '0');
      final minute = parts[1].padLeft(2, '0');
      return '$hour:$minute WIB';
    } catch (_) {
      return '$raw WIB';
    }
  }

  String get _checkOutTime {
    final raw = widget.entry.data?['jamSelesai'];
    if (raw == null) return '-';
    try {
      final parts = raw.toString().split(':');
      final hour = parts[0].padLeft(2, '0');
      final minute = parts[1].padLeft(2, '0');
      return '$hour:$minute WIB';
    } catch (_) {
      return '$raw WIB';
    }
  }

  String get _metode => widget.entry.data?['metode'] ?? '-';

  int get _totalDOC {
    if (widget.entry.data?['vaksinatorList'] == null) return 0;
    final list = widget.entry.data!['vaksinatorList'] as List;
    return list.fold(0, (sum, item) => sum + (item['jumlahDOC'] as int? ?? 0));
  }

  int get _totalCulling {
    if (widget.entry.data?['vaksinatorList'] == null) return 0;
    final list = widget.entry.data!['vaksinatorList'] as List;
    return list.fold(0, (sum, item) {
      final c1 = item['cullingBasah'] as int? ?? 0;
      final c2 = item['cullingBerdarah'] as int? ?? 0;
      final c3 = item['cullingMati'] as int? ?? 0;
      return sum + c1 + c2 + c3;
    });
  }

  String get _cullingPercentage {
    if (_totalDOC == 0) return '0%';
    final p = (_totalCulling / _totalDOC) * 100;
    return '${NumberFormat('#,###').format(_totalCulling)} ekor (${p.toStringAsFixed(2)}%)';
  }

  String get _formattedDOC => '${NumberFormat('#,###').format(_totalDOC)} ekor';

  String get _formattedPdfSize {
    if (_pdfSize == 0) return 'Calculating...';
    if (_pdfSize < 1024) return '$_pdfSize B';
    if (_pdfSize < 1024 * 1024)
      return '${(_pdfSize / 1024).toStringAsFixed(1)} KB';
    return '${(_pdfSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Header Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 400,
            child: Container(color: _primaryBlue),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildFixedHeader(context),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(28),
                            ),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  _buildVisitSummary(),
                                  const SizedBox(height: 12),
                                  _buildCheckOutDetail(),
                                  const SizedBox(height: 12),
                                  _buildPdfSection(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Get.back(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Detail Laporan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.entry.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  _buildStatusBadge(widget.entry.isApproved),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Nomor BA: ${widget.entry.noBA}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.copy_rounded,
                    color: Colors.white.withOpacity(0.7),
                    size: 14,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildHeaderInfo(
                    Icons.calendar_today_outlined,
                    'Tanggal',
                    widget.entry.formattedDate,
                  ),
                  const SizedBox(width: 24),
                  _buildHeaderInfo(
                    Icons.location_on_outlined,
                    'Lokasi',
                    widget.entry.lokasi ?? '-',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildHeaderInfo(
                Icons.business_outlined,
                'Customer',
                widget.entry.customer,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isApproved) {
    final Color statusColor = isApproved
        ? const Color(0xFF10A83A)
        : const Color(0xFFFF9700);
    final Color statusBackground = isApproved
        ? const Color(0xFFE8F9EE)
        : const Color(0xFFFFF1DE);
    final String displayStatus = isApproved ? 'Approved' : 'Draft';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isApproved ? Icons.check_circle_rounded : Icons.sync_rounded,
            color: statusColor,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            displayStatus,
            style: TextStyle(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 18),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVisitSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  color: _primaryBlue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Ringkasan Kunjungan',
                style: TextStyle(
                  color: _darkBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 54),
            child: Column(
              children: [
                _buildSummaryRow(
                  Icons.access_time_rounded,
                  'Check In',
                  _checkInTime,
                ),
                const _Divider(),
                _buildSummaryRow(
                  Icons.access_time_filled_rounded,
                  'Check Out',
                  _checkOutTime,
                ),
                const _Divider(),
                _buildSummaryRow(Icons.sanitizer_outlined, 'Metode', _metode),
                const _Divider(),
                _buildSummaryRow(
                  Icons.egg_outlined,
                  'Jumlah DOC',
                  _formattedDOC,
                ),
                const _Divider(),
                _buildSummaryRow(
                  Icons.analytics_outlined,
                  'Hasil Culling',
                  _cullingPercentage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: _textMuted, size: 18),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            color: _textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: _darkBlue,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckOutDetail() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: _primaryBlue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Detail Check Out',
                style: TextStyle(
                  color: _darkBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 54),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lokasi Check Out',
                        style: TextStyle(
                          color: _textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.entry.lokasi ?? '-',
                        style: const TextStyle(
                          color: _darkBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Deskripsi Check Out',
                        style: TextStyle(
                          color: _textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.entry.data?['deskripsiCheckOut'] ?? '-',
                        style: const TextStyle(
                          color: _darkBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildCheckOutImage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckOutImage() {
    final String? imagePath = widget.entry.data?['fotoCheckOut'];
    if (imagePath != null && imagePath.isNotEmpty) {
      return Image.file(
        File(imagePath),
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
      );
    }
    return _buildImagePlaceholder();
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey[200],
      child: const Icon(Icons.image_outlined, color: Colors.grey),
    );
  }

  Widget _buildPdfSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: _primaryBlue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Dokumen PDF',
                style: TextStyle(
                  color: _darkBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 54),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildPdfThumbnail(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.entry.noBA}.pdf',
                            style: const TextStyle(
                              color: _darkBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isLoadingPdf
                                ? 'PDF • Calculating size...'
                                : 'PDF • $_formattedPdfSize • $_pdfPages Halaman',
                            style: const TextStyle(
                              color: _textMuted,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Dibuat: ${widget.entry.formattedDate} ${widget.entry.formattedTime}',
                            style: const TextStyle(
                              color: _textMuted,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Get.to(() => PdfPreviewPage()),
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('Lihat PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.file_download_outlined, size: 18),
                  label: const Text('Export PDF'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primaryBlue,
                    side: const BorderSide(color: _primaryBlue),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPdfThumbnail() {
    return Container(
      width: 50,
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.picture_as_pdf, color: Colors.red, size: 24),
          const Text(
            'PDF',
            style: TextStyle(
              color: Colors.red,
              fontSize: 8,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: const Color(0xFFF1F5F9),
    );
  }
}
