import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> all_products = [];
  List<dynamic> filtered_products = [];
  Set<int> favoriteProductIds = {};

  Future<void> fetchProducts({String? query}) async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      setState(() {
        all_products = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load products');
    }
    
    if (query != null) {
      filterProducts(query);
    } else {
      filtered_products = all_products;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void toggleFavorite(int productId) {
    setState(() {
      if (favoriteProductIds.contains(productId)) {
        favoriteProductIds.remove(productId);
      } else {
        favoriteProductIds.add(productId);
      }
    });
  }

  void filterProducts(String query) {
    setState(() {
      filtered_products = all_products.where((product) {
        final title = product['title'].toLowerCase();
        return title.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onSubmitted: (value)
                    {
                       fetchProducts(query: value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search product',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Products',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.favorite_border, size: 28),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${filtered_products.length} products found',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: all_products.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        itemCount: filtered_products.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemBuilder: (context, index) {
                          final product = filtered_products[index];
                          final productId = product['id'];
                          final isFavorite = favoriteProductIds.contains(productId);
                          final firstWordTitle = product['title'].split(' ')[0];

                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Image.network(
                                          product['image'],
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        firstWordTitle ,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        product['title'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      
                                      Text(
                                        "\$${product['price']}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: InkWell(
                                    onTap: () => toggleFavorite(productId),
                                    child: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
