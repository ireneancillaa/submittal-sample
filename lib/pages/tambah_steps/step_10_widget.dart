import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/berita_acara_controller.dart';
import '../../widgets/dashed_add_button.dart';
import '../../models/vaksinator_data.dart';

class Step10Widget extends StatefulWidget {
  const Step10Widget({super.key});

  @override
  State<Step10Widget> createState() => _Step10WidgetState();
}

class _Step10WidgetState extends State<Step10Widget> {
  final BeritaAcaraController controller = Get.find<BeritaAcaraController>();
  static const Color _primaryBlue = Color(0xFF008CFF);
  static const Color _darkBlue = Color(0xFF002A56);
  static const Color _mutedText = Color(0xFF68748A);
  static const Color _red = Color(0xFFEF4444);

  void _showForm({VaksinatorData? data, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _VaksinatorForm(
        initialData: data,
        onSave: (newData) {
          if (index != null) {
            controller.vaksinatorList[index] = newData;
          } else {
            controller.vaksinatorList.add(newData);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionTitle(
            icon: Icons.medical_services_outlined,
            title: 'Culling dan Ganti Jarum',
            subtitle: 'Input data culling dan penggantian jarum per vaksinator',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.info_outline, color: _primaryBlue, size: 14),
              const SizedBox(width: 8),
              const Text(
                'Jumlah culling dan persentase dihitung otomatis',
                style: TextStyle(
                  color: _mutedText,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildAddButton(),
          const SizedBox(height: 16),
          ...controller.vaksinatorList.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildVaksinatorCard(entry.value, entry.key),
            );
          }),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildVaksinatorCard(VaksinatorData data, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7EEF8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.nama,
                style: const TextStyle(
                  color: _darkBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  _buildIconButton(
                    Icons.edit_outlined,
                    _primaryBlue,
                    () => _showForm(data: data, index: index),
                  ),
                  const SizedBox(width: 8),
                  _buildIconButton(Icons.delete_outline, _red, () {
                    controller.vaksinatorList.removeAt(index);
                  }),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildMetricsGrid(data),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(VaksinatorData data) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildMetricItem('Jumlah DOC', data.jumlahDOC.toString()),
        _buildMetricItem('Culling basah', data.cullingBasah.toString()),
        _buildMetricItem(
          'Culling berdarah mati',
          data.cullingBerdarah.toString(),
        ),
        _buildMetricItem('Culling mati', data.cullingMati.toString()),
        _buildMetricItem('Jumlah culling', data.jumlahCulling.toString()),
        _buildMetricItem(
          'Persentase',
          '${data.persentase.toStringAsFixed(2)}%',
        ),
        _buildMetricItem('Ganti jarum', data.gantiJarum.toString()),
      ],
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return SizedBox(
      width: 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _mutedText,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: _primaryBlue,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _buildAddButton() {
    return DashedAddButton(
      label: 'Tambah Vaksinator',
      onTap: () => _showForm(),
      primaryColor: _primaryBlue,
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
}

class _VaksinatorForm extends StatefulWidget {
  final VaksinatorData? initialData;
  final Function(VaksinatorData) onSave;

  const _VaksinatorForm({this.initialData, required this.onSave});

  @override
  State<_VaksinatorForm> createState() => _VaksinatorFormState();
}

class _VaksinatorFormState extends State<_VaksinatorForm> {
  late TextEditingController _namaController;
  late TextEditingController _docController;
  late TextEditingController _basahController;
  late TextEditingController _berdarahController;
  late TextEditingController _matiController;
  late TextEditingController _gantiJarumController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
      text: widget.initialData?.nama ?? '',
    );
    _docController = TextEditingController(
      text: widget.initialData?.jumlahDOC.toString() ?? '',
    );
    _basahController = TextEditingController(
      text: widget.initialData?.cullingBasah.toString() ?? '',
    );
    _berdarahController = TextEditingController(
      text: widget.initialData?.cullingBerdarah.toString() ?? '',
    );
    _matiController = TextEditingController(
      text: widget.initialData?.cullingMati.toString() ?? '',
    );
    _gantiJarumController = TextEditingController(
      text: widget.initialData?.gantiJarum.toString() ?? '',
    );
  }

  int get _doc => int.tryParse(_docController.text) ?? 0;
  int get _basah => int.tryParse(_basahController.text) ?? 0;
  int get _berdarah => int.tryParse(_berdarahController.text) ?? 0;
  int get _mati => int.tryParse(_matiController.text) ?? 0;
  int get _jumlahCulling => _basah + _berdarah + _mati;
  double get _persentase => _doc > 0 ? (_jumlahCulling / _doc) * 100 : 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40),
              const Text(
                'Tambah Vaksinator',
                style: TextStyle(
                  color: Color(0xFF002A56),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 20, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildField('Nama vaksinator', _namaController, hint: 'Budi'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildField(
                  'Jumlah DOC',
                  _docController,
                  hint: '1200',
                  isNumber: true,
                  onChanged: (v) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildField(
                  'Culling basah',
                  _basahController,
                  hint: '3',
                  isNumber: true,
                  onChanged: (v) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildField(
                  'Culling berdarah',
                  _berdarahController,
                  hint: '2',
                  isNumber: true,
                  onChanged: (v) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildField(
                  'Culling mati',
                  _matiController,
                  hint: '1',
                  isNumber: true,
                  onChanged: (v) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildReadOnlyField(
                  'Jumlah culling (otomatis)',
                  _jumlahCulling.toString(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildReadOnlyField(
                  'Persentase culling (otomatis)',
                  '${_persentase.toStringAsFixed(2)}%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildField(
            'Jumlah ganti jarum',
            _gantiJarumController,
            hint: '2',
            isNumber: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xFF008CFF),
                size: 14,
              ),
              const SizedBox(width: 8),
              const Text(
                'Persentase = jumlah culling / jumlah DOC × 100%',
                style: TextStyle(
                  color: Color(0xFF68748A),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFF008CFF)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      color: Color(0xFF008CFF),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSave(
                      VaksinatorData(
                        nama: _namaController.text,
                        jumlahDOC: int.tryParse(_docController.text) ?? 0,
                        cullingBasah: int.tryParse(_basahController.text) ?? 0,
                        cullingBerdarah:
                            int.tryParse(_berdarahController.text) ?? 0,
                        cullingMati: int.tryParse(_matiController.text) ?? 0,
                        gantiJarum:
                            int.tryParse(_gantiJarumController.text) ?? 0,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008CFF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
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

  Widget _buildField(
    String label,
    TextEditingController controller, {
    String? hint,
    bool isNumber = false,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF68748A),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(minHeight: 44),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE7EEF8)),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            onChanged: onChanged,
            maxLines: isNumber ? 1 : null,
            style: const TextStyle(
              color: Color(0xFF002A56),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF68748A),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 44,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE7EEF8)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

