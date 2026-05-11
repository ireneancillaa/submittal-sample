import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/berita_acara_controller.dart';

class Step8Widget extends StatefulWidget {
  const Step8Widget({super.key});

  @override
  State<Step8Widget> createState() => _Step8WidgetState();
}

class _Step8WidgetState extends State<Step8Widget> {
  final BeritaAcaraController controller = Get.find<BeritaAcaraController>();
  static const Color _primaryBlue = Color(0xFF008CFF);
  static const Color _darkBlue = Color(0xFF002A56);
  static const Color _mutedText = Color(0xFF68748A);
  static const Color _red = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionTitle(
            icon: Icons.settings_input_component_outlined,
            title: 'Setting Mesin Spray',
            subtitle:
                'Checklist setting mesin dan proses aplikasi vaksin spray',
          ),
          const SizedBox(height: 16),

          // 1. Merek alat
          _buildItemCard(
            number: '1. Merek alat',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  label: '',
                  initialValue: controller.merekAlatSP.value,
                  onChanged: (v) => controller.merekAlatSP.value = v,
                  hint: 'Spray Cabinet SC-500',
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.merekKetSP.value,
                  onChanged: (v) => controller.merekKetSP.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. Tekanan
          _buildItemCard(
            number: '2. Tekanan',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildTextField(
                        label: 'Tekanan (bar)',
                        initialValue: controller.tekananSP.value,
                        onChanged: (v) => controller.tekananSP.value = v,
                        suffix: 'bar',
                        hint: '2.5',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: _buildStatusToggle(
                        label: 'Status',
                        isOk: controller.tekananOkSP.value,
                        onChanged: (v) => controller.tekananOkSP.value = v,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.tekananKetSP.value,
                  onChanged: (v) => controller.tekananKetSP.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. Dosis per box DOC
          _buildItemCard(
            number: '3. Dosis per box DOC',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildTextField(
                        label: 'Dosis (mL)',
                        initialValue: controller.dosisBoxSP.value,
                        onChanged: (v) => controller.dosisBoxSP.value = v,
                        suffix: 'mL',
                        hint: '28',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: _buildStatusToggle(
                        label: 'Status',
                        isOk: controller.dosisBoxOkSP.value,
                        onChanged: (v) => controller.dosisBoxOkSP.value = v,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.dosisBoxKetSP.value,
                  onChanged: (v) => controller.dosisBoxKetSP.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 4. Cek dosis per nozzle
          _buildItemCard(
            number: '4. Cek dosis per nozzle',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatusToggle(
                  label: 'Status',
                  isOk: controller.cekDosisNozzleOkSP.value,
                  onChanged: (v) => controller.cekDosisNozzleOkSP.value = v,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.cekDosisNozzleKetSP.value,
                  onChanged: (v) => controller.cekDosisNozzleKetSP.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 5. Cek kerataan sebaran droplet
          _buildItemCard(
            number: '5. Cek kerataan sebaran droplet',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatusToggle(
                  label: 'Status',
                  isOk: controller.cekKerataanOkSP.value,
                  onChanged: (v) => controller.cekKerataanOkSP.value = v,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.cekKerataanKetSP.value,
                  onChanged: (v) => controller.cekKerataanKetSP.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 6. Waktu aplikasi
          _buildItemCard(
            number: '6. Waktu aplikasi setiap pencampuran maksimal 2 jam',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  label: 'Waktu',
                  initialValue: controller.waktuAplikasiSP.value,
                  onChanged: (v) => controller.waktuAplikasiSP.value = v,
                  hint: '1 jam 30 menit',
                ),
                const SizedBox(height: 12),
                _buildStatusToggle(
                  label: 'Status',
                  isOk: controller.waktuAplikasiOkSP.value,
                  onChanged: (v) => controller.waktuAplikasiOkSP.value = v,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.waktuAplikasiKetSP.value,
                  onChanged: (v) => controller.waktuAplikasiKetSP.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 7. Seleksi DOC culling
          _buildItemCard(
            number: '7. Seleksi DOC culling setiap box',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatusToggle(
                  label: 'Status',
                  isOk: controller.seleksiDOCCullingOkSP.value,
                  onChanged: (v) => controller.seleksiDOCCullingOkSP.value = v,
                ),
                if (!controller.seleksiDOCCullingOkSP.value) ...[
                  const SizedBox(height: 4),
                  const Text(
                    'Perlu tindakan koreksi',
                    style: TextStyle(
                      color: _red,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.seleksiDOCCullingKetSP.value,
                  onChanged: (v) => controller.seleksiDOCCullingKetSP.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Catatan Tambahan
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Catatan Tambahan',
                  style: TextStyle(
                    color: _darkBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: '',
                  initialValue: controller.catatanSettingSP.value,
                  onChanged: (v) => controller.catatanSettingSP.value = v,
                  hint: 'Tambahkan catatan bila diperlukan',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // Helpers
  Widget _buildItemCard({required String number, required Widget child}) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            number,
            style: const TextStyle(
              color: _darkBlue,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7EEF8)),
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE7F2FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: _primaryBlue, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _darkBlue,
                  fontSize: 16,
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required ValueChanged<String> onChanged,
    String? suffix,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: const TextStyle(
              color: _mutedText,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          constraints: const BoxConstraints(minHeight: 38),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE7EEF8)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: initialValue,
                  onChanged: onChanged,
                  maxLines: null,
                  style: const TextStyle(
                    color: _darkBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              if (suffix != null)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    suffix,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusToggle({
    required String label,
    required bool isOk,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _mutedText,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildSeparateChoice('OK', isOk, () => onChanged(true)),
            const SizedBox(width: 8),
            _buildSeparateChoice(
              'Tidak OK',
              !isOk,
              () => onChanged(false),
              isRed: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSeparateChoice(
    String label,
    bool isActive,
    VoidCallback onTap, {
    bool isRed = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: isActive ? (isRed ? _red : _primaryBlue) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActive
                  ? (isRed ? _red : _primaryBlue)
                  : const Color(0xFFE7EEF8),
              width: 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: (isRed ? _red : _primaryBlue).withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : _mutedText,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
