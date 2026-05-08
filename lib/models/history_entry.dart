import 'package:intl/intl.dart';

class BaHistoryEntry {
  final String id;
  final String title;
  final String customer;
  final DateTime date;
  final String status;
  final bool isDraft;
  final bool isInProgress;
  final bool isApproved;
  final String? lokasi;
  final Map<String, dynamic>? data;

  BaHistoryEntry({
    required this.id,
    required this.title,
    required this.customer,
    required this.date,
    required this.status,
    required this.isDraft,
    this.isInProgress = false,
    this.isApproved = false,
    this.lokasi,
    this.data,
  });

  String get noBA => id;
  String get formattedDate => DateFormat('dd MMM yyyy').format(date);
  String get formattedTime => DateFormat('HH:mm').format(date) + ' WIB';
}
