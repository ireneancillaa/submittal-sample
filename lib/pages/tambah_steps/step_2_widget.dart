import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../controllers/berita_acara_controller.dart';

class Step2Widget extends StatefulWidget {
  const Step2Widget({super.key});

  @override
  State<Step2Widget> createState() => _Step2WidgetState();
}

class _Step2WidgetState extends State<Step2Widget> {
  final BeritaAcaraController controller = Get.find<BeritaAcaraController>();
  static const Color _primaryBlue = Color(0xFF008CFF);
  static const Color _darkBlue = Color(0xFF002A56);
  static const Color _mutedText = Color(0xFF68748A);


  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
  }

  @override
  void dispose() {
    super.dispose();
  }


  String _getFormattedDate() {
    return DateFormat(
      'EEEE, d MMMM yyyy',
      'id_ID',
    ).format(controller.selectedDate.value);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2020),
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
    if (picked != null && picked != controller.selectedDate.value) {
      controller.selectedDate.value = picked;
    }
  }

  Future<void> _selectTime(BuildContext context, bool isMulai) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isMulai ? controller.jamMulai.value : (controller.jamSelesai.value ?? TimeOfDay.now()),
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
      if (isMulai) {
        controller.jamMulai.value = picked;
        controller.isStartTimeManual.value = true;
      } else {
        controller.jamSelesai.value = picked;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            icon: Icons.description_outlined,
            title: 'Data Umum Berita Acara',
            subtitle: 'Lengkapi informasi awal berita acara',
          ),
          _buildLabel('1. Nomor Berita Acara'),
          _buildTextField(
            initialValue: controller.noBA.value,
            onChanged: (v) => controller.noBA.value = v,
            hint: 'Contoh: BA/CP/HT/2025/0056',
            icon: Icons.description_outlined,
          ),
          _buildLabel('2. Hari / Tanggal'),
          _buildClickableField(
            value: _getFormattedDate(),
            icon: Icons.calendar_today_outlined,
            suffixIcon: Icons.calendar_month_outlined,
            onTap: () => _selectDate(context),
          ),
          _buildLabel('3. Nama Customer'),
          _buildTextField(
            initialValue: controller.customer.value,
            onChanged: (v) => controller.customer.value = v,
            hint: 'Contoh: Sumber Jaya Farm',
            icon: Icons.person_outline_rounded,
            suffixIcon: Icons.keyboard_arrow_down_rounded,
          ),
          _buildLabel('4. Lokasi Hatchery'),
          _buildTextField(
            initialValue: controller.lokasi.value,
            onChanged: (v) => controller.lokasi.value = v,
            hint: 'Contoh: Hatchery Sumber Jaya - Blitar',
            icon: Icons.location_on_outlined,
            suffixIcon: Icons.keyboard_arrow_down_rounded,
          ),
          _buildLabel('5. Jam Mulai'),
          _buildClickableField(
            value: controller.jamMulai.value.format(context),
            icon: Icons.access_time,
            suffixIcon: Icons.access_time_outlined,
            onTap: () => _selectTime(context, true),
          ),
          _buildLabel('6. Jam Selesai'),
          _buildClickableField(
            value: controller.jamSelesai.value != null
                ? controller.jamSelesai.value!.format(context)
                : '',
            hint: 'Contoh: 16:30',
            icon: Icons.access_time,
            suffixIcon: Icons.access_time_outlined,
            onTap: () => _selectTime(context, false),
          ),
          _buildLabel('7. Jumlah Box Tervaksin'),
          _buildTextField(
            initialValue: controller.boxTervaksin.value,
            onChanged: (v) => controller.boxTervaksin.value = v,
            hint: 'Contoh: 120',
            icon: Icons.inventory_2_outlined,
            suffixText: 'Box',
          ),
          _buildLabel('8. Jumlah Total Produksi'),
          _buildTextField(
            initialValue: controller.totalProduksi.value,
            onChanged: (v) => controller.totalProduksi.value = v,
            hint: 'Contoh: 1.280',
            icon: Icons.egg_outlined,
            suffixText: 'Ekor',
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
                  letterSpacing: -0.3,
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        text,
        style: const TextStyle(
          color: _mutedText,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildClickableField({
    required String value,
    String? hint,
    required IconData icon,
    IconData? suffixIcon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE7EEF8)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(icon, color: _primaryBlue, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: value.isNotEmpty
                  ? Text(
                      value,
                      style: const TextStyle(
                        color: _darkBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Text(
                      hint ?? '',
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
            ),
            if (suffixIcon != null)
              Icon(suffixIcon, color: _mutedText, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String initialValue,
    required ValueChanged<String> onChanged,
    required String hint,
    required IconData icon,
    IconData? suffixIcon,
    String? suffixText,
  }) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7EEF8)),
      ),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
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
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: Icon(icon, color: _primaryBlue, size: 18),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 38,
          ),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: _mutedText, size: 18)
              : null,
          suffixText: suffixText,
          suffixStyle: const TextStyle(
            color: _mutedText,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
