import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../../controllers/berita_acara_controller.dart';
import '../../widgets/dashed_border.dart';

class Step12Widget extends StatefulWidget {
  final VoidCallback onRefreshLocation;
  final ArgumentCallback<GoogleMapController> onMapCreated;
  final VoidCallback onTakePhoto;

  const Step12Widget({
    super.key,
    required this.onRefreshLocation,
    required this.onMapCreated,
    required this.onTakePhoto,
  });

  @override
  State<Step12Widget> createState() => _Step12WidgetState();
}

class _Step12WidgetState extends State<Step12Widget> {
  final BeritaAcaraController controller = Get.find<BeritaAcaraController>();
  static const Color _primaryBlue = Color(0xFF008CFF);
  static const Color _darkBlue = Color(0xFF002A56);
  static const Color _mutedText = Color(0xFF68748A);
  static const Color _bgLight = Color(0xFFF8FAFD);

  late final TextEditingController _deskripsiController;

  @override
  void initState() {
    super.initState();
    _deskripsiController = TextEditingController(text: controller.deskripsiCheckOut.value);
  }

  @override
  void dispose() {
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle(
          icon: Icons.logout_outlined,
          title: 'Check Out Lokasi & Deskripsi',
          subtitle: 'Ambil lokasi dan isi deskripsi check out sebelum menyelesaikan kunjungan',
        ),
        const SizedBox(height: 16),

        // 1. Lokasi Check Out
        _buildStepHeader('1. Lokasi Check Out'),
        const SizedBox(height: 12),
        _buildMapSection(),
        const SizedBox(height: 12),
        _buildLocationCard(),
        const SizedBox(height: 16),

        // 2. Deskripsi Check Out
        _buildStepHeader('2. Deskripsi Check Out'),
        const SizedBox(height: 12),
        _buildDescriptionField(),
        const SizedBox(height: 24),

        // 3. Foto Check Out
        _buildStepHeader('3. Foto Check Out (Opsional)'),
        const SizedBox(height: 12),
        _buildPhotoRow(),
        const SizedBox(height: 12),
        _buildTakePhotoButton(),
        const SizedBox(height: 12),
      ],
    ));
  }

  Widget _buildStepHeader(String title) {
    return Text(
      title,
      style: const TextStyle(color: _darkBlue, fontSize: 14, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7EEF8)),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              height: 180,
              width: double.infinity,
              color: _bgLight,
              child: controller.currentPosition.value == null
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(strokeWidth: 2),
                          SizedBox(height: 12),
                          Text('Mengambil Lokasi...', style: TextStyle(color: _mutedText, fontSize: 12, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(target: controller.currentPosition.value!, zoom: 15),
                      onMapCreated: widget.onMapCreated,
                      markers: controller.markers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                    ),
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: GestureDetector(
              onTap: widget.onRefreshLocation,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: const Icon(Icons.my_location, color: _primaryBlue, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7EEF8)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Color(0xFFE7F2FF), shape: BoxShape.circle),
                child: const Icon(Icons.location_on, color: _primaryBlue, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Lokasi terdeteksi', style: TextStyle(color: _darkBlue, fontSize: 13, fontWeight: FontWeight.w700)),
                        const SizedBox(width: 4),
                        const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 14),
                      ],
                    ),
                    const Text('Jl. Raya Blitar No. 21, Blitar, Jawa Timur', style: TextStyle(color: _mutedText, fontSize: 11, fontWeight: FontWeight.w500)),
                    Text(
                      controller.currentPosition.value != null
                          ? 'Latitude: ${controller.currentPosition.value!.latitude.toStringAsFixed(4)}  Longitude: ${controller.currentPosition.value!.longitude.toStringAsFixed(4)}'
                          : 'Latitude: -  Longitude: -',
                      style: const TextStyle(color: _mutedText, fontSize: 10, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: widget.onRefreshLocation,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Perbarui Lokasi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              foregroundColor: _primaryBlue,
              side: const BorderSide(color: _primaryBlue),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(double.infinity, 44),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7EEF8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextFormField(
            controller: _deskripsiController,
            maxLines: null,
            minLines: 4,
            style: const TextStyle(color: _darkBlue, fontSize: 12, fontWeight: FontWeight.w500),
            decoration: const InputDecoration(
              hintText: 'Contoh: Kegiatan vaksinasi selesai, area sudah dibersihkan, alat telah dikembalikan, dan kunjungan ditutup dengan baik.',
              hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w400, height: 1.4),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
            onChanged: (v) => controller.deskripsiCheckOut.value = v,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 12),
            child: Text(
              '${controller.deskripsiCheckOut.value.length}/300',
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoRow() {
    return Row(
      children: [
        Expanded(
          child: DashedContainer(
            child: Container(
              height: 140,
              decoration: BoxDecoration(color: _bgLight, borderRadius: BorderRadius.circular(18)),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_outlined, color: _primaryBlue, size: 32),
                  SizedBox(height: 8),
                  Text('Ambil foto check out', style: TextStyle(color: _darkBlue, fontSize: 12, fontWeight: FontWeight.w700)),
                  Text('Pastikan kondisi akhir\nterlihat jelas', textAlign: TextAlign.center, style: TextStyle(color: _mutedText, fontSize: 10, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: _bgLight,
              image: controller.pickedImageCheckOut.value != null
                  ? DecorationImage(image: FileImage(File(controller.pickedImageCheckOut.value!.path)), fit: BoxFit.cover)
                  : null,
            ),
            child: controller.pickedImageCheckOut.value != null
                ? Stack(
                    children: [
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
                          child: const Icon(Icons.check, color: Colors.white, size: 14),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 12),
                              SizedBox(width: 4),
                              Text('Foto berhasil diambil', style: TextStyle(color: Color(0xFF4CAF50), fontSize: 10, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildTakePhotoButton() {
    return OutlinedButton.icon(
      onPressed: widget.onTakePhoto,
      icon: const Icon(Icons.camera_alt_rounded, size: 18),
      label: const Text('Ambil Foto', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryBlue,
        side: const BorderSide(color: _primaryBlue, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        minimumSize: const Size(double.infinity, 50),
      ),
    );
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
}
