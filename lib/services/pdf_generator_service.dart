import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../controllers/berita_acara_controller.dart';

class PdfGeneratorService {
  static const PdfColor _pdfBlue = PdfColor.fromInt(0xFF008CFF);
  static const PdfColor _textColor = PdfColor.fromInt(0xFF1A1A1A);
  static const PdfColor _mutedTextColor = PdfColor.fromInt(0xFF4A4A4A);
  static const PdfColor _borderColor = PdfColor.fromInt(0xFFD1D5DB);
  static const PdfColor _headerBg = PdfColor.fromInt(0xFF008CFF);

  static Future<Uint8List> generateBeritaAcara(
    PdfPageFormat format, {
    required BeritaAcaraController controller,
    bool isDraft = true,
  }) async {
    try {
      final pdf = pw.Document();

      // Use built-in fonts for reliability
      final baseFont = pw.Font.helvetica();
      final boldFont = pw.Font.helveticaBold();

      final theme = pw.ThemeData.withFont(base: baseFont, bold: boldFont);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: format.copyWith(
            marginTop: 32,
            marginBottom: 32,
            marginLeft: 32,
            marginRight: 32,
          ),
          theme: theme,
          header: (context) {
            if (!isDraft) return pw.SizedBox();
            return pw.Container(
              width: double.infinity,
              height: 0,
              child: pw.Center(
                child: pw.Transform.translate(
                  offset: const PdfPoint(50, -275), // Precisely middle vertically
                  child: pw.Transform.rotate(
                    angle: -0.5,
                    child: pw.Text(
                      'DRAFT',
                      style: pw.TextStyle(
                        color: PdfColors.grey100,
                        fontSize: 150,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          build: (context) {
            return [
              _buildHeader(controller),
              pw.SizedBox(height: 24),
              _buildTitle(),
              pw.SizedBox(height: 32),

              _buildSectionHeader('1. Data Umum dan Check In'),
              _buildSection1(controller),
              pw.SizedBox(height: 24),

              _buildSectionHeader('2. Pemakaian Vaksin'),
              _buildSection2(controller),
              pw.SizedBox(height: 24),

              _buildSectionHeader('3. Checklist Penyimpanan Vaksin'),
              _buildSection3(controller),
              pw.SizedBox(height: 24),

              _buildSectionHeader('4. Persiapan Vaksin Subcutan'),
              _buildSection4(controller),
              pw.SizedBox(height: 24),

              _buildSectionHeader('6. Setting Mesin Subcutan'),
              _buildSection6(controller),
              pw.SizedBox(height: 24),

              _buildSectionHeader('7. Setting Mesin Spray'),
              _buildSection7(controller),
              pw.SizedBox(height: 24),

              _buildSectionHeader('8. Sterilisasi Alat'),
              _buildSection8(controller),
              pw.SizedBox(height: 24),

              _buildSectionHeader('9. Culling dan Ganti Jarum'),
              _buildSection9(controller),
              pw.SizedBox(height: 24),

              _buildSectionHeader('10. Ringkasan Status'),
              _buildSection10(controller),
              pw.SizedBox(height: 60),

              _buildSignatures(),
            ];
          },
        ),
      );

      return pdf.save();
    } catch (e) {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (context) => pw.Center(
            child: pw.Text('PDF Error: $e', style: const pw.TextStyle(fontSize: 12, color: PdfColors.red)),
          ),
        ),
      );
      return pdf.save();
    }
  }

  static Future<Map<String, dynamic>> getMetadata({
    required BeritaAcaraController controller,
    bool isDraft = true,
  }) async {
    final bytes = await generateBeritaAcara(PdfPageFormat.a4, controller: controller, isDraft: isDraft);
    return {
      'size': bytes.length,
      'pages': 2, // Standard count for this layout
    };
  }

  static pw.Widget _buildHeader(BeritaAcaraController controller) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'My Fave',
              style: pw.TextStyle(
                color: _pdfBlue,
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              'PT SHS International',
              style: const pw.TextStyle(color: _mutedTextColor, fontSize: 10),
            ),
          ],
        ),
        pw.Text(
          'BERITA ACARA VAKSINASI',
          style: const pw.TextStyle(color: _mutedTextColor, fontSize: 9),
        ),
      ],
    );
  }

  static pw.Widget _buildTitle() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      width: double.infinity,
      decoration: const pw.BoxDecoration(color: _headerBg),
      child: pw.Column(
        children: [
          pw.Text(
            'BERITA ACARA VAKSINASI HATCHERY',
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            'Ringkasan Data Digital - Submittal Sample',
            style: pw.TextStyle(color: PdfColors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSectionHeader(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          color: _textColor,
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget _buildSection1(BeritaAcaraController controller) {
    return pw.Table(
      columnWidths: const {
        0: pw.FlexColumnWidth(2),
        1: pw.FlexColumnWidth(3),
        2: pw.FlexColumnWidth(2),
        3: pw.FlexColumnWidth(3),
      },
      border: pw.TableBorder.all(color: _borderColor, width: 0.5),
      children: [
        _buildTableRow([
          'No. Berita Acara',
          controller.noBA.value.isEmpty ? '-' : controller.noBA.value,
          'Hari/Tanggal',
          controller.formattedDate,
        ], isSection1: true),
        _buildTableRow([
          'Nama Customer',
          controller.customer.value.isEmpty ? '-' : controller.customer.value,
          'Lokasi Hatchery',
          controller.lokasi.value.isEmpty ? '-' : controller.lokasi.value,
        ], isSection1: true),
        _buildTableRow([
          'Jam Mulai',
          '${controller.jamMulai.value.hour.toString().padLeft(2, '0')}:${controller.jamMulai.value.minute.toString().padLeft(2, '0')}',
          'Jam Selesai',
          controller.jamSelesai.value != null
              ? '${controller.jamSelesai.value!.hour.toString().padLeft(2, '0')}:${controller.jamSelesai.value!.minute.toString().padLeft(2, '0')}'
              : '-',
        ], isSection1: true),
        _buildTableRow([
          'Jumlah Box Tervaksin',
          '${controller.boxTervaksin.value.isEmpty ? '-' : controller.boxTervaksin.value} box',
          'Jumlah Total Produksi',
          '${controller.totalProduksi.value.isEmpty ? '-' : controller.totalProduksi.value} ekor',
        ], isSection1: true),
      ],
    );
  }

  static pw.Widget _buildSection2(BeritaAcaraController controller) {
    return pw.Table(
      border: pw.TableBorder.all(color: _borderColor, width: 0.5),
      children: [
        _buildTableHeader([
          'Merek Vaksin',
          'Pemakaian',
          'Masuk',
          'Sisa',
          'Exp',
          'Batch',
        ]),
        ...controller.vaksinList.map(
          (v) => _buildTableRow([
            v.name,
            v.pemakaian,
            v.masuk,
            v.sisa,
            v.expired,
            v.batch,
          ]),
        ),
      ],
    );
  }

  static pw.Widget _buildSection3(BeritaAcaraController controller) {
    return pw.Table(
      border: pw.TableBorder.all(color: _borderColor, width: 0.5),
      columnWidths: const {
        0: pw.FlexColumnWidth(3.5),
        1: pw.FlexColumnWidth(1.2),
        2: pw.FlexColumnWidth(1.2),
        3: pw.FlexColumnWidth(4),
      },
      children: [
        _buildTableHeader(['Parameter', 'Nilai', 'Stat', 'Keterangan']),
        _buildTableRow([
          'Suhu showcase',
          '4 °C',
          'OK',
          'Dalam rentang aman 2-8 °C',
        ]),
        _buildTableRow([
          'Sistem FIFO',
          'Ya',
          'OK',
          'Mengikuti first in first out',
        ]),
        _buildTableRow(['Suhu ruangan', '24 °C', 'OK', 'Suhu ruangan stabil']),
      ],
    );
  }

  static pw.Widget _buildSection4(BeritaAcaraController controller) {
    return pw.Table(
      border: pw.TableBorder.all(color: _borderColor, width: 0.5),
      children: [
        _buildTableHeader(['Parameter', 'Input', 'Status', 'Keterangan']),
        _buildTableRow([
          'Lama waktu thawing',
          '15 menit',
          'Ya',
          'Thawing sesuai SOP',
        ]),
        _buildTableRow([
          'Cuci tangan & disinfeksi',
          '-',
          'Ya',
          'Sudah dilakukan',
        ]),
        _buildTableRow([
          'Bilas vial vaksin',
          '-',
          'Ya',
          'Vial dibilas aquadest',
        ]),
      ],
    );
  }

  static pw.Widget _buildSection6(BeritaAcaraController controller) {
    return pw.Table(
      border: pw.TableBorder.all(color: _borderColor, width: 0.5),
      children: [
        _buildTableHeader(['Parameter', 'Nilai', 'Status', 'Keterangan']),
        _buildTableRow([
          'Merek alat',
          'Merial Injector SC-200',
          '-',
          'Alat utama subcutan',
        ]),
        _buildTableRow(['Setting jarum', 'Posisi standar', 'OK', 'Sesuai SOP']),
        _buildTableRow(['Ukuran jarum', '18 G', 'OK', 'Sesuai standar']),
      ],
    );
  }

  static pw.Widget _buildSection7(BeritaAcaraController controller) {
    return pw.Table(
      border: pw.TableBorder.all(color: _borderColor, width: 0.5),
      children: [
        _buildTableHeader(['Parameter', 'Nilai', 'Status', 'Keterangan']),
        _buildTableRow([
          'Merek alat',
          'Spray Cabinet SC-500',
          '-',
          'Alat utama spray',
        ]),
        _buildTableRow(['Tekanan', '2.5 bar', 'OK', 'Tekanan stabil']),
      ],
    );
  }

  static pw.Widget _buildSection8(BeritaAcaraController controller) {
    return pw.Table(
      border: pw.TableBorder.all(color: _borderColor, width: 0.5),
      children: [
        _buildTableHeader(['Parameter', 'Status', 'Keterangan']),
        _buildTableRow([
          'Cabinet dibersihkan',
          'OK',
          'Sudah dibersihkan & kering',
        ]),
        _buildTableRow(['Syringe & selang', 'OK', 'Aliran alkohol 70%']),
      ],
    );
  }

  static pw.Widget _buildSection9(BeritaAcaraController controller) {
    return pw.Table(
      border: pw.TableBorder.all(color: _borderColor, width: 0.5),
      columnWidths: const {
        0: pw.FlexColumnWidth(2.8),
        1: pw.FlexColumnWidth(1.2),
        2: pw.FlexColumnWidth(1.0),
        3: pw.FlexColumnWidth(1.5),
        4: pw.FlexColumnWidth(1.0),
        5: pw.FlexColumnWidth(1.0),
      },
      children: [
        _buildTableHeader([
          'Nama Vaksinator',
          'Jumlah DOC',
          'Basah',
          'Berdarah',
          'Mati',
          'Jarum',
        ]),
        ...controller.vaksinatorList.map(
          (v) => _buildTableRow([
            v.nama,
            v.jumlahDOC.toString(),
            v.cullingBasah.toString(),
            v.cullingBerdarah.toString(),
            v.cullingMati.toString(),
            v.gantiJarum.toString(),
          ]),
        ),
      ],
    );
  }

  static pw.Widget _buildSection10(BeritaAcaraController controller) {
    return pw.Table(
      border: pw.TableBorder.all(color: _borderColor, width: 0.5),
      children: [
        _buildTableHeader(['Kategori', 'Ringkasan', 'Status']),
        _buildTableRow(['Data umum', 'Semua parameter terisi', 'OK']),
        _buildTableRow([
          'Pemakaian vaksin',
          '${controller.vaksinList.length} jenis vaksin digunakan',
          'OK',
        ]),
        _buildTableRow([
          'Culling',
          'Total ${controller.totalCulling} ekor (${controller.avgCullingPersen.toStringAsFixed(2)}%)',
          'OK',
        ]),
      ],
    );
  }

  static pw.TableRow _buildTableHeader(List<String> cells) {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: _headerBg),
      children: cells.map((cell) => _buildCell(cell, isHeader: true)).toList(),
    );
  }

  static pw.TableRow _buildTableRow(
    List<String> cells, {
    bool isSection1 = false,
  }) {
    return pw.TableRow(
      children: List.generate(cells.length, (index) {
        final bool isLabel = isSection1 && index % 2 == 0;
        return _buildCell(cells[index], isLabel: isLabel);
      }),
    );
  }

  static pw.Widget _buildCell(
    String text, {
    bool isHeader = false,
    bool isLabel = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          color: isHeader
              ? PdfColors.white
              : (isLabel ? _mutedTextColor : _textColor),
          fontSize: 8.5,
          fontWeight: isHeader || isLabel
              ? pw.FontWeight.bold
              : pw.FontWeight.normal,
        ),
        textAlign: isHeader ? pw.TextAlign.center : pw.TextAlign.left,
      ),
    );
  }

  static pw.Widget _buildSignatures() {
    return pw.Table(
      children: [
        pw.TableRow(
          children: [
            _buildSignatureLabel('Dibuat oleh'),
            _buildSignatureLabel('Diperiksa oleh'),
            _buildSignatureLabel('Disetujui oleh'),
          ],
        ),
        pw.TableRow(
          children: [
            pw.SizedBox(height: 60),
            pw.SizedBox(height: 60),
            pw.SizedBox(height: 60),
          ],
        ),
        pw.TableRow(
          children: [
            _buildSignatureRole('Supervisor Hatchery'),
            _buildSignatureRole('QC / Veterinarian'),
            _buildSignatureRole('Pihak Hatchery'),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildSignatureLabel(String label) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Text(
        label,
        style: const pw.TextStyle(fontSize: 10, color: _mutedTextColor),
      ),
    );
  }

  static pw.Widget _buildSignatureRole(String role) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          role,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            color: _textColor,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Container(
          height: 1.5,
          margin: const pw.EdgeInsets.only(right: 16),
          color: PdfColors.grey400,
        ),
      ],
    );
  }
}
