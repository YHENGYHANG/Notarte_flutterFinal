import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_management/main.dart';

void main() {
  testWidgets('App shows title and products header', (tester) async {
    await tester.pumpWidget(const InventoryApp());
    expect(find.text('Inventory Management'), findsOneWidget);
    expect(find.text('Your Products'), findsOneWidget);
  });
}
