import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final dynamic product;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const ProductScreen({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool showFullDescription = false;
  late bool _isFav;

  @override
  void initState() {
    super.initState();
    _isFav = widget.isFavorite;
  }

  void _handleFavorite() {
    widget.onToggleFavorite();
    setState(() {
      _isFav = !_isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    final titleWords = widget.product['title'].toString().split(' ');
    final brand = titleWords.first;
    final name = widget.product['title'];
    final description = widget.product['description'];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipPath(
                    clipper: CurvedClipper(),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_ios_new),
                          color: Colors.white,
                          iconSize: 30,
                        ),
                        GestureDetector(
                          onTap: _handleFavorite,
                          child: Icon(
                            _isFav ? Icons.favorite : Icons.favorite_border,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Positioned(
                    top: 80,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.network(
                        widget.product['image'],
                        height: 220,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 120),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              brand,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'BiloExtraBold',
                              ),
                            ),
                            Text(
                              '\$${widget.product['price']}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'BiloBold',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'BiloBold',
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1, thickness: 2, color: Color(0xFFE0E0E0)),
                        const SizedBox(height: 16),
                        Text(
                          showFullDescription
                              ? description
                              : '${description.substring(0, 100)}...',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                            fontFamily: 'Bilo',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showFullDescription = !showFullDescription;
                            });
                          },
                          child: Text(
                            showFullDescription ? "Read less" : "Read more",
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'BiloBold',
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1, thickness: 2, color: Color(0xFFE0E0E0)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Rating",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'BiloBold',
                              ),
                            ),
                            Text(
                              '${widget.product['rating']['rate']} from ${widget.product['rating']['count']} Reviews',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.orange,
                                fontFamily: 'Bilo',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                onPressed: () {},
                child: const Text(
                  "ADD TO CART",
                  style: TextStyle(
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'BiloBold',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(size.width / 2, size.height + 40, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
