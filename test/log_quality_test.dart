import 'dart:io';
import 'package:bmw_app/logging/log_quality.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('excludes invalid values and backwards time without hiding gaps', () async {
    final root = await Directory.systemTemp.createTemp('quality-test-');
    addTearDown(() => root.delete(recursive: true));
    final file = File('${root.path}/log.csv');
    await file.writeAsString([
      '# vehicle,test', '# vehicle_profile,test',
      'timestamp,elapsed_ms,sensor_id,sensor_name,value,unit',
      't,1000,rpm,RPM,1000,rpm',
      't,500,rpm,RPM,1000,rpm',
      't,2000,rpm,RPM,NaN,rpm',
      't,3000,rpm,RPM,Infinity,rpm',
      't,wrong,rpm,RPM,1000,rpm',
      't,4000,,RPM,1000,rpm',
      't,5000,rpm,"unterminated,1000,rpm',
      't,7000,rpm,RPM,2000,rpm',
    ].join('\n'));
    final report = await inspectLogQuality(file, vin: 'test', profileId: 'test');
    expect(report.sampleCount, 2);
    expect(report.invalidSampleCount, 6);
    expect(report.maxGapMs, 6000);
    expect(report.durationMs, 7000);
    expect(report.channelQuality['rpm']!.sampleCount, 2);
    expect(report.channelQuality['rpm']!.observedHz, closeTo(1 / 6, .0001));
    expect(report.channelQuality['rpm']!.maxGapMs, 6000);
    expect(report.suitableForTunerReview, isFalse);
    expect(report.toJson()['invalid_sample_count'], 6);
  });
}
