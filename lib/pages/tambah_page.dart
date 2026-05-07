import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/history_entry.dart';
import 'tambah_steps/step_1_widget.dart';
import 'tambah_steps/step_2_widget.dart';
import 'tambah_steps/step_3_widget.dart';
import 'tambah_steps/step_4_widget.dart';
import 'tambah_steps/step_5_widget.dart';
import 'tambah_steps/step_6_widget.dart';
import 'tambah_steps/step_7_widget.dart';
import 'tambah_steps/step_8_widget.dart';
import 'tambah_steps/step_9_widget.dart';
import 'tambah_steps/step_10_widget.dart';
import 'tambah_steps/step_11_widget.dart';
import 'tambah_steps/step_12_widget.dart';
import '../controllers/berita_acara_controller.dart';
import '../controllers/history_controller.dart';

class TambahPage extends StatefulWidget {
  final VoidCallback? onBack;
  final BaHistoryEntry? initialEntry;
  const TambahPage({super.key, this.onBack, this.initialEntry});

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  final BeritaAcaraController controller = Get.put(BeritaAcaraController());
  static const Color _primaryBlue = Color(0xFF008CFF);
  static const Color _darkBlue = Color(0xFF002A56);
  static const Color _mutedText = Color(0xFF68748A);

  int _currentStep = 1;
  final int _totalSteps = 12;

  final ImagePicker _picker = ImagePicker();
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    if (widget.initialEntry != null) {
      _loadInitialData();
    }
    _getCurrentLocation();
  }

  void _loadInitialData() {
    final entry = widget.initialEntry!;
    if (entry.data != null) {
      controller.fromJson(entry.data!);
    } else {
      // Fallback if data is missing but entry exists
      controller.noBA.value = entry.title.replaceAll('BA Vaksinasi ', '').replaceAll('(Draft)', '');
      controller.customer.value = entry.customer;
      controller.selectedDate.value = entry.date;
      controller.isApproved.value = entry.isApproved;
    }
    
    if (entry.isDraft) {
      _currentStep = 2;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      final Position position = await Geolocator.getCurrentPosition();
      final LatLng latLng = LatLng(position.latitude, position.longitude);

      controller.currentPosition.value = latLng;
      controller.markers.clear();
      controller.markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: latLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
        ),
      );

      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
      debugPrint('Map refreshed to: ${latLng.latitude}, ${latLng.longitude}');
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        if (_currentStep == 1) {
          controller.pickedImageCheckIn.value = image;
        } else if (_currentStep == 12) {
          controller.pickedImageCheckOut.value = image;
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _submitForm() {
    final historyController = Get.find<HistoryController>();
    
    final newEntry = BaHistoryEntry(
      id: widget.initialEntry?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'BA Vaksinasi ${controller.noBA.value.isEmpty ? 'Hatchery' : controller.noBA.value}',
      customer: controller.customer.value.isEmpty ? 'Customer Baru' : controller.customer.value,
      date: controller.selectedDate.value,
      status: 'Selesai',
      isDraft: false,
      isApproved: false,
      data: controller.toJson(),
    );

    if (widget.initialEntry != null) {
      historyController.updateEntry(newEntry);
    } else {
      historyController.addEntry(newEntry);
    }
    
    // Reset controller for next BA
    Get.delete<BeritaAcaraController>();
    
    if (widget.onBack != null) {
      widget.onBack!();
    }
  }

  void _saveDraft() {
    final historyController = Get.find<HistoryController>();
    
    final newEntry = BaHistoryEntry(
      id: widget.initialEntry?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'BA Vaksinasi ${controller.noBA.value.isEmpty ? '(Draft)' : controller.noBA.value}',
      customer: controller.customer.value.isEmpty ? 'Customer Baru' : controller.customer.value,
      date: controller.selectedDate.value,
      status: 'Draft',
      isDraft: true,
      isApproved: false,
      data: controller.toJson(),
    );

    if (widget.initialEntry != null) {
      historyController.updateEntry(newEntry);
    } else {
      historyController.addEntry(newEntry);
    }
    
    Get.delete<BeritaAcaraController>();
    
    if (widget.onBack != null) {
      widget.onBack!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildStepperHeader(),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                key: ValueKey(_currentStep),
                physics: const BouncingScrollPhysics(),
                child: _buildStepContent(),
              ),
            ),
            _buildFooterActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            if (_currentStep > 1) {
              setState(() => _currentStep--);
            } else {
              if (widget.onBack != null) {
                widget.onBack!();
              } else {
                Get.offAllNamed('/dashboard');
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE7EEF8)),
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              color: _darkBlue,
              size: 24,
            ),
          ),
        ),
        Column(
          children: [
            RichText(
              text: TextSpan(
                text: 'Step ',
                style: const TextStyle(
                  color: _mutedText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: '$_currentStep',
                    style: const TextStyle(
                      color: _primaryBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: ' dari $_totalSteps'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 120,
              height: 4,
              child: Row(
                children: List.generate(_totalSteps, (index) {
                  bool isCompleted = index < _currentStep;
                  bool isCurrent = index == _currentStep - 1;
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? _primaryBlue
                            : (isCurrent
                                  ? _primaryBlue
                                  : const Color(0xFFE7EEF8)),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
        const SizedBox(width: 40), // Placeholder to balance
      ],
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return Step1Widget(
          onRefreshLocation: _getCurrentLocation,
          onMapCreated: (controller) => _mapController = controller,
          onTakePhoto: _takePhoto,
        );
      case 2:
        return const Step2Widget();
      case 3:
        return const Step3Widget();
      case 4:
        return const Step4Widget();
      case 5:
        return const Step5Widget();
      case 6:
        return const Step6Widget();
      case 7:
        return const Step7Widget();
      case 8:
        return const Step8Widget();
      case 9:
        return const Step9Widget();
      case 10:
        return const Step10Widget();
      case 11:
        return Step11Widget(
          onJumpToStep: (step) => setState(() => _currentStep = step + 1),
        );
      case 12:
        return Step12Widget(
          onRefreshLocation: _getCurrentLocation,
          onMapCreated: (controller) => _mapController = controller,
          onTakePhoto: _takePhoto,
        );
      default:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              'Konten Tahap $_currentStep Belum Tersedia',
              style: const TextStyle(color: _mutedText, fontSize: 16),
            ),
          ),
        );
    }
  }

  Widget _buildFooterActions() {
    if (_currentStep == _totalSteps) {
      return Container(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 18),
                label: const Text('Batal', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primaryBlue,
                  side: const BorderSide(color: _primaryBlue, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  minimumSize: const Size(0, 50),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  minimumSize: const Size(0, 50),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Check Out', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    SizedBox(width: 8),
                    Icon(Icons.chevron_right_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _saveDraft,
              icon: const Icon(Icons.save_outlined, size: 20),
              label: const Text(
                'Simpan Draft',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: _primaryBlue,
                side: const BorderSide(color: _primaryBlue, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: const Size(0, 50),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (_currentStep < _totalSteps) {
                  setState(() => _currentStep++);
                } else {
                  _submitForm();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: const Size(0, 50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentStep == _totalSteps ? 'Selesai' : 'Lanjut',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _currentStep == _totalSteps ? Icons.check_circle_outline : Icons.chevron_right_rounded,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE7EEF8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    final borderRadius = BorderRadius.circular(18);
    final RRect rrect = borderRadius.toRRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );
    final Path path = Path()..addRRect(rrect);

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
