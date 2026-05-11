import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/berita_acara_controller.dart';

class Step7Widget extends StatefulWidget {
  const Step7Widget({super.key});

  @override
  State<Step7Widget> createState() => _Step7WidgetState();
}

class _Step7WidgetState extends State<Step7Widget> {
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
            icon: Icons.settings_outlined,
            title: 'Setting Mesin Subcutan',
            subtitle:
                'Checklist setting mesin dan proses aplikasi vaksin subcutan',
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
                  initialValue: controller.merekAlatSC.value,
                  onChanged: (v) => controller.merekAlatSC.value = v,
                  hint: 'Merial Injector SC-200',
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.merekKetSC.value,
                  onChanged: (v) => controller.merekKetSC.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. Setting jarum
          _buildItemCard(
            number: '2. Setting jarum',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildTextField(
                        label: 'Posisi',
                        initialValue: controller.settingJarumSC.value,
                        onChanged: (v) => controller.settingJarumSC.value = v,
                        hint: 'Posisi',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: _buildStatusToggle(
                        label: 'Status',
                        isOk: controller.settingJarumOkSC.value,
                        onChanged: (v) => controller.settingJarumOkSC.value = v,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.settingJarumKetSC.value,
                  onChanged: (v) => controller.settingJarumKetSC.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. Ukuran jarum
          _buildItemCard(
            number: '3. Ukuran jarum',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildTextField(
                        label: 'Ukuran',
                        initialValue: controller.ukuranJarumSC.value,
                        onChanged: (v) => controller.ukuranJarumSC.value = v,
                        hint: '18',
                        suffix: 'G',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: _buildStatusToggle(
                        label: 'Status',
                        isOk: controller.ukuranJarumOkSC.value,
                        onChanged: (v) => controller.ukuranJarumOkSC.value = v,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.ukuranJarumKetSC.value,
                  onChanged: (v) => controller.ukuranJarumKetSC.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 4. Tekanan alat
          _buildItemCard(
            number: '4. Tekanan alat',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildTextField(
                        label: 'Tekanan (psi)',
                        initialValue: controller.tekananAlatSC.value,
                        onChanged: (v) => controller.tekananAlatSC.value = v,
                        suffix: 'psi',
                        hint: '45',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: _buildStatusToggle(
                        label: 'Status',
                        isOk: controller.tekananAlatOkSC.value,
                        onChanged: (v) => controller.tekananAlatOkSC.value = v,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.tekananAlatKetSC.value,
                  onChanged: (v) => controller.tekananAlatKetSC.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 5. Dosis syringe
          _buildItemCard(
            number: '5. Dosis syringe',
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
                        initialValue: controller.dosisSyringeSC.value,
                        onChanged: (v) => controller.dosisSyringeSC.value = v,
                        suffix: 'mL',
                        hint: '0.2',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: _buildStatusToggle(
                        label: 'Status',
                        isOk: controller.dosisSyringeOkSC.value,
                        onChanged: (v) => controller.dosisSyringeOkSC.value = v,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.dosisSyringeKetSC.value,
                  onChanged: (v) => controller.dosisSyringeKetSC.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 6. Cek counter
          _buildItemCard(
            number: '6. Cek counter',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatusToggle(
                  label: 'Status',
                  isOk: controller.cekCounterOkSC.value,
                  onChanged: (v) => controller.cekCounterOkSC.value = v,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.cekCounterKetSC.value,
                  onChanged: (v) => controller.cekCounterKetSC.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 7. Jumlah DOC/vial
          _buildItemCard(
            number: '7. Jumlah DOC/vial vaksin IBD tepat',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildTextField(
                        label: 'Jumlah DOC',
                        initialValue: controller.jumlahDOCVialSC.value,
                        onChanged: (v) => controller.jumlahDOCVialSC.value = v,
                        suffix: 'DOC',
                        hint: '1000',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: _buildStatusToggle(
                        label: 'Status',
                        isOk: controller.jumlahDOCVialOkSC.value,
                        onChanged: (v) =>
                            controller.jumlahDOCVialOkSC.value = v,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.jumlahDOCVialKetSC.value,
                  onChanged: (v) => controller.jumlahDOCVialKetSC.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 8. Jumlah DOC/botol
          _buildItemCard(
            number: '8. Jumlah DOC/botol ND tepat',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildTextField(
                        label: 'Jumlah DOC',
                        initialValue: controller.jumlahDOCBotolSC.value,
                        onChanged: (v) => controller.jumlahDOCBotolSC.value = v,
                        suffix: 'DOC',
                        hint: '2000',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: _buildStatusToggle(
                        label: 'Status',
                        isOk: controller.jumlahDOCBotolOkSC.value,
                        onChanged: (v) =>
                            controller.jumlahDOCBotolOkSC.value = v,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.jumlahDOCBotolKetSC.value,
                  onChanged: (v) => controller.jumlahDOCBotolKetSC.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 9. Waktu aplikasi
          _buildItemCard(
            number: '9. Waktu aplikasi setiap botol vaksin IBD maksimal 2 jam',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  label: 'Waktu',
                  initialValue: controller.waktuAplikasiSC.value,
                  onChanged: (v) => controller.waktuAplikasiSC.value = v,
                  hint: '1 jam 40 menit',
                ),
                const SizedBox(height: 12),
                _buildStatusToggle(
                  label: 'Status',
                  isOk: controller.waktuAplikasiOkSC.value,
                  onChanged: (v) => controller.waktuAplikasiOkSC.value = v,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.waktuAplikasiKetSC.value,
                  onChanged: (v) => controller.waktuAplikasiKetSC.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 10. Jarum diganti
          _buildItemCard(
            number: '10. Jarum diganti tiap 25 box DOC',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatusToggle(
                  label: 'Status',
                  isOk: controller.jarumGantiOkSC.value,
                  onChanged: (v) => controller.jarumGantiOkSC.value = v,
                ),
                if (!controller.jarumGantiOkSC.value) ...[
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
                  initialValue: controller.jarumGantiKetSC.value,
                  onChanged: (v) => controller.jarumGantiKetSC.value = v,
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
                  initialValue: controller.catatanSettingSC.value,
                  onChanged: (v) => controller.catatanSettingSC.value = v,
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
    String? label,
    required bool isOk,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
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
