import 'package:flutter_test/flutter_test.dart';
import 'package:cofeeshop/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Memuat widget utama (CoffeeShopApp)
    await tester.pumpWidget(const CoffeeShopApp());

    // Verifikasi bahwa teks utama tampil
    expect(find.text('CoffeeTime ☕'), findsOneWidget);
  });
}
