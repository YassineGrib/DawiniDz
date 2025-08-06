import 'package:flutter/foundation.dart';
import '../services/sample_data_service.dart';

/// Data seeder utility for initializing sample data in the application
class DataSeeder {
  static final SampleDataService _sampleDataService = SampleDataService();

  static Future<void> seedSampleData() async {
    try {
      // Initialize all sample data using the comprehensive service
      await _sampleDataService.initializeSampleData();
      
      // Validate data integrity
      final isValid = await _sampleDataService.validateDataIntegrity();
      if (isValid) {
        debugPrint('Sample data seeded and validated successfully!');
      } else {
        debugPrint('Sample data validation failed');
      }
    } catch (e) {
      debugPrint('Error seeding sample data: $e');
    }
  }
}
