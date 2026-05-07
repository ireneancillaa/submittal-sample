import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/berita_acara_controller.dart';

class Step4Widget extends StatefulWidget {
  const Step4Widget({super.key});

  @override
  State<Step4Widget> createState() => _Step4WidgetState();
}

class _Step4WidgetState extends State<Step4Widget> {
  final BeritaAcaraController controller = Get.find<BeritaAcaraController>();
  static const Color _primaryBlue = Color(0xFF008CFF);
  static const Color _darkBlue = Color(0xFF002A56);
  static const Color _mutedText = Color(0xFF68748A);
  static const Color _green = Color(0xFF10A83A);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Header
        _buildSectionTitle(
          icon: Icons.verified_user_outlined,
          title: 'Penyimpanan Vaksin',
          subtitle: 'Checklist penyimpanan vaksin sebelum submit berita acara',
        ),
        const SizedBox(height: 16),

        // 1. Suhu showcase
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('1. Suhu showcase'),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTextField(
                      label: 'Suhu (°C)',
                      initialValue: controller.suhuShowcase.value,
                      onChanged: (v) => controller.suhuShowcase.value = v,
                      suffix: '°C',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: _buildStatusToggle(
                      label: 'Status',
                      isOk: controller.isSuhuShowcaseOk.value,
                      onChanged: (v) => controller.isSuhuShowcaseOk.value = v,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Dalam rentang aman 2-8°C',
                style: TextStyle(
                  color: _green,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Keterangan',
                initialValue: controller.ketShowcase.value,
                onChanged: (v) => controller.ketShowcase.value = v,
                hint: 'Keterangan',
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 2. Sistem FIFO
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('2. Sistem FIFO'),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildChoiceToggle(
                      label: 'Berjalan?',
                      value: controller.isFifoRunning.value,
                      onChanged: (v) => controller.isFifoRunning.value = v,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: _buildStatusToggle(
                      label: 'Status',
                      isOk: controller.isFifoOk.value,
                      onChanged: (v) => controller.isFifoOk.value = v,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Keterangan',
                initialValue: controller.ketFifo.value,
                onChanged: (v) => controller.ketFifo.value = v,
                hint: 'Keterangan',
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 3. Suhu ruangan
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('3. Suhu ruangan'),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTextField(
                      label: 'Suhu (°C)',
                      initialValue: controller.suhuRuangan.value,
                      onChanged: (v) => controller.suhuRuangan.value = v,
                      suffix: '°C',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: _buildStatusToggle(
                      label: 'Status',
                      isOk: controller.isSuhuRuanganOk.value,
                      onChanged: (v) => controller.isSuhuRuanganOk.value = v,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Suhu ruangan terpantau stabil',
                style: TextStyle(color: _mutedText, fontSize: 11),
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Keterangan',
                initialValue: controller.ketRuangan.value,
                onChanged: (v) => controller.ketRuangan.value = v,
                hint: 'Keterangan',
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Additional Keterangan
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Keterangan Tambahan',
                style: TextStyle(
                  color: _darkBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              _buildTextField(
                label: '',
                initialValue: controller.ketTambahanPenyimpanan.value,
                onChanged: (v) => controller.ketTambahanPenyimpanan.value = v,
                hint: 'Tambahkan catatan bila diperlukan',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    ));
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _darkBlue,
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

  Widget _buildChoiceToggle({
    required String label,
    required bool value,
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
        Container(
          height: 38,
          decoration: BoxDecoration(
            color: _primaryBlue,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: _primaryBlue.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(true),
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: value ? _primaryBlue : Colors.white,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(10),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Ya',
                      style: TextStyle(
                        color: value ? Colors.white : _primaryBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(false),
                  child: Container(
                    margin: const EdgeInsets.only(top: 1, bottom: 1, right: 1),
                    decoration: BoxDecoration(
                      color: !value ? _primaryBlue : Colors.white,
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(10),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Tidak',
                      style: TextStyle(
                        color: !value ? Colors.white : _primaryBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
            color: isActive
                ? (isRed ? const Color(0xFFFF4D4F) : _primaryBlue)
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActive
                  ? (isRed ? const Color(0xFFFF4D4F) : _primaryBlue)
                  : const Color(0xFFE7EEF8),
              width: 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: (isRed ? const Color(0xFFFF4D4F) : _primaryBlue)
                          .withOpacity(0.2),
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
