import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/berita_acara_controller.dart';
import '../../services/pdf_generator_service.dart';
import '../pdf_preview_page.dart';

class Step11Widget extends StatefulWidget {
  final Function(int)? onJumpToStep;
  const Step11Widget({super.key, this.onJumpToStep});

  @override
  State<Step11Widget> createState() => _Step11WidgetState();
}

class _Step11WidgetState extends State<Step11Widget> {
  final BeritaAcaraController controller = Get.find<BeritaAcaraController>();
  static const Color _primaryBlue = Color(0xFF008CFF);
  static const Color _darkBlue = Color(0xFF002A56);
  static const Color _mutedText = Color(0xFF68748A);
  static const Color _green = Color(0xFF10B981);

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
      final meta = await PdfGeneratorService.getMetadata(
        controller: controller,
        isDraft: true, // Preview is always draft
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

  String get _formattedPdfSize {
    if (_pdfSize == 0) return 'Calculating...';
    if (_pdfSize < 1024) return '$_pdfSize B';
    if (_pdfSize < 1024 * 1024) return '${(_pdfSize / 1024).toStringAsFixed(1)} KB';
    return '${(_pdfSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle(
          icon: Icons.assignment_turned_in_outlined,
          title: 'Review Berita Acara',
          subtitle: 'Periksa ringkasan data sebelum submit',
        ),
        const SizedBox(height: 20),
        _buildReviewCard(
          icon: Icons.info_outline,
          title: 'Data umum',
          subtitle: '${controller.noBA.value.isEmpty ? '-' : controller.noBA.value} • ${controller.formattedDate} • ${controller.customer.value}',
          onEdit: () => widget.onJumpToStep?.call(0),
        ),
        const SizedBox(height: 12),
        _buildReviewCard(
          icon: Icons.vaccines_outlined,
          title: 'Pemakaian vaksin',
          subtitle: '${controller.vaksinList.length} jenis vaksin digunakan',
          onEdit: () => widget.onJumpToStep?.call(2),
        ),
        const SizedBox(height: 12),
        _buildReviewCard(
          icon: Icons.biotech_outlined,
          title: 'Persiapan vaksin',
          subtitle: 'SC: ${controller.thawingStatus.value} (durasi: ${controller.thawingDurasi.value.isEmpty ? '-' : controller.thawingDurasi.value}) • Spray: ${controller.cuciTanganStatusSP.value}',
          onEdit: () => widget.onJumpToStep?.call(4),
        ),
        const SizedBox(height: 12),
        _buildReviewCard(
          icon: Icons.settings_input_component_outlined,
          title: 'Setting mesin',
          subtitle: 'Parameter mesin subcutan dan spray tercatat',
          onEdit: () => widget.onJumpToStep?.call(6),
        ),
        const SizedBox(height: 12),
        _buildReviewCard(
          icon: Icons.sanitizer_outlined,
          title: 'Sterilisasi',
          subtitle: 'Checklist sterilisasi area dan peralatan',
          onEdit: () => widget.onJumpToStep?.call(8),
        ),
        const SizedBox(height: 12),
        _buildReviewCard(
          icon: Icons.medical_services_outlined,
          title: 'Culling dan ganti jarum',
          subtitle: '${controller.vaksinatorList.length} vaksinator • Total DOC: ${controller.totalDOC} • Total culling: ${controller.totalCulling} (${controller.avgCullingPersen.toStringAsFixed(2)}%)',
          onEdit: () => widget.onJumpToStep?.call(9),
        ),
        const SizedBox(height: 12),
        _buildPreviewSection(),
        const SizedBox(height: 24),
      ],
    ));
  }

  Widget _buildSectionTitle({required IconData icon, required String title, required String subtitle}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _primaryBlue, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _darkBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: _mutedText,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard({required IconData icon, required String title, required String subtitle, required VoidCallback onEdit}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7EEF8)),
      ),
      child: Row(
        children: [
          Icon(icon, color: _mutedText, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _darkBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: _mutedText,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onEdit,
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Edit',
              style: TextStyle(
                color: _primaryBlue,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Preview Dokumen',
              style: TextStyle(
                color: _darkBlue,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: _green.withOpacity(0.2)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline, color: _green, size: 12),
                  SizedBox(width: 4),
                  Text('Siap di-submit', style: TextStyle(color: _green, fontSize: 9, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _showDocumentPreview,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE7EEF8)),
            ),
            child: Row(
              children: [
                _buildPdfIcon(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Berita Acara Vaksinasi', style: TextStyle(color: _darkBlue, fontSize: 13, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(
                        '${controller.noBA.value.isEmpty ? 'BA-PENDING' : controller.noBA.value}.pdf',
                        style: const TextStyle(
                          color: _primaryBlue,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isLoadingPdf 
                          ? 'Calculating size...'
                          : '$_pdfPages halaman • PDF • $_formattedPdfSize', 
                        style: const TextStyle(color: _mutedText, fontSize: 10, fontWeight: FontWeight.w500)
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ketuk untuk melihat preview lengkap dokumen sebelum di-submit.',
                        style: TextStyle(color: _mutedText, fontSize: 9, fontWeight: FontWeight.w400, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: _mutedText, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPdfIcon() {
    return Container(
      width: 70,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 22,
            left: 0,
            right: 0,
            child: Icon(
              Icons.picture_as_pdf_outlined,
              color: Colors.grey,
              size: 28,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
              ),
              alignment: Alignment.center,
              child: const Text(
                'PDF',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDocumentPreview() {
    Get.to(() => PdfPreviewPage());
  }
}
