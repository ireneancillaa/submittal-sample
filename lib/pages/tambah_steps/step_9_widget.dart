import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/berita_acara_controller.dart';

class Step9Widget extends StatefulWidget {
  const Step9Widget({super.key});

  @override
  State<Step9Widget> createState() => _Step9WidgetState();
}

class _Step9WidgetState extends State<Step9Widget> {
  final BeritaAcaraController controller = Get.find<BeritaAcaraController>();
  static const Color _primaryBlue = Color(0xFF008CFF);
  static const Color _darkBlue = Color(0xFF002A56);
  static const Color _mutedText = Color(0xFF68748A);
  static const Color _red = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle(
          icon: Icons.sanitizer_outlined,
          title: 'Sterilisasi Alat',
          subtitle: 'Checklist sterilisasi peralatan sebelum penggunaan',
        ),
        const SizedBox(height: 16),

        // Top Toggle Buttons
        Row(
          children: [
            _buildTabButton(
              label: 'Sterilisasi Alat Spray',
              isActive: controller.activeTabSterilisasi.value == 'spray',
              onTap: () => controller.activeTabSterilisasi.value = 'spray',
            ),
            const SizedBox(width: 12),
            _buildTabButton(
              label: 'Injeksi Subcutan',
              isActive: controller.activeTabSterilisasi.value == 'subcutan',
              onTap: () => controller.activeTabSterilisasi.value = 'subcutan',
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (controller.activeTabSterilisasi.value == 'spray') ...[
          _buildStepItem(
            number: '1.',
            title: 'Cabinet dan kaki-kaki dibersihkan spray alkohol 70%',
            isOk: controller.spraySteril1Ok.value,
            onToggle: (v) => controller.spraySteril1Ok.value = v,
            keterangan: controller.spraySteril1Ket.value,
            onKetChanged: (v) => controller.spraySteril1Ket.value = v,
          ),
          const SizedBox(height: 16),
          _buildStepItem(
            number: '2.',
            title:
                'Syringe, selang, nozzle dialiri alkohol 70% dan dibilas aquadest',
            isOk: controller.spraySteril2Ok.value,
            onToggle: (v) => controller.spraySteril2Ok.value = v,
            keterangan: controller.spraySteril2Ket.value,
            onKetChanged: (v) => controller.spraySteril2Ket.value = v,
          ),
          const SizedBox(height: 16),
          _buildStepItem(
            number: '3.',
            title:
                'Tabung vaksin dicuci, spray alkohol, dibilas aquadest, dikeringkan',
            isOk: controller.spraySteril3Ok.value,
            onToggle: (v) => controller.spraySteril3Ok.value = v,
            keterangan: controller.spraySteril3Ket.value,
            onKetChanged: (v) => controller.spraySteril3Ket.value = v,
          ),
          const SizedBox(height: 16),
          _buildStepItem(
            number: '4.',
            title: 'Cabinet spray disimpan di tempat bersih dan kering',
            isOk: controller.spraySteril4Ok.value,
            onToggle: (v) => controller.spraySteril4Ok.value = v,
            keterangan: controller.spraySteril4Ket.value,
            onKetChanged: (v) => controller.spraySteril4Ket.value = v,
            showCorrection: true,
          ),
        ] else ...[
          _buildStepItem(
            number: '1.',
            title: 'Syringe dibilas air hangat and alkohol 70%',
            isOk: controller.subcSteril1Ok.value,
            onToggle: (v) => controller.subcSteril1Ok.value = v,
            keterangan: controller.subcSteril1Ket.value,
            onKetChanged: (v) => controller.subcSteril1Ket.value = v,
          ),
          const SizedBox(height: 16),
          _buildStepItem(
            number: '2.',
            title: 'Peralatan disimpan dalam wadah steril',
            isOk: controller.subcSteril2Ok.value,
            onToggle: (v) => controller.subcSteril2Ok.value = v,
            keterangan: controller.subcSteril2Ket.value,
            onKetChanged: (v) => controller.subcSteril2Ket.value = v,
          ),
        ],

        const SizedBox(height: 24),

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
                initialValue: controller.catatanSterilisasi.value,
                onChanged: (v) => controller.catatanSterilisasi.value = v,
                hint: 'Tambahkan catatan bila diperlukan',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    ));
  }

  // Helpers
  Widget _buildTabButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: isActive ? _primaryBlue : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActive ? _primaryBlue : const Color(0xFFE7EEF8),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : _primaryBlue,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem({
    required String number,
    required String title,
    required bool isOk,
    required ValueChanged<bool> onToggle,
    required String keterangan,
    required ValueChanged<String> onKetChanged,
    bool showCorrection = false,
  }) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                number,
                style: const TextStyle(
                  color: _darkBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: _darkBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatusToggle(label: 'Status', isOk: isOk, onChanged: onToggle),
          if (showCorrection && !isOk) ...[
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
            initialValue: keterangan,
            onChanged: onKetChanged,
            hint: 'Keterangan',
          ),
        ],
      ),
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

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
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
          const SizedBox(height: 6),
        ],
        Container(
          constraints: const BoxConstraints(minHeight: 40),
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
}
