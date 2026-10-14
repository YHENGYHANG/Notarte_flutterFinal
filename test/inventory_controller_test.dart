import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_management/data/inventory_controller.dart';
import 'package:inventory_management/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Create, Read, Update, Delete', () async {
    final c = InventoryController();
    await c.load();
    final initial = c.products.length;

    final p = Product(
      id: 't1',
      name: 'Test',
      category: 'Cat',
      price: 2,
      quantity: 3,
      imageUrl: '',
      notes: '',
      createdAt: DateTime(2026),
    );

    c.add(p); // Create
    expect(c.products.length, initial + 1);
    expect(c.getById('t1')?.name, 'Test'); // Read

    c.update(p.copyWith(name: 'Renamed')); // Update
    expect(c.getById('t1')?.name, 'Renamed');

    c.adjustQuantity('t1', 2);
    expect(c.getById('t1')?.quantity, 5);
    c.adjustQuantity('t1', -10); // would go below zero -> ignored
    expect(c.getById('t1')?.quantity, 5);

    c.remove('t1'); // Delete
    expect(c.getById('t1'), isNull);
    expect(c.products.length, initial);
  });
}
