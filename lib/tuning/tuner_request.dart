import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

enum TunerRequestStatus { draft, readyToSend, sent }

class TunerRequest {
  const TunerRequest({
    required this.id,
    required this.vin,
    required this.vehicleLabel,
    required this.modifications,
    required this.stockFileName,
    required this.logFiles,
    required this.status,
    required this.createdAt,
    this.productId,
    this.productLabel,
  });

  final String id;
  final String vin;
  final String vehicleLabel;
  final String modifications;
  final String? stockFileName;
  final List<String> logFiles;
  final TunerRequestStatus status;
  final DateTime createdAt;
  final String? productId;
  final String? productLabel;

  Map<String, dynamic> toJson() => {
    'id': id,
    'vin': vin,
    'vehicle_label': vehicleLabel,
    'modifications': modifications,
    'stock_file_name': stockFileName,
    'log_files': logFiles,
    'status': status.name,
    'created_at': createdAt.toIso8601String(),
    if (productId != null) 'product_id': productId,
    if (productLabel != null) 'product_label': productLabel,
  };

  factory TunerRequest.fromJson(Map<String, dynamic> json) => TunerRequest(
    id:
        json['id'] as String? ??
        'request_${DateTime.now().microsecondsSinceEpoch}',
    vin: json['vin'] as String? ?? '',
    vehicleLabel: json['vehicle_label'] as String? ?? 'BMW',
    modifications: json['modifications'] as String? ?? '',
    stockFileName: json['stock_file_name'] as String?,
    logFiles: (json['log_files'] as List<dynamic>?)?.cast<String>() ?? const [],
    status:
        TunerRequestStatus.values.asNameMap()[json['status']] ??
        TunerRequestStatus.draft,
    createdAt:
        DateTime.tryParse(json['created_at'] as String? ?? '') ??
        DateTime.now(),
    productId: json['product_id'] as String?,
    productLabel: json['product_label'] as String?,
  );
}

class TunerRequestStore {
  Future<File> save(TunerRequest request) async {
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory('${documents.path}/BimmerScope/tuner_requests');
    if (!await directory.exists()) await directory.create(recursive: true);
    final file = File('${directory.path}/${request.id}.json');
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(request.toJson()),
    );
    return file;
  }

  Future<List<TunerRequest>> loadAll() async {
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory('${documents.path}/BimmerScope/tuner_requests');
    if (!await directory.exists()) return [];
    final files = await directory
        .list()
        .where((e) => e is File && e.path.endsWith('.json'))
        .cast<File>()
        .toList();
    final requests = <TunerRequest>[];
    for (final file in files) {
      try {
        final json =
            jsonDecode(await file.readAsString()) as Map<String, dynamic>;
        requests.add(TunerRequest.fromJson(json));
      } catch (_) {}
    }
    requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return requests;
  }
}
