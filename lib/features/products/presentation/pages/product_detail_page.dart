import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentImageIndex = 0;
  int _quantity = 1;
  bool _isFavorite = false;

  final List<String> _images = List.generate(3, (index) => 'image_$index');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: [
                  Expanded(
                    child: CarouselSlider.builder(
                      itemCount: _images.length,
                      options: CarouselOptions(
                        height: 300,
                        viewportFraction: 1.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                      ),
                      itemBuilder: (context, index, realIndex) {
                        return Container(
                          color: AppColors.background,
                          child: const Center(
                            child: Icon(
                              Icons.medical_services,
                              size: 100,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedSmoothIndicator(
                    activeIndex: _currentImageIndex,
                    count: _images.length,
                    effect: const WormEffect(
                      dotColor: AppColors.divider,
                      activeDotColor: AppColors.primary,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Product info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Obat Resep',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Product name
                  Text(
                    'Produk ${widget.productId}',
                    style: AppTextStyles.heading2,
                  ),

                  const SizedBox(height: 8),

                  // Rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 20,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '4.5',
                        style: AppTextStyles.subtitle2,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(250 reviews)',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Terjual 1.2k',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Price
                  Row(
                    children: [
                      const Text(
                        'Rp 150.000',
                        style: AppTextStyles.price,
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '-20%',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Rp 187.500',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Divider
                  const Divider(),

                  const SizedBox(height: 16),

                  // Description
                  const Text(
                    'Deskripsi Produk',
                    style: AppTextStyles.heading4,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                    'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                    'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Composition
                  const Text(
                    'Komposisi',
                    style: AppTextStyles.heading4,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Paracetamol 500mg, Caffeine 65mg',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Indication
                  const Text(
                    'Indikasi',
                    style: AppTextStyles.heading4,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Menurunkan demam, meredakan nyeri ringan hingga sedang',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Dosage
                  const Text(
                    'Dosis & Aturan Pakai',
                    style: AppTextStyles.heading4,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dewasa: 1-2 tablet, 3-4 kali sehari\n'
                    'Anak 6-12 tahun: 1/2-1 tablet, 3-4 kali sehari',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Warning
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.warning.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Perhatian',
                                style: AppTextStyles.subtitle2,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Harus dengan resep dokter. Baca aturan pakai dengan teliti.',
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Quantity selector
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.divider),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (_quantity > 1) {
                          setState(() => _quantity--);
                        }
                      },
                    ),
                    Text(
                      '$_quantity',
                      style: AppTextStyles.subtitle1,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() => _quantity++);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Add to cart button
              Expanded(
                child: PrimaryButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Produk ditambahkan ke keranjang'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  text: 'Tambah ke Keranjang',
                  icon: Icons.shopping_cart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
