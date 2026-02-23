import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_app/features/explore/models/property_unit.dart';
import 'package:real_estate_app/features/explore/models/property_response.dart';
import 'package:real_estate_app/features/explore/models/property_model.dart';

void main() {
  group('PropertyUnit.fromJson', () {
    test('should parse correctly with valid data', () {
      final json = {'id': 1, 'unit_number': 'A1', 'bhk': 2, 'price': '1000.50'};

      final unit = PropertyUnit.fromJson(json);

      expect(unit.id, 1);
      expect(unit.unitNumber, 'A1');
      expect(unit.bhk, 2);
      expect(unit.price, 1000.50);
    });

    test('should handle null values safely', () {
      final json = {'id': 1, 'unit_number': null, 'bhk': null};

      final unit = PropertyUnit.fromJson(json);

      expect(unit.id, 1);
      expect(unit.unitNumber, isNull);
      expect(unit.bhk, isNull);
    });

    test('should handle string values for numeric fields', () {
      final json = {'id': '1', 'bhk': '3'};

      final unit = PropertyUnit.fromJson(json);

      expect(unit.id, 1);
      expect(unit.bhk, 3);
    });
  });

  group('Property.fromJson', () {
    test('should handle missing required fields with defaults', () {
      final json = {'id': null, 'title': null};

      final property = Property.fromJson(json);

      expect(property.id, 0);
      expect(property.title, '');
    });

    test('should handle missing nested structures safely', () {
      final json = {
        'id': 1,
        'title': 'Test Property',
        'amenities': null,
        'media': null,
        'share_data': null,
      };

      final property = Property.fromJson(json);

      expect(property.amenities, isEmpty);
      expect(property.media.images, isEmpty);
      expect(property.shareData.title, '');
    });
  });

  group('Pagination.fromJson', () {
    test('should parse correctly with numeric and string values', () {
      final json = {
        'current_page': '1',
        'last_page': 5,
        'per_page': '10',
        'total': 50,
      };

      final pagination = Pagination.fromJson(json);

      expect(pagination.currentPage, 1);
      expect(pagination.lastPage, 5);
      expect(pagination.perPage, 10);
      expect(pagination.total, 50);
    });
  });
}
