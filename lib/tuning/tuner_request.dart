import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

enum TunerRequestStatus { draft, readyToSend, sent }

class TunerRequestActivity {
  const TunerRequestActivity({
    required this.action,
    required this.recordedAt,
    this.detail,
  });

  final String action;
  final DateTime recordedAt;
  final String? detail;

  Map<String, dynamic> toJson() => {
    'action': action,
    'recorded_at': recordedAt.toIso8601String(),
    if (detail != null && detail!.isNotEmpty) 'detail': detail,
  };

  factory TunerRequestActivity.fromJson(Map<String, dynamic> json) =>
      TunerRequestActivity(
        action: json['action'] as String? ?? 'Updated request',
        recordedAt:
            DateTime.tryParse(json['recorded_at'] as String? ?? '') ??
            DateTime.now(),
        detail: json['detail'] as String?,
      );
}

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
    this.fuel = '',
    this.hardware = '',
    this.productId,
    this.productLabel,
    this.packageManifestPath,
    this.revision = 1,
    this.activity = const [],
  });

  final String id;
  final String vin;
  final String vehicleLabel;
  final String modifications;
  final String? stockFileName;
  final List<String> logFiles;
  final TunerRequestStatus status;
  final DateTime createdAt;
  final String fuel;
  final String hardware;
  final String? productId;
  final String? productLabel;
  final String? packageManifestPath;
  final int revision;
  final List<TunerRequestActivity> activity;

  List<TunerRequestActivity> get timeline => activity.isEmpty
      ? [TunerRequestActivity(action: 'Request created', recordedAt: createdAt)]
      : activity;

  TunerRequest markSent({DateTime? at}) {
    final recordedAt = at ?? DateTime.now();
    return TunerRequest(
      id: id,
      vin: vin,
      vehicleLabel: vehicleLabel,
      modifications: modifications,
      stockFileName: stockFileName,
      logFiles: logFiles,
      status: TunerRequestStatus.sent,
      createdAt: createdAt,
      fuel: fuel,
      hardware: hardware,
      productId: productId,
      productLabel: productLabel,
      packageManifestPath: packageManifestPath,
      revision: revision + 1,
      activity: [
        ...timeline,
        TunerRequestActivity(
          action: 'Marked as sent',
          recordedAt: recordedAt,
          detail: 'Marked locally after sharing; delivery is not confirmed.',
        ),
      ],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'vin': vin,
    'vehicle_label': vehicleLabel,
    'modifications': modifications,
    'stock_file_name': stockFileName,
    'log_files': logFiles,
    'status': status.name,
    'created_at': createdAt.toIso8601String(),
    'fuel': fuel,
    'hardware': hardware,
    if (productId != null) 'product_id': productId,
    if (productLabel != null) 'product_label': productLabel,
    if (packageManifestPath != null)
      'package_manifest_path': packageManifestPath,
    'revision': revision,
    'activity': timeline.map((entry) => entry.toJson()).toList(),
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
    fuel: json['fuel'] as String? ?? '',
    hardware: json['hardware'] as String? ?? '',
    productId: json['product_id'] as String?,
    productLabel: json['product_label'] as String?,
    packageManifestPath: json['package_manifest_path'] as String?,
    revision: (json['revision'] as num?)?.toInt().clamp(1, 999999) ?? 1,
    activity:
        (json['activity'] as List<dynamic>?)
            ?.whereType<Map>()
            .map(
              (entry) => TunerRequestActivity.fromJson(
                Map<String, dynamic>.from(entry),
              ),
            )
            .toList() ??
        const [],
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
