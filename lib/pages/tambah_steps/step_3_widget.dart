import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/berita_acara_controller.dart';
import '../../widgets/dashed_border.dart';
import '../../widgets/dashed_add_button.dart';
import '../../models/vaksin_data.dart';

class Step3Widget extends StatefulWidget {
  const Step3Widget({super.key});

  @override
  State<Step3Widget> createState() => _Step3WidgetState();
}

class _Step3WidgetState extends State<Step3Widget> {
  BeritaAcaraController get controller => Get.find<BeritaAcaraController>();
  static const Color _primaryBlue = Color(0xFF008CFF);
  static const Color _darkBlue = Color(0xFF002A56);
  static const Color _mutedText = Color(0xFF68748A);

  Future<void> _selectDate(BuildContext context, TextEditingController textController) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primaryBlue,
              onPrimary: Colors.white,
              onSurface: _darkBlue,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      textController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  final TextEditingController _merekController = TextEditingController();
  final TextEditingController _pakaiController = TextEditingController();
  final TextEditingController _masukController = TextEditingController();
  final TextEditingController _expiredController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();

  void _showTambahVaksinModal({int? index, VaksinData? data}) {
    if (data != null) {
      _merekController.text = data.name;
      _pakaiController.text = data.pemakaian.split(' ')[0];
      _masukController.text = data.masuk.split(' ')[0];
      _expiredController.text = data.expired;
      _batchController.text = data.batch;
    } else {
      _merekController.clear();
      _pakaiController.clear();
      _masukController.clear();
      _expiredController.clear();
      _batchController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data != null ? 'Edit Vaksin' : 'Tambah Vaksin',
                    style: const TextStyle(color: _darkBlue, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                      child: const Icon(Icons.close, size: 20, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildModalLabel('1. Merek vaksin'),
                      _buildModalTextField('Merek vaksin', _merekController),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildModalLabel('2. Jumlah pemakaian'),
                                _buildModalTextField('0', _pakaiController, suffix: 'vial', isNumber: true, onChanged: (v) => setModalState(() {})),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildModalLabel('3. Vaksin masuk'),
                                _buildModalTextField('0', _masukController, suffix: 'vial', isNumber: true, onChanged: (v) => setModalState(() {})),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildModalLabel('4. Sisa stok (otomatis)'),
                                _buildModalReadOnlyField(
                                  ((int.tryParse(_masukController.text) ?? 0) - (int.tryParse(_pakaiController.text) ?? 0)).toString(),
                                  suffix: 'vial',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildModalLabel('5. Tanggal expired'),
                                _buildModalTextField(
                                  'Tanggal expired',
                                  _expiredController,
                                  icon: Icons.calendar_today_outlined,
                                  readOnly: true,
                                  onTap: () => _selectDate(context, _expiredController),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildModalLabel('6. Batch'),
                      _buildModalTextField('Nomor Batch', _batchController),
                      const SizedBox(height: 16),
                      _buildModalLabel('7. Upload foto label vaksin (opsional)'),
                      _buildImageUploadPlaceholder(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _primaryBlue,
                          side: const BorderSide(color: _primaryBlue),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final newData = VaksinData(
                            name: _merekController.text,
                            pemakaian: '${_pakaiController.text} vial',
                            masuk: '${_masukController.text} vial',
                            sisa: '${(int.tryParse(_masukController.text) ?? 0) - (int.tryParse(_pakaiController.text) ?? 0)} vial',
                            expired: _expiredController.text,
                            batch: _batchController.text,
                            isExpired: false,
                          );
                          if (index != null) {
                            controller.vaksinList[index] = newData;
                          } else {
                            controller.vaksinList.add(newData);
                          }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          icon: Icons.vaccines_outlined,
          title: 'Pemakaian Vaksin',
          subtitle: 'Input data vaksin lebih mudah dengan form modal',
        ),
        const SizedBox(height: 16),
        _buildInfoBanner(),
        const SizedBox(height: 12),
        _buildTambahButton(),
        const SizedBox(height: 12),
        ...controller.vaksinList.asMap().entries.map((entry) => _buildVaksinCard(entry.value, entry.key)),
        const SizedBox(height: 12),
      ],
    ));
  }

  Widget _buildSectionTitle({required IconData icon, required String title, required String subtitle}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFFE7F2FF), borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: _primaryBlue, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: _darkBlue, fontSize: 16, fontWeight: FontWeight.w700)),
              Text(subtitle, style: const TextStyle(color: _mutedText, fontSize: 10, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Row(
        children: [
          Icon(Icons.important_devices_rounded, color: _primaryBlue, size: 18),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Input lewat modal lebih mudah di layar kecil',
              style: TextStyle(color: _mutedText, fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ),
          Icon(Icons.close, color: _mutedText, size: 14),
        ],
      ),
    );
  }

  Widget _buildVaksinCard(VaksinData data, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EDF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: data.isExpired ? const Color(0xFFFFEAEA) : const Color(0xFFE7F2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.medication_rounded,
                  color: data.isExpired ? const Color(0xFFE74C3C) : _primaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: const TextStyle(
                        color: _darkBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Batch: ${data.batch}',
                      style: const TextStyle(
                        color: _mutedText,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _buildIconAction(Icons.edit_outlined, const Color(0xFFF1F5F9), _mutedText, () => _showTambahVaksinModal(index: index, data: data)),
              const SizedBox(width: 8),
              _buildIconAction(Icons.delete_outline_rounded, const Color(0xFFFFEAEA), const Color(0xFFE74C3C), () => controller.vaksinList.removeAt(index)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildDetailItem('Terpakai', data.pemakaian, _darkBlue)),
              Expanded(child: _buildDetailItem('Vial Masuk', data.masuk, _darkBlue)),
              Expanded(child: _buildDetailItem('Sisa', data.sisa, _primaryBlue)),
              Expanded(child: _buildDetailItem('Expired', data.expired, data.isExpired ? const Color(0xFFE74C3C) : _mutedText)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconAction(IconData icon, Color bg, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _mutedText,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildTambahButton() {
    return DashedAddButton(
      label: 'Tambah Vaksin',
      onTap: () => _showTambahVaksinModal(),
      primaryColor: _primaryBlue,
    );
  }

  // Modal Helpers
  Widget _buildModalLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF68748A),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildModalTextField(String hint, TextEditingController textController, {String? suffix, IconData? icon, bool isNumber = false, ValueChanged<String>? onChanged, bool readOnly = false, VoidCallback? onTap}) {
    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE7EEF8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[Icon(icon, size: 18, color: const Color(0xFF68748A)), const SizedBox(width: 12)],
          Expanded(
            child: TextFormField(
              controller: textController,
              keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              onChanged: onChanged,
              readOnly: readOnly,
              onTap: onTap,
              maxLines: isNumber ? 1 : null,
              style: const TextStyle(color: Color(0xFF002A56), fontSize: 13, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w400),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (suffix != null) Text(suffix, style: const TextStyle(color: Color(0xFF68748A), fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildModalReadOnlyField(String value, {String? suffix}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 44,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE7EEF8)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (suffix != null)
            Text(
              suffix,
              style: const TextStyle(
                color: Color(0xFF68748A),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageUploadPlaceholder() {
    return DashedContainer(
      color: const Color(0xFFE2E8F0),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_upload_outlined, color: _primaryBlue, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tap untuk upload atau ganti foto',
                              style: TextStyle(
                                color: _mutedText,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              'PNG, JPG maks. 5MB',
                              style: TextStyle(color: _mutedText, fontSize: 9),
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
      ),
    );
  }
}
