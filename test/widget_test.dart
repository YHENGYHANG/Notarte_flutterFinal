import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_management/data/inventory_controller.dart';
import 'package:inventory_management/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Home screen shows title and product header', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final controller = InventoryController();
    await controller.load();

    await tester.pumpWidget(InventoryApp(controller: controller));

    expect(find.text('Inventory Management'), findsWidgets);
    expect(find.text('Your Products'), findsOneWidget);
  });
}
