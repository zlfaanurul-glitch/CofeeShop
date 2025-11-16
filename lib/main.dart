import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

// =================== PROVIDERS ===================
final favoriteProductProvider = StateProvider<int?>((ref) => null);

// List jumlah setiap produk
final productQuantityProvider =
    StateProvider<List<int>>((ref) => List.filled(9, 0));

void main() {
  runApp(const ProviderScope(child: CoffeeShopApp()));
}

// =================== ROOT APP ===================
class CoffeeShopApp extends StatelessWidget {
  const CoffeeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoffeeTime App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFFFFAF3),
      ),
      home: const CoffeeHomePage(),
    );
  }
}

// =================== HOME PAGE ===================
class CoffeeHomePage extends ConsumerWidget {
  const CoffeeHomePage({super.key});

  // Service popup
  void showServiceDetail(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(icon, color: Colors.brown, size: 30),
              const SizedBox(width: 10),
              Text(title),
            ],
          ),
          content: Text(description, style: const TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIndex = ref.watch(favoriteProductProvider);
    final productQuantities = ref.watch(productQuantityProvider);

    // SERVICES
    final services = [
      {
        "title": "Freshly Brewed Coffee",
        "icon": Icons.coffee,
        "desc": "We brew fresh coffee every day with top-quality beans."
      },
      {
        "title": "Fast Delivery",
        "icon": Icons.local_shipping,
        "desc": "Your coffee will reach your hands in minutes!"
      },
      {
        "title": "Quality Beans",
        "icon": Icons.eco,
        "desc": "Premium beans sourced from trusted farmers."
      },
    ];

    // PRODUCTS
    final products = [
      {"name": "Cappuccino", "price": 30000, "image": "assets/cappucino.jpg"},
      {"name": "Latte", "price": 28000, "image": "assets/latte.jpg"},
      {"name": "Mocha", "price": 32000, "image": "assets/mocha.jpg"},
      {"name": "Americano", "price": 27000, "image": "assets/americano.jpg"},
      {"name": "Macchiato", "price": 31000, "image": "assets/macchiato.jpg"},
      {
        "name": "Hazelnut Coffee",
        "price": 29000,
        "image": "assets/hazelnut_coffee.jpg"
      },
      {
        "name": "Caramel Latte",
        "price": 35000,
        "image": "assets/caramel_latte.jpg"
      },
      {"name": "Affogato", "price": 34000, "image": "assets/affogato.jpg"},
      {
        "name": "Vanilla Latte",
        "price": 30000,
        "image": "assets/vanilla_latte.jpg"
      },
    ];

    // ORDER FORM CONTROLLERS
    final nameCtrl = TextEditingController();
    final orderCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("CoffeeTime ☕"),
        centerTitle: true,
        backgroundColor: Colors.brown[400],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===== HERO BANNER =====
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/banner.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 220,
                  color: Colors.black54,
                  child: const Center(
                    child: Text(
                      "Awaken Your Senses With Coffee",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ========= OUR SERVICE =========
            const Text(
              "OUR SERVICE",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),

            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => showServiceDetail(
                    context,
                    services[index]["title"].toString(),
                    services[index]["desc"].toString(),
                    services[index]["icon"] as IconData,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        services[index]["icon"] as IconData,
                        color: Colors.brown,
                        size: 36,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        services[index]["title"].toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // ========= OUR PRODUCT =========
            const Text(
              "OUR PRODUCT",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                final isFav = favoriteIndex == index;
                final quantity = productQuantities[index];

                return AnimatedScale(
                  scale: isFav ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: CoffeeCard(
                    name: product["name"].toString(),
                    price: product["price"] as int,
                    image: product["image"].toString(),
                    quantity: quantity,
                    isFavorite: isFav,
                    onTap: () {
                      // Tambah quantity
                      final temp = [...productQuantities];
                      temp[index]++;
                      ref.read(productQuantityProvider.notifier).state = temp;

                      // Favorite indicator
                      ref.read(favoriteProductProvider.notifier).state =
                          isFav ? null : index;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.brown[400],
                          duration: const Duration(milliseconds: 600),
                          content: Text(
                            'Added 1 ${product["name"]} (Total: ${temp[index]})',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // ========= ORDER FORM =========
            const Text(
              "ORDER FORM",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: "Nama Pemesan",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: orderCtrl,
                    decoration: const InputDecoration(
                      labelText: "Order",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Jumlah Orderan",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: noteCtrl,
                    decoration: const InputDecoration(
                      labelText: "Catatan",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.brown[400],
                          duration: const Duration(milliseconds: 900),
                          content: const Text(
                            'Order Saved!',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                    child: const Text("Submit Order"),
                  ),

                  const SizedBox(height: 20),

                  // ======= WHATSAPP ORDER BUTTON =======
                  ElevatedButton.icon(
                    onPressed: () async {
                      final phone = "6281234567890";

                      final message = """
Halo, saya ingin memesan:
Nama: ${nameCtrl.text}
Order: ${orderCtrl.text}
Jumlah: ${amountCtrl.text}
Catatan: ${noteCtrl.text}
""";

                      final url = Uri.parse(
                        "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
                      );

                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Opening WhatsApp..."),
                        ),
                      );
                    },
                    icon: const Icon(Icons.call, color: Colors.white),
                    label: const Text("Send via WhatsApp"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// =================== CUSTOM CARD ===================
class CoffeeCard extends StatelessWidget {
  final String name;
  final int price;
  final String image;
  final int quantity;
  final bool isFavorite;
  final VoidCallback onTap;

  const CoffeeCard({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isFavorite ? Colors.brown[100] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  image,
                  height: 110,
                  width: 110,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                "Rp $price",
                style: const TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              Text(
                "Qty: $quantity",
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 4),
              Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.brown,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
