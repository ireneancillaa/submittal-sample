import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/berita_acara_controller.dart';

class Step5Widget extends StatefulWidget {
  const Step5Widget({super.key});

  @override
  State<Step5Widget> createState() => _Step5WidgetState();
}

class _Step5WidgetState extends State<Step5Widget> {
  BeritaAcaraController get controller => Get.find<BeritaAcaraController>();
  static const Color _primaryBlue = Color(0xFF008CFF);
  static const Color _darkBlue = Color(0xFF002A56);
  static const Color _mutedText = Color(0xFF68748A);
  static const Color _red = Color(0xFFEF4444);

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (image != null) {
      controller.fotoPersiapanSC.value = image.path;
    }
  }

  Future<void> _pickImageTo(RxString target) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (image != null) {
      target.value = image.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Main Header
          _buildSectionTitle(
            icon: Icons.biotech_outlined,
            title: 'Persiapan Vaksin Subcutan',
            subtitle: 'Checklist persiapan sebelum proses vaksin subcutan',
          ),
          const SizedBox(height: 16),

          // 1. Lama waktu thawing
          _buildItemCard(
            number: '1. Lama waktu thawing vaksin ND Killed',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildTextField(
                        label: 'Durasi',
                        initialValue: controller.thawingDurasi.value,
                        onChanged: (v) => controller.thawingDurasi.value = v,
                        hint: '15',
                        suffix: 'menit',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: _buildThreeWayToggle(
                        label: 'Status',
                        currentValue: controller.thawingStatus.value,
                        onChanged: (v) => controller.thawingStatus.value = v,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildPhotoArea(
                  label: 'Foto bukti (opsional)',
                  photoPath: controller.thawingFoto.value,
                  onTap: () => _pickImageTo(controller.thawingFoto),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.thawingKet.value,
                  onChanged: (v) => controller.thawingKet.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. Cuci tangan
          _buildItemCard(
            number: '2. Cuci tangan dan disinfeksi meja mixing',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildThreeWayToggle(
                  label: 'Status',
                  currentValue: controller.cuciTanganStatusSC.value,
                  onChanged: (v) => controller.cuciTanganStatusSC.value = v,
                ),
                const SizedBox(height: 12),
                _buildPhotoArea(
                  label: 'Foto bukti (opsional)',
                  photoPath: controller.cuciTanganFotoSC.value,
                  onTap: () => _pickImageTo(controller.cuciTanganFotoSC),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.cuciTanganKetSC.value,
                  onChanged: (v) => controller.cuciTanganKetSC.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. Bilas vial
          _buildItemCard(
            number: '3. Bilas vial vaksin IBD',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildThreeWayToggle(
                  label: 'Status',
                  currentValue: controller.bilasVialStatusSC.value,
                  onChanged: (v) => controller.bilasVialStatusSC.value = v,
                ),
                const SizedBox(height: 12),
                _buildPhotoArea(
                  label: 'Foto bukti (opsional)',
                  photoPath: controller.bilasVialFotoSC.value,
                  onTap: () => _pickImageTo(controller.bilasVialFotoSC),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.bilasVialKetSC.value,
                  onChanged: (v) => controller.bilasVialKetSC.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 4. Ukuran jarum
          _buildItemCard(
            number: '4. Ukuran jarum mixing',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildTextField(
                        label: 'Ukuran jarum',
                        initialValue: controller.jarumMixingUkuranSC.value,
                        onChanged: (v) =>
                            controller.jarumMixingUkuranSC.value = v,
                        hint: '18',
                        suffix: 'G',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: _buildThreeWayToggle(
                        label: 'Status',
                        currentValue: controller.jarumMixingStatusSC.value,
                        onChanged: (v) =>
                            controller.jarumMixingStatusSC.value = v,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildPhotoArea(
                  label: 'Foto bukti (opsional)',
                  photoPath: controller.jarumMixingFotoSC.value,
                  onTap: () => _pickImageTo(controller.jarumMixingFotoSC),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.jarumMixingKetSC.value,
                  onChanged: (v) => controller.jarumMixingKetSC.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 5. Disinfeksi vial kosong
          _buildItemCard(
            number: '5. Disinfeksi vial kosong',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildThreeWayToggle(
                  label: 'Status',
                  currentValue: controller.disinfeksiVialStatusSC.value,
                  onChanged: (v) => controller.disinfeksiVialStatusSC.value = v,
                ),
                if (controller.disinfeksiVialStatusSC.value == 'Tidak') ...[
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
                _buildPhotoArea(
                  label: 'Foto bukti (opsional)',
                  photoPath: controller.disinfeksiVialFotoSC.value,
                  onTap: () => _pickImageTo(controller.disinfeksiVialFotoSC),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Keterangan',
                  initialValue: controller.disinfeksiVialKetSC.value,
                  onChanged: (v) => controller.disinfeksiVialKetSC.value = v,
                  hint: 'Keterangan',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          const SizedBox(height: 16),

          // Foto Persiapan
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Foto Persiapan',
                  style: TextStyle(
                    color: _darkBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                _buildImageUploadPlaceholder(),
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
                  initialValue: controller.catatanPersiapanSC.value,
                  onChanged: (v) => controller.catatanPersiapanSC.value = v,
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

  Widget _buildPhotoArea({
    required String label,
    required String photoPath,
    required VoidCallback onTap,
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
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFD),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              image: photoPath.isNotEmpty
                  ? DecorationImage(
                      image: FileImage(File(photoPath)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: photoPath.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.camera_alt_outlined,
                        color: _primaryBlue,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Unggah foto bukti persiapan',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
          ),
        ),
      ],
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
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
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
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThreeWayToggle({
    required String label,
    required String currentValue,
    required ValueChanged<String> onChanged,
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
            _buildSeparateChoice(
              'Ya',
              currentValue == 'Ya',
              () => onChanged('Ya'),
            ),
            const SizedBox(width: 8),
            _buildSeparateChoice(
              'Tidak',
              currentValue == 'Tidak',
              () => onChanged('Tidak'),
              isRed: true,
            ),
            const SizedBox(width: 8),
            _buildSeparateChoice(
              'N/A',
              currentValue == 'N/A',
              () => onChanged('N/A'),
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

  Widget _buildImageUploadPlaceholder() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFD),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                image: controller.fotoPersiapanSC.value.isNotEmpty
                    ? DecorationImage(
                        image: FileImage(
                          File(controller.fotoPersiapanSC.value),
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: controller.fotoPersiapanSC.value.isEmpty
                  ? const Icon(Icons.camera_alt_outlined, color: _mutedText)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.fotoPersiapanSC.value.isEmpty
                        ? 'Upload Foto Persiapan'
                        : 'Foto Terpilih',
                    style: const TextStyle(
                      color: _darkBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    controller.fotoPersiapanSC.value.isEmpty
                        ? 'Ambil foto persiapan alat & vaksin'
                        : 'Tap untuk ganti foto',
                    style: const TextStyle(color: _mutedText, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: _mutedText),
          ],
        ),
      ),
    );
  }
}
