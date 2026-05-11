import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../controllers/berita_acara_controller.dart';
import '../services/pdf_generator_service.dart';

class PdfPreviewPage extends StatelessWidget {
  PdfPreviewPage({super.key});

  final BeritaAcaraController controller = Get.find<BeritaAcaraController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Preview: ${controller.noBA.value.isEmpty ? 'Berita Acara' : controller.noBA.value}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share',
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Preparing PDF for sharing...')),
              );

              try {
                final bytes = await PdfGeneratorService.generateBeritaAcara(
                  PdfPageFormat.a4,
                  controller: controller,
                );

                await Printing.sharePdf(
                  bytes: bytes,
                  filename:
                      '${controller.noBA.value.isEmpty ? 'BA-DRAFT' : controller.noBA.value}.pdf',
                );
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to share PDF: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) => PdfGeneratorService.generateBeritaAcara(
          format,
          controller: controller,
        ),
        initialPageFormat: PdfPageFormat.a4,
        canChangePageFormat: false,
        canChangeOrientation: false,
        allowPrinting: false,
        allowSharing: false,
        canDebug: false,
        pdfFileName:
            '${controller.noBA.value.isEmpty ? 'BA-DRAFT' : controller.noBA.value}.pdf',
      ),
    );
  }
}
